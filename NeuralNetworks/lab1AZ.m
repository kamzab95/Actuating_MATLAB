clear all;

ff = @simple_fitness;
maxit=200;
maxcost=9999999;
popsize=6;
mutrate=0.001;
nbits=10;
npar=1;
Nt=nbits*npar;
iga=0;

while iga < maxit
    iga=iga+1
    pop=round(rand(popsize, Nt));
    cost=feval(ff, pop)
    [cost, ind] = sort(cost, 'descend');
    pop=pop(ind,:);
    maxc(1)=max(cost);
    meanc(1)=mean(cost);
    probs=cost/sum(cost);

    mate=[];
    for i=1:popsize
        run=rand(1);
        partsum=probs(1);j=1;
        while partsum < run
            j=j+1;
            partsum=partsum+probs(j);
        end
        mate=[mate; pop(j,:)];
    end

    for i=1:popsize/2
        xp=ceil(rand(1)*(Nt-1));
        npop(i,:)=[mate(i,1:xp) mate(i+3, (xp+1):Nt)];
        npop(i+3,:)=[mate(i+3,1:xp) mate(i,(xp+1):Nt)];
    end
    hold on;
    plot([iga, iga, iga, iga, iga, iga], cost,'r*')
    pop = npop;
end

function y = simple_fitness(x)
    y = sum(x, 2);
end
