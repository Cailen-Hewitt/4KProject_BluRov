function [thnew,thit] = emFFBSi(y, u, param, par, prior)

% Extract theta 
theta = par.theta;

% Save theta iterations in here
thit = [];

% main loop for EM
for k = 1:par.maxit
    % E-step
    [x,wp,ll]  = bpf(y,u,theta,param,par,prior);
    [xs]       = bsi(x,wp,u,theta,param,par,prior);
        
    % M-step
    [theta, Qest, param.R] = mstep(xs,y,u,theta,param,par,prior);
    par.theta = theta;
    
    % Print iteration and LL estimate
    fprintf('It: %4d, LL = %3.8e, theta = %3.2f %3.2f %3.2f\n',k,ll,theta);
    
    % Save theta for later
    thit = [thit theta(:)];
    
end

thnew = theta;
end

