function [th,ref] = ar2(data,n,varargin)
%AR  Compute AR-models of signals using various approaches.
%
%   MODEL = AR(Y, N)
%     estimates an N:th order autoregressive polynomial model (AR) for time
%     series Y:
%        y(t) + a1*y(t-1) + a2*y(t-2) + ... +aN*y(t-N) = e(t)
%
%     Inputs:
%      Y: The time series to be modeled, an IDDATA object or a column
%         vector of double values. The data object should contain data
%         for one output signal and no input signals. The data must be
%         uniformly sampled. Type "help iddata" for more information.
%         When double values are specified, Y is assumed to be uniformly
%         sampled using a sample time of 1 sec.
%      N: The order of the AR model (positive integer)
%     Output:
%      MODEL: AR model delivered as an IDPOLY object. It has only one
%            active polynomial - "A"; MODEL.a = [1 a1 a2 ... aN]. The
%            estimated variance of the white noise source e(t) is stored
%            in the "NoiseVariance" property of the Model.
%     The model is estimated using "forward-backward" approach with no
%     windowing.
%
%   MODEL = AR(Y, N, APPROACH)
%     uses chosen approach for AR model estimation. The value of APPROACH
%     must be one of the following:
%       'fb' : The forward-backward approach (default)
%       'ls' : The Least Squares method
%       'yw' : The Yule-Walker method
%       'burg': Burg's method
%       'gl' : A geometric lattice method
%
%   MODEL = AR(Y, N, APPROACH, WINDOW)
%     uses the specified window which is used for determining how the data
%     outside the measured time interval (past and future values) should be
%     handled. The value of WINDOW must be one of the following:
%       'now' : No windowing 
%       'prw' : Prewindowing
%       'pow' : Postwindowing
%       'ppw' : pre- and post-windowing
%     'now' is the default for all approaches except 'yw' which always uses
%     'ppw' window.
%
%  [MODEL, REFL] = AR(Y, N, ...)
%     returns the reflection coefficients and loss functions in the matrix
%     REFL when APPROACH is 'burg' or 'gl'. REFL contains the reflection
%     coefficients in the first row, and the corresponding loss function
%     values in the second row.
%
%  [MODEL, ...] = AR(Y, N, ..., 'Name1', Value1, 'Name2', Value2)
%     allows specification of the following attributes as name-value pairs:
%     'Ts': Sample time. Use when Y is specified as double vector rather
%           than an IDDATA object. Specify as a positive scalar. 
%     'IntegrateNoise': TRUE/FALSE. Specifies whether the noise source
%           contains an integrator or not. Default is FALSE. Use it to
%           create "ARI" structure models: A y = e/(1-z^-1).
%           Example:
%           load iddata9 z9
%           Ts = z9.Ts;
%           y = cumsum(z9.y);
%           model = ar(y, 4, 'ls', 'Ts', Ts, 'IntegrateNoise', true)
%
%   MODEL = AR(Y, N, OPTIONS)
%   MODEL = AR(Y, N, 'Name1', Value1, ..., OPTIONS)
%     gives access to additional estimation options such as specifying
%     constant offsets, covariance handling etc in addition to specifying
%     estimation approach and window. Use AROPTIONS to create and configure
%     the option set OPTIONS. For example, use 'ls' estimation approach and
%     choose not to estimate parameter covariance by:
%        opt = arOptions('Approach', 'ls', 'EstCovar', false);
%        model = ar(y, N, opt);
%
%   See also AROPTIONS, IVAR, ARX, ARMAX, IV, NLARX, SSEST.

%   L. Ljung 10-7-87, R.Singh 07-28-2011
%   Copyright 1986-2016 The MathWorks, Inc.

%Note: Ts and TimeUnit, if specified as PV pairs are forced onto data. This
%is unlike the case in other estimators.

ni = nargin;
narginchk(2,Inf)

