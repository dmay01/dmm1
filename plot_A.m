function plot_A(I,S,T)
% plot time paths of infected and susceptible
% inputs: P ... parameters
%         I ... time path of infected
%         S ... time path of susceptible
%         T ... last period in the plot
nexttile;
plot(0:T,I(1:(T+1)),'b-');
xlim([0,T]);
ylim([0,0.35]);
xlabel('time');
ylabel('infected');
title('infected');

nexttile;
plot(0:T,S(1:(T+1)),'b-');
xlim([0,T]);
ylim([0,1]);
xlabel('time');
ylabel('susceptible');
title('susceptible');

end