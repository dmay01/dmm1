function P = stst_full_vacc(P,a)
% computes steady state for given parameters for the full model
% inputs: parameters and functions P
%         a vaccination share
% output: P updated by kss ... steady state capital stock
%                      css ... steady state consumption
%                      Iss ... steady state infected population
%                      Sss ... steady state susceptible population

% equation (3) to get S
P.Sss = P.pi_r/P.pi_i;
% equation (4) to get I
P.Iss = (P.pi_s*(1-P.Sss)-a*P.Sss)/(P.pi_i*P.Sss+P.pi_s);
% solve equation from B5. for k
P.kss = fzero(@(k) 1-P.beta*(1+P.FK(k,1-P.Iss)-P.delta),[.1,1000]);
% plug solution into equation (2) to get c
P.css = P.F(P.kss,1-P.Iss) - P.delta*P.kss -P.p*a^2;

end