PVStart = 0; varg = {};
pt = true; % estimate covariance flag
Ts = []; I = [];
if ni>2
   I = find(cellfun(@(x)isa(x,'idoptions.ar'),varargin));
end

if ~isempty(I)
   options = varargin{I(end)};
   varargin(I) = [];
   ni = length(varargin)+2;
else
   options = arOptions;
end

if ni<3 || isempty(varargin{1})
   % no-op
elseif ischar(varargin{1})
   % Could be "approach" or start of PV pair
   v1 = varargin{1};
   if ~isempty(v1) && v1(end)=='0'
      pt = false; % obsolete syntax, where ending '0' denoted no covariance
      v1 = v1(1:end-1);
   end
   Value = ltipack.matchKey(v1,{'fb','ls','yw','burg','gl'});
   if isempty(Value)
      % Assume PV start
      PVStart = 1;
   else
      options.Approach = Value;
   end
end

if ni>3   
   v2 = varargin{2};
   Window = [];
   if PVStart==0
      if isempty(v2), v2 = 'now'; end
      if ~ischar(v2)
         ctrlMsgUtils.error('Ident:general:InvalidSyntax','ar','ar')
      end
      if v2(end)=='0'
         pt = false; % obsolete syntax, where ending '0' denoted no covariance
         v2 = v2(1:end-1);
      end
      Window = ltipack.matchKey(v2,{'now','prw','pow','ppw'});
   end
   
   if isempty(Window)
      if PVStart==0
         % Assume PV start
         PVStart = 2;
      end
   else
      options.Window = Window;
   end
   
   % Trap obsolete syntax: Model = AR(Y,N,Approach,Win,Maxsize,T)
   if PVStart==0 && ni>4 && ni<=6 && isnumeric(varargin{3}) && ...
         (ni<6 || (isnumeric(varargin{4}) && isscalar(varargin{4})))
      options.MaxSize = varargin{3};
      if ni==6
         Ts = varargin{4};
      end      
   else
      if PVStart>0
         varg = varargin(PVStart:end);
      else
         varg = varargin(3:end);
      end
      % Find Ts
      TsInd = idpack.findOptionInList('Ts',varg,2);
      if ~isempty(TsInd)
         Ts = varg{TsInd(end)+1};
         varg([TsInd, TsInd+1]) = [];
      end
   end
elseif PVStart~=0
   ctrlMsgUtils.error('Ident:general:InvalidSyntax','ar','ar')
end

% If PV pairs are supplied, look for 'IntegrateNoise' since its value can
% affect estimation results.
NI = false;
if ~isempty(varg)
   NIInd = idpack.findOptionInList('IntegrateNoise',varg,3);
   if ~isempty(NIInd)
      if length(varg)>NIInd(end)
         NI = varg{NIInd(end)+1};
         if isscalar(NI)
            if isnumeric(NI) && isequal(NI, logical(NI))
               NI = logical(NI);
            elseif ~islogical(NI)
               ctrlMsgUtils.error('Ident:estimation:arNI')
            end
            varg([NIInd, NIInd+1]) = [];
         else
            ctrlMsgUtils.error('Ident:estimation:arNI')
         end
      else
         ctrlMsgUtils.error('Ident:general:InvalidSyntax','ar','ar')
      end        
   end   
end

% Checks on data and order
if isa(data,'frd') || (isa(data,'iddata') && strcmp(pvget(data,'Domain'),'Frequency'))
   ctrlMsgUtils.error('Ident:estimation:estUsingFrequencyData','ar')
else
   if isa(data,'double') && isvector(data)
      data = data(:); 
   end
   data = idpack.utValidateData('ar', data, 'time', true);
   if isempty(data.Name), data.Name = inputname(1); end
   if ~isempty(Ts), data.Ts = Ts; end
   [~, ny, nu] = size(data);
   if ny>1
      ctrlMsgUtils.error('Ident:estimation:arMultiOutput','ar')
   elseif nu>0
      ctrlMsgUtils.error('Ident:estimation:IODataNotAllowed','ar')
   end
   
   yor = pvget(data,'OutputData');
   Ne = numel(yor); Ncaps = cellfun('length',yor);
