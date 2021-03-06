function res = compute_residuals(P,k0,I,a,T,X)
    % computes the vector of residuals H(X) from the slides
    % inputs: P ... parameters and steady state
    %         k0 ... initial capital
    %         I  ... time path of infected
    %         a  ... sequence of vaccination shares           [ 1 x T+1 ]
    %         T ... last period of simulation
    %         X ... current guess for c0, k0 ..., c_T, k_T [ 2*(T+1) x 1 ]
    % output: res ... residuals ordered by period

    % reshape X to get the time paths of our variables
    x = reshape(X,2,T+1);
    c = x(1,:);
    k = x(2,:);
    
    %% residuals of the dynamic equations
    % vector of time indices to simplify notation: [1xT]
    t = 1:T;    
    % all Euler equations: [1xT]
    res_ct = P.du(c(t)) - P.beta*(1+P.FK(k(t+1),1-I(t+1))-P.delta).*P.du(c(t+1));
    % all capital accumulation equations: [1xT]
    res_kt = (1-P.delta)*k(t) + P.F(k(t),1-I(t)) - c(t) - P.p.*(a(t).^2).*(1-I(t)) - k(t+1);
    % stack the conditions [4xT]
    res_t = [res_ct; res_kt];
    % turn into column vector, such that dynamic conditions are ordered by period [4*T x 1]
    res_t = res_t(:);
    
    %% residuals of the boundary conditions
    % one initial condition for each predetermined variable
    res_k0 = k(1) - k0;    
    % one terminal condition for each non-predetermined variable
    res_cT = c(end) - P.css;    
    % add initial and terminal conditions (conditions MUST be ordered by period!!)
    res = [ res_k0; res_t; res_cT ];
    
end