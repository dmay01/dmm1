function [I,S] = compute_path_disease(P, I0, S0, T, a)
    % computes time path (I, S) starting from I0
    % inputs: P ... parameters
    %         I0 ... initially infected people
    %         S0 ... initially susceptible people
    %         T ... last period of simulation
    %         a ... series of vaccination shares
    % output: I ... time path of infected:      I0,...,I_T      [ 1 x T+1 ]
    %         S ... time path of susceptible:   S0,...,I_T      [ 1 x T+1 ]

    % generate arrays for the time paths
    I = ones(1,T+1)*-1;
    S = ones(1,T+1)*-1;
    % initialize the first values
    I(1) = I0;
    S(1) = S0;
    % compute the paths
    for t=1:T
        I(t+1) = (1-P.pi_r)*I(t) + P.pi_i*I(t)*S(t);
        S(t+1) = (1-a(t))*S(t) - P.pi_i*I(t)*S(t) + P.pi_s*(1-I(t)-S(t));
    end
    
end