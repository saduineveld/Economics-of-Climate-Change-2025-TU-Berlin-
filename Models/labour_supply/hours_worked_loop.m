restoredefaultpath;

clear all;
%clc;
close all;

dbstop if error;

addpath subfun;

%% Construct meshgrid for X and Y:
H_vec = [0:0.01:2];
C_vec = [0:0.01:2];

%% Parameters
sigma_vec  = [0.5,1,1.5];

if ~exist('figs','dir')
    mkdir('figs')
end


%% Loop over parameter sigma (power in utility of consumption)
options = optimoptions(@fminunc,'Display','off');
H0 = 0.5;
for ii = 1:size(sigma_vec,2)
    par.sigma = sigma_vec(ii);

par.WW      = 1;
% Optimality
obj_min = @(HH)min_tot_ut(par,HH);


[H_star,mUV_star,ex_fl] = fminunc(obj_min,H0,options);
if ex_fl < 1
    error('No proper solution found')
end

% Show solution:

[CONS,HOURS] = ndgrid(C_vec,H_vec);

UT = ut_cons(par,CONS) + ut_work(par,HOURS);

%figure;
%contour(CONS,HOURS,UT,'LineStyle',':','LineWidth',2)
%hold all;
%contour(CONS,HOURS,UT,[-mUV_star -mUV_star],'LineStyle','-','LineWidth',2)

%Budget: Cons = par.WW*H
budget_opt = par.WW*H_star;
Cons_star = par.WW*H_star;

H_budget = C_vec/par.WW;
%plot(C_vec,H_budget,'--','LineWidth',2);
%plot(Cons_star,H_star,'*k','LineWidth',2);

% Demonstrate income & substitution effect

eval(['f',num2str(ii),'=figure;']);

contour(CONS,HOURS,UT,[-mUV_star -mUV_star],'LineStyle','-','LineWidth',2)
hold all;
plot(C_vec,H_budget,'--','LineWidth',2);
plot(Cons_star,H_star,'*k','LineWidth',1);


%% Adjust wage:
par.WW = 1.2;
%% Optimality
obj_min = @(HH)min_tot_ut(par,HH);

[H2,mUV2,ex_fl] = fminunc(obj_min,H0,options);
if ex_fl < 1
    error('No proper solution found')
end
contour(CONS,HOURS,UT,[-mUV2 -mUV2],'LineStyle','-.','LineWidth',2)
hold all;
H_budget = C_vec/par.WW;
plot(C_vec,H_budget,':','LineWidth',2);
Cons2 = par.WW*H2;
plot(Cons2,H2,'*r','LineWidth',1);%'Color','#D95319',

legend({'Contour (base)','Budget (base)','Optimum (base)','Contour (high wage)','Budget (high wage)','Optimum (high wage)'},'Location','best');
grid on;
if par.sigma < 1
    title(['\phi < 1: Wage increase => substitution effect dominates (work more)']);
elseif par.sigma == 1
    title(['\phi = 1: Wage increase => substitution & income effect cancel']);
elseif par.sigma > 1
    title(['\phi > 1: Wage increase => income effect dominates (work less)']);
end

xlabel('Consumption')
ylabel('Hours Worked')

if ii == 1;
   print(f1,['figs/fig_inc_subs1'], '-dpng')
elseif ii == 2;
   print(f2,['figs/fig_inc_subs2'], '-dpng') 
elseif ii == 3;
    print(f3,['figs/fig_inc_subs3'], '-dpng')
end

end










