function [thit,Qest,Rest] = emFFBSi(y,u,param)

% Extract theta 
theta = param.theta;

% Save theta iterations in here
thit = [];

% main loop for EM
for k = 1:param.maxit
    % Estimation step
    [xp,wp] = bpf(y,u,theta,param);
    [xs]    = bsi(xp,wp,u,theta,param);
    
    % Maximisation step
    [theta,param.Q,param.R] = mstep(xs,y,u,theta,param);
    
    % Print iteration and LL estimate
    fprintf('It: %4d, theta = %3.2f %3.2f %3.2f\n',k,theta);
    
    % Save theta for later
    thit = [thit theta(:)];
    
    plot(thit');
    drawnow;
end

Qest  = param.Q;
Rest  = param.R;
