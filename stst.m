function P = stst(P)
% computes steady state for given parameters
% inputs: parameters and functions P
% output: P updated by kss ... steady state capital stock
%                      css ... steady state consumption

% solve equation from B5. for k
P.kss = fzero(@(k) 1-P.beta*(1+P.FK(k,1)-P.delta),[.1,1000]);
% plug solution into equation (2) to get c
P.css = P.F(P.kss,1) - P.delta*P.kss;

end