% Master file for Project 1
% Authors: Daniel May (11809922)
%% A2. Plotting of the SIR model
% initialize P_A
P_A = struct();
% define parameters
% probability that recovered individuals become susceptible again 
all_pi_s = [0,0.01,0.03,0.10];
% probability that a contact between an infected and a susceptible person leads to a new infection 
P_A.pi_i = 0.8;
% probability that an infected individual recovers
P_A.pi_r = 0.3;
% generate plots for each pi_s
for i=1:length(all_pi_s)
    % set pi_s
    P_A.pi_s = all_pi_s(i);
    % compute time paths for the SIR model
    [I,S] = compute_path_disease(P_A, 0.01,1-0.01, 300, zeros([1,300+1]));
    % plot paths
    figure;
    t = tiledlayout(2,1);
    plot_A(I, S, 300);
    exportgraphics(t,strcat('fig',string(i),'.pdf'));
end

%% C1. Initial steady state
% define parameter values and functional forms
% initialize P
P = struct();
% define parameters
P = pars(P);
% define functions
P = funforms(P);
% compute steady state for given parameters
P = stst(P);
% report steady state
disp('kss')
disp([P.kss])
disp('css')
disp([P.css])
disp('wss')
disp(P.FL(P.kss,1))
disp('Rss')
disp(P.FK(P.kss,1))
%% C2. Scenario without vaccination
% define parameter values and functional forms
% initialize P
Pnew = struct();
% define parameters
Pnew = pars(Pnew);
% define functions
Pnew = funforms(Pnew);
% compute steady state for given parameters
Pnew = stst_full(Pnew);
% a) report steady state
disp('kss')
disp([Pnew.kss])
disp('css')
disp([Pnew.css])
disp('Iss')
disp(Pnew.Iss)
disp('Sss')
disp(Pnew.Sss)

% equilibrium path
Pnew.p = 1;
T = 300;
% set initial values
k0 = P.kss;
I0 = 0.01;
S0 = 1 - I0;
a = zeros([1,T+1]);
[c,k,I,S] = compute_path(Pnew,k0,I0,S0,a,T);
 
% b) plot path in (k,c)-plane
fig = figure;
plot(P.kss,P.css,'r.','MarkerSize',20);
hold on
plot(Pnew.kss,Pnew.css,'b.','MarkerSize',20);
plot(k,c,'b-');
hold off
xlabel('k');
ylabel('c');
legend('initial steady state','new steady state','time path', 'Location', 'northwest');
exportgraphics(fig,'k_c_without.pdf');

% plot time paths of c and k, l, Y
fig = figure;
subplot(2,2,1);
plot([0,T],[P.css,P.css],'r-',0:T,c(1:(T+1)),'b-',[0,T],[Pnew.css,Pnew.css],'k--');
legend('initial steady state','time path','new steady state', 'Location', 'southeast');
xlim([0,T]);
title('consumption');
xlabel('time');

subplot(2,2,2);
plot([0,T],[P.kss,P.kss],'r-',0:T,k(1:(T+1)),'b-',[0,T],[Pnew.kss,Pnew.kss],'k--');
legend('initial steady state','time path','new steady state', 'Location', 'southeast');
xlim([0,T]);
xlabel('time');
title('capital');

subplot(2,2,3);
plot([0,T],[1,1],'r-',0:T,1-I(1:(T+1)),'b-',[0,T],[1-Pnew.Iss,1-Pnew.Iss],'k--');
legend('initial steady state','time path','new steady state', 'Location', 'southeast');
xlim([0,T]);
title('labour');
xlabel('time');

subplot(2,2,4);
plot([0,T],[P.F(P.kss,1),P.F(P.kss,1)],'r-',0:T,P.F(k(1:(T+1)),1-I(1:(T+1))),'b-',[0,T],[P.F(Pnew.kss,1-Pnew.Iss),P.F(Pnew.kss,1-Pnew.Iss)],'k--');
legend('initial steady state','time path','new steady state', 'Location', 'southeast');
xlim([0,T]);
xlabel('time');
title('output');
exportgraphics(fig,'time_path_economy_without.pdf');

