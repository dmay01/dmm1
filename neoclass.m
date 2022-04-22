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
    [I,S] = compute_path_A(P_A, 0.01, 300);
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