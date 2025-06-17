function [VV,dVdH] = ut_work(par,HH)
% Additive separable

VV = -HH.^2/2;

dVdH = -HH;

end