end

if ~idpack.isPosIntScalar(n)
   ctrlMsgUtils.error('Ident:estimation:arInvalidOrder')
end

if ~isempty(varg)
   if rem(length(varg),2)~=0
      ctrlMsgUtils.error('Ident:general:CompleteOptionsValuePairs','ar','ar')
   else
      % look for maxsize
      maxsizeInd = idpack.findOptionInList('MaxSize',varg,1);
      if ~isempty(maxsizeInd)
         options.MaxSize = varg{maxsizeInd+1};
         varg([maxsizeInd, maxsizeInd+1]) = [];
      end
   end
end

options.EstCovar = pt; pt1 = pt;

% Perform estimation.
ref = [];
maxsize = options.MaxSize;
if ischar(maxsize), maxsize = 250e3; end 
approach = options.Approach;
win = options.Window;
yOff = options.DataOffset;

if NI
   for kexp = 1:Ne
      yor{kexp} = diff(yor{kexp});
   end
   Ncaps = Ncaps-1;
elseif ~isempty(yOff) || ~isequal(yOff,0)
   yOff = idpack.checkOffsetSize(yOff,'DataOffset',[1 Ne]);
   for kexp = 1:Ne
      yor{kexp} = yor{kexp} - yOff(kexp);
   end
end

y = yor; % Keep the original y for later computation of e

if strcmp(approach,'yw'), win = 'ppw'; end
if strcmp(win,'prw') || strcmp(win,'ppw')
   for kexp = 1:Ne
      y{kexp} = [zeros(n,1);y{kexp}];
   end
   Ncaps = Ncaps+n;
end

if strcmp(win,'pow') ||  strcmp(win,'ppw')
   for kexp = 1:Ne
      y{kexp} = [y{kexp};zeros(n,1)];
   end
   Ncaps = Ncaps+n;
end

