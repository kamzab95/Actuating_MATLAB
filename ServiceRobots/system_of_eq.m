syms a b x y


enq = [-sin(a+b)-sin(a) == 1, 
    cos(a+b)+cos(a)+1 == 1];
var = [a, b];

[sola, solb] = solve(enq)

a = round(radtodeg(sola))
b = round(radtodeg(solb))