% plot time paths of I, S
fig = figure;
subplot(2,1,1);
plot([0,T],[0,0],'r-',0:T,I(1:(T+1)),'b-',[0,T],[Pnew.Iss,Pnew.Iss],'k--');
legend('initial steady state','time path','new steady state');
xlim([0,T]);
title('infected');
xlabel('time');

subplot(2,1,2);
plot([0,T],[1,1],'r-',0:T,S(1:(T+1)),'b-',[0,T],[Pnew.Sss,Pnew.Sss],'k--');
legend('initial steady state','time path','new steady state');
xlim([0,T]);
xlabel('time');
title('susceptible');
exportgraphics(fig,'time_path_disease_without.pdf');

%% C3. Scenario with imemdiate vaccination
% define parameter values and functional forms
% initialize P
Pnew = struct();
% define parameters
Pnew = pars(Pnew);
Pnew.p = 50;
a = (P.pi_s/P.pi_r)*(P.pi_i-P.pi_r);
% define functions
Pnew = funforms(Pnew);
% compute steady state for given parameters
Pnew = stst_full_vacc(Pnew,a);
% a) report steady state
disp('kss')
disp([Pnew.kss])
disp('css')
disp([Pnew.css])
disp('Iss')
disp(Pnew.Iss)
disp('Sss')
disp(Pnew.Sss)

% equilibrium path
T = 300;
% set initial values
k0 = P.kss;
I0 = 0.01;
S0 = 1 - I0;
a = a*ones([1,T+1]);
[c,k,I,S] = compute_path(Pnew,k0,I0,S0,a,T);
 
% b) plot path in (k,c)-plane
fig = figure;
plot(P.kss,P.css,'r.','MarkerSize',20);
hold on
plot(Pnew.kss,Pnew.css,'b.','MarkerSize',20);
plot(k,c,'b-');
hold off
xlabel('k');
ylabel('c');
legend('initial steady state','new steady state','time path', 'Location', 'northwest');
exportgraphics(fig,'k_c_full.pdf');

% plot time paths of c and k, l, Y
fig = figure;
subplot(2,2,1);
plot([0,T],[P.css,P.css],'r-',0:T,c(1:(T+1)),'b-',[0,T],[Pnew.css,Pnew.css],'k--');
legend('initial steady state','time path','new steady state', 'Location', 'southeast');
xlim([0,T]);
title('consumption');
xlabel('time');

subplot(2,2,2);
plot([0,T],[P.kss,P.kss],'r-',0:T,k(1:(T+1)),'b-',[0,T],[Pnew.kss,Pnew.kss],'k--');
legend('initial steady state','time path','new steady state', 'Location', 'southeast');
xlim([0,T]);
xlabel('time');
title('capital');

subplot(2,2,3);
plot([0,T],[1,1],'r-',0:T,1-I(1:(T+1)),'b-',[0,T],[1-Pnew.Iss,1-Pnew.Iss],'k--');
legend('initial steady state','time path','new steady state', 'Location', 'southeast');
xlim([0,T]);
title('labour');
xlabel('time');

subplot(2,2,4);
plot([0,T],[P.F(P.kss,1),P.F(P.kss,1)],'r-',0:T,P.F(k(1:(T+1)),1-I(1:(T+1))),'b-',[0,T],[P.F(Pnew.kss,1-Pnew.Iss),P.F(Pnew.kss,1-Pnew.Iss)],'k--');
legend('initial steady state','time path','new steady state', 'Location', 'southeast');
xlim([0,T]);
xlabel('time');
title('output');
exportgraphics(fig,'time_path_economy_full.pdf');

% plot time paths of I, S
fig = figure;
subplot(2,1,1);
plot([0,T],[0,0],'r-',0:T,I(1:(T+1)),'b-',[0,T],[Pnew.Iss,Pnew.Iss],'k--');
legend('initial steady state','time path','new steady state');
xlim([0,T]);
title('infected');
xlabel('time');

subplot(2,1,2);
plot([0,T],[1,1],'r-',0:T,S(1:(T+1)),'b-',[0,T],[Pnew.Sss,Pnew.Sss],'k--');
legend('initial steady state','time path','new steady state');
xlim([0,T]);
xlabel('time');
title('susceptible');
exportgraphics(fig,'time_path_disease_full.pdf');

