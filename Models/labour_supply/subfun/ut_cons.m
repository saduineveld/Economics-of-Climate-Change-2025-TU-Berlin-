function [UU,dUdC] = ut_cons(par,CC)
% Additive separable

if par.sigma == 1
    UU = log(CC);
else
    UU = 1/(1-par.sigma)*(CC.^(1-par.sigma)-1);
end

dUdC = CC.^-par.sigma;


end

