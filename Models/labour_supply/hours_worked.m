restoredefaultpath;

clear all;
%clc;
close all;

dbstop if error;

addpath subfun;


%% Parameters
par.sigma   = 0.8;
par.WW      = 1;

%% Construct vector hours work
H_vec = [0:0.01:2];

%% Plot marginal costs and benefits, and total utility:
[V_vec,dVdH_vec]    = ut_work(par,H_vec);
[U_vec,dUdC_vec]    = ut_cons(par,par.WW*H_vec);
[UV,dUVdH]      = tot_ut(par,H_vec);


%% Optimality
obj_min = @(HH)min_tot_ut(par,HH);

options = optimoptions(@fminunc,'Display','off');
H0 = 0.5;
[H_star,mUV_star,ex_fl] = fminunc(obj_min,H0,options);
if ex_fl < 1
    error('No proper solution found')
end

% % Plot solution:
LW = 2;
f1 = figure;
%subplot(3,1,1)
%plot(H_vec,U_vec,'LineWidth',LW);
%hold all;
%plot(H_vec,-V_vec,'LineWidth',LW);
%ylim([-2 2])
%legend({'Ut. cons.','Ut. working'},'Location','best')

subplot(2,1,1)
plot(H_vec,par.WW*dUdC_vec,'LineWidth',LW);
hold all;
plot(H_vec,-dVdH_vec,'LineWidth',LW);
%Compute value -dVdH_star
pp = griddedInterpolant(H_vec,-dVdH_vec,'spline');

plot(H_star,pp(H_star),'*k','LineWidth',1)
ylim([0 2.5])
legend({'Marg. Benefit','Marg. Costs','Optimum'},'Location','best')

subplot(2,1,2)
plot(H_vec,UV,'m','LineWidth',LW);
hold all;
plot(H_star,-mUV_star,'*k','LineWidth',1)
legend({'Total Utility','Optimum'},'Location','best')
xlabel('Hours Worked')

if ~exist('figs','dir')
    mkdir('figs')
end

print(f1, ['figs/fig_hours_worked'], '-dpng')

%% Demonstrate income & substitution effect

C_vec = [0:0.01:2];

[CONS,HOURS] = ndgrid(C_vec,H_vec);

UT = ut_cons(par,CONS) + ut_work(par,HOURS);

f2 = figure;
contour(CONS,HOURS,UT,'LineStyle',':','LineWidth',2)
hold all;
contour(CONS,HOURS,UT,[-mUV_star -mUV_star],'LineStyle','-','LineWidth',2)

%Budget: Cons = par.WW*H
budget_opt = par.WW*H_star;
Cons_star = par.WW*H_star;

H_budget = C_vec/par.WW;
plot(C_vec,H_budget,'--','LineWidth',2);
plot(Cons_star,H_star,'*k','LineWidth',2);
xlabel('Consumption')
ylabel('Hours Worked')
title('Indifference Curves & Budget')

print(f2, ['figs/fig_indiff'], '-dpng')