%% C3. (c) finding optimal vaccination rate
% 101 possible vaccination rates
T = 600;
t = 0:T;
a_grid = 0:a(1)/100:a(1);
utility = ones([1,length(a_grid)]);
% calculate utility for each vacc share
for i=1:length(a_grid)
    a_tmp = a_grid(i)*ones([1,T+1]);
    Pnew = stst_full_vacc(Pnew,a_tmp(1));
    [c_tmp,~,~,~] = compute_path(Pnew,k0,I0,S0,a_tmp,T);
    utility(i) = sum(P.beta.^t.*P.u(c_tmp))+((P.beta^(T+1))/(1-P.beta))*P.u(Pnew.css);
end
[max_u, index] = max(utility);
disp('max utility of ')
disp(max_u);
disp('at vaccination rate a = ')
disp(a_grid(index));
% plot utility against vacc rate
fig = figure;
plot(a_grid(1:length(a_grid)),utility(1:length(a_grid)),'b-');
legend('utility');
xlim([a_grid(1),a_grid(end)]);
xlabel('vaccination rate');
title('utility by vaccination');
exportgraphics(fig,'utility_by_vaccination.pdf');
% calculate costs of vaccination in final steady state
Pnew = stst_full_vacc(Pnew,a_grid(index));

Qss=Pnew.p*a_grid(index)^2*(1-Pnew.Iss);
yss=P.F(Pnew.kss,1-Pnew.Iss);
disp('Costs of the vaccination program as fraction of the output in the final steady state:');
disp(Qss/yss);

%% C4 check colleague's solution
load("planner_policy.mat");
T = 400;
[c,k,I,S] = compute_path(Pnew,k0,I0,S0,a,T);
fig = figure;
% plot optimal vacc share by S/(1-I)
scatter(S./(1-I),a);
legend('optimal a');
xlabel('S/(1-I)');
title('vaccination rate by S/(1-I)');
exportgraphics(fig,'vaccbydisease.pdf');

%% C5 
t=0:T;
% numerically solve the lost fraction of consumption
constant_share = fzero(@(s) max_u-(sum(P.beta.^t.*P.u(c.*(1-s)))+((P.beta^(T+1))/(1-P.beta))*P.u(c(end)*(1-s))),[-0.00001,0.99999]);
disp('constant share of lost consumption');
disp(constant_share);

%% C6 quicker recovery after one year
% define parameter values and functional forms
% initialize P
Pnew = struct();
% define parameters
Pnew = pars(Pnew);
% define functions
Pnew = funforms(Pnew);

% equilibrium path
Pnew.p = 1;
T = 300;
% set initial values
k0 = P.kss;
I0 = 0.01;
S0 = 1 - I0;
a = zeros([1,T+1]);
Pnew = stst_full(Pnew);

[c_1,k_1,I_1,S_1] = compute_path(Pnew,k0,I0,S0,a,T);
% set new  recovery probability
Pnew.pi_r = 0.35;
[c_2,k_2,I_2,S_2] = compute_path(Pnew,k_1(52),I_1(52),S_1(52),a,T);
c = [c_1(1:52),c_2(1:249)];
k = [k_1(1:52),k_2(1:249)];
I = [I_1(1:52),I_2(1:249)];
S = [S_1(1:52),S_2(1:249)];
% plot time paths of c and k, l, Y
fig = figure;
subplot(2,2,1);
plot(0:T,c(1:(T+1)),'b-');
xlim([0,T]);
title('consumption');
xlabel('time');

subplot(2,2,2);
plot(0:T,k(1:(T+1)),'b-');
xlim([0,T]);
xlabel('time');
title('capital');

subplot(2,2,3);
plot(0:T,1-I(1:(T+1)),'b-');
xlim([0,T]);
title('labour');
xlabel('time');

subplot(2,2,4);
plot(0:T,P.F(k(1:(T+1)),1-I(1:(T+1))),'b-');
xlim([0,T]);
xlabel('time');
title('output');
exportgraphics(fig,'time_path_economy_jump.pdf');

% plot time paths of I, S
fig = figure;
subplot(2,1,1);
plot(0:T,I(1:(T+1)),'b-');
xlim([0,T]);
title('infected');
xlabel('time');

subplot(2,1,2);
plot(0:T,S(1:(T+1)),'b-');
xlim([0,T]);
xlabel('time');
title('susceptible');
exportgraphics(fig,'time_path_disease_jump.pdf');