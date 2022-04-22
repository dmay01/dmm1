function P = pars(P)
% defines the model parameters
% inputs: structure P
% output: P updated with parameter values

% economic parameters
% discount factor
P.beta = 1.04.^(-1/52);
% intertemporal elasticity of substitution
P.sigma = 0.5;
% output elasticity of capital
P.alpha = 0.26;
% depreciation rate
P.delta = 0.05;

% disease parameters
% probability that recovered individuals become susceptible again 
P.pi_s = 0.02;
% probability that a contact between an infected and a susceptible person leads to a new infection 
P.pi_i = 0.8;
% probability that an infected individual recovers
P.pi_r = 0.3;

end