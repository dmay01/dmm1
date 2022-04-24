function [c,k,I,S] = compute_path(P,k0,I0,S0,a,T)
    % computes equilibrium path (c*,k*,I*,S*) starting from k0,I0,S0
    % inputs: P ... parameters and steady state
    %         k0 ... initial capital
    %         I0 ... initial infected
    %         S0 ... initial susceptible
    %         a  ... sequence of vaccination shares           [ 1 x T+1 ]
    %         T ... last period of simulation
    % output: c ... time path of consumption: c0,...,c_T      [ 1 x T+1 ]
    %         k ... time path of capital:     k0,...,k_T      [ 1 x T+1 ]
    %         I ... time path of infected:    I0,...,I_T      [ 1 x T+1 ]
    %         S ... time path of susceptible: S0,...,S_T      [ 1 x T+1 ]

    %% initial guess for the vector X (from slides)
    % choose something reasonable, adjust if fsolve fails to find a solution
    % guess for c0,...,c_T
    cguess = P.css*ones(1,T+1);
    % guess for k0,...,k_T
    kguess = k0*ones(1,T+1);
    % combine paths
    xguess = [cguess; kguess];    
    % stack columns to get X
    Xguess = xguess(:);   

    % time path of disease
    [I,S] = compute_path_disease(P, I0, S0, T, a);
    
    %% solve H(X)=0 using LBJ
    % number of variables
    n = 2;
    % number of predetermined variables
    m = 1;
    % Jacobian pattern (see slides)
    J = spdiags(ones(T+1,2),[-1,0],T+2,T+1); 
    J = kron(J,ones(n));
    J = J((n-m+1):(end-m),:);
    % set the options
    opts = optimoptions('fsolve','Algorithm','trust-region','JacobPattern',J);
    %opts = optimoptions('fsolve');
    % call fsolve with these options; compute_residuals computes H(X)
    X = fsolve(@(X) compute_residuals(P,k0,I,a,T,X), Xguess, opts);

    %% give back the results
    % if fsolve did not throw an error, X holds the column vector that solves H(X)=0
    % reshape it to get the time paths of our variables
    x = reshape(X,2,T+1);
    c = x(1,:);
    k = x(2,:);
    
    %% check if T has been chosen large enough to allow convergence to the steady state
    if abs(k(end)-P.kss)>1e-3
       warning('Terminal point is not close to the steady state. Consider increasing T.');
    end
    
end