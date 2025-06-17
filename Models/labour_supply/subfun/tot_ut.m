function [UV,dUVdH] = tot_ut(par,HH)

CC = par.WW*HH;
[UU,dUdC] = ut_cons(par,CC);

[VV,dVdC] = ut_work(par,HH);

UV = UU + VV;
dUVdH = par.WW*dUdC + dVdC;

end