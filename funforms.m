function P = funforms(P)
% defines production and utility function etc.
% inputs: parameters P
% output: P updated with several functions

% production function
P.F  = @(K,L) K.^P.alpha.*L.^(1-P.alpha);
% marginal products
P.FK = @(K,L) P.alpha*K.^(P.alpha-1).*L.^(1-P.alpha);
P.FL = @(K,L) (1-P.alpha)*K.^P.alpha.*L.^(-P.alpha);

% utility function
if P.sigma == 1
    P.u = @(c) log(c);
else
    P.u = @(c) (c.^(1-1/P.sigma)-1)/(1-1/P.sigma);
end
% marginal utility
P.du = @(c) c.^(-1/P.sigma);

end