% First the lattice based algorithms
if any(strcmp(approach,{'burg','gl'}))
   ef = y; eb = y;
   rho = zeros(1,n+1);
   r = zeros(1,n);
   A = r;
   [ss,l] = sumcell(y,1,Ncaps);
   rho(1) = ss/l;
   for p = 1:n
      nef = sumcell(ef,p+1,Ncaps);
      neb = sumcell(eb,p,Ncaps-1);
      if strcmp(approach,'gl')
         den = sqrt(nef*neb);
      else
         den = (nef+neb)/2;
      end
      ss = 0;
      for kexp = 1:Ne
         ss = ss+(-eb{kexp}(p:Ncaps(kexp)-1)'*ef{kexp}(p+1:Ncaps(kexp)));
      end
      
      r(p) = ss/den;
      A(p) = r(p);
      A(1:p-1) = A(1:p-1)+r(p)*conj(A(p-1:-1:1));
      rho(p+1) = rho(p)*(1-r(p)*r(p));
      efold = ef;
      for kexp = 1:Ne
         Ncap = Ncaps(kexp);
         ef{kexp}(2:Ncap) = ef{kexp}(2:Ncap)+r(p)*eb{kexp}(1:Ncap-1);
         eb{kexp}(2:Ncap) = eb{kexp}(1:Ncap-1)+conj(r(p))*efold{kexp}(2:Ncap);
      end
   end
   Apoly = [1 A]; %th = pvset(th,'a',[1 A]);
   ref = [0 r ; rho];
else
   pt1 = true; % override pt for the other approaches
end

covR = [];

% Now compute the regression matrix
if pt1
   nmax = n;
   M = floor(maxsize/n);
   R1 = zeros(0,n+1);
   fb = strcmp(approach,'fb');
   if strcmp(approach,'fb')
      R2 = zeros(0,n+1);
      yb = cell(1,Ne);
      for kexp = 1:Ne
         yb{kexp} = conj(y{kexp}(Ncaps(kexp):-1:1));
      end
   end
   for kexp = 1:Ne
      Ncap = Ncaps(kexp);
      yy = y{kexp};
      for k = nmax:M:Ncap-1
         jj = (k+1:min(Ncap,k+M));
         phi = zeros(length(jj),n);
         if fb
            phib = zeros(length(jj),n);
         end
         for k1 = 1:n
            phi(:,k1) = -yy(jj-k1);
         end
         if fb
            for k2 = 1:n
               phib(:,k2) = -yb{kexp}(jj-k2);
            end
         end
         if fb
            R2 = triu(qr([R2;[[phi;phib],[yy(jj);yb{kexp}(jj)]]]));
            [nRr,nRc] = size(R2);
            R2 = R2(1:min(nRr,nRc),:);
         end
         R1 = triu(qr([R1; [phi,yy(jj)]]));
         [nRr,nRc] = size(R1);
         R1 = R1(1:min(nRr,nRc),:);
      end
   end
   
   covR = R1(1:n,1:n);
   P = pinv(covR);
   if ~any(strcmp(approach,{'burg','gl'}))
      if ~fb
         A = (P * R1(1:n,n+1)).';
      else
         A = (pinv(R2(1:n,1:n)) * R2(1:n,n+1)).';
      end
      Apoly = [1 A]; % th = pvset(th,'a',[1 A]);
   end
   %P = P*P';
end

e = []; yp = cell(1,Ne);
for kexp = 1:Ne
   tt = filter([1 A],1,yor{kexp});
   tt(1:n) = zeros(n,1);
   e = [e; tt]; %#ok<AGROW>
   yp{kexp} = yor{kexp} - tt;
end

lam = e'*e/(length(e)-n);
if pt
   cov = idpack.FactoredCovariance(covR/sqrt(lam),[],true(n,1));
else
   cov = [];
end

S = pmodel.polynomial({Apoly},[],[],[],[],zeros(1,0));
S.IntegrateNoise = NI;
Tsdat = pvget(data,'Ts'); Tsdat = Tsdat{1};
PolyData = idpack.polydata(S,Tsdat);
PolyData.Covariance = cov;
PolyData.EstimationOptions = options;

DataStruct = unpack(data);
Info = idresults.GenericParametric;
Fit = Info.Fit;
Fit.LossFcn = e'*e/length(e);
[NV, Fit.FPE, Fit.AIC, Fit.AICc, Fit.nAIC, Fit.BIC] = ...
   idpack.utComputeMetrics(e, length(e), n, 1, DataStruct.IsReal); 
[Fit.FitPercent, Fit.MSE] = idpack.utFitPercent(yp,yor,true);
PolyData.NoiseVariance = NV;
Info.Fit = Fit;
Info.Status = ctrlMsgUtils.message('Ident:estimation:msgStatusValue2','AR');
Info.Method = sprintf('AR (''%s/%s'')',approach, win);
Info.RandState = rng;

Info.DataUsed = idresults.estimDataReport(Info.DataUsed, DataStruct, [], yOff);
PolyData.Report = Info;
PolyData.EstimationStatus = 1;

th = idpoly.make(PolyData,[1 0]);
if ~isempty(varg)  % b.c.
   th = set(th, varg{:}); 
   th = setcov(th, PolyData.Covariance);
   th = setEstimationStatus(th, 1);
end

th = copyEstimationDataMetaData(th, data);
th.TimeUnit = data.TimeUnit;

%--------------------------------------------------------------------------
function [s,ln] = sumcell(y,p,N)

ln = 0;
s = 0;
for kexp = 1:length(y)
   y1 = y{kexp};
   s = s+y1(p:N(kexp))'*y1(p:N(kexp));
   ln = ln + length(y1);
end
