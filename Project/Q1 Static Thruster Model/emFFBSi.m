function [thnew,thit,Qest,Rest] = emFFBSi(y,u,param)

% Extract theta 
theta = param.theta;

% Save theta iterations in here
thit = [];

% main loop for EM
for k = 1:param.maxit
    % E-step
    [xp,wp,ll] = bpf(y,u,theta,param);
    [xs]       = bsi(xp,wp,u,theta,param);
        
    % M-step
    [theta, param.Q, param.R] = mstep(xs,y,u,theta,param);
    
    % Print iteration and LL estimate
    fprintf('It: %4d, LL = %3.8e, theta = %3.2f %3.2f %3.2f %3.2f\n',k,ll,theta);
    
    % Save theta for later
    thit = [thit theta(:)];
        %FIXME
%     subplot(211);
%     plot(1:param.N, y(1,:), 1:param.N, y(2,:),...
%          1:param.N+1, squeeze(mean(xp(1,:,:),2))', 1:param.N+1,
%          squeeze(mean(xp(2,:,:),2))', ...
%          1:param.N, squeeze(mean(xs(1,:,:),2))', 1:param.N, squeeze(mean(xs(1,:,:),2))')
%     subplot(212);
%     plot(1:k,thit(1,:),1:k,thit(2,:));
%     drawnow;
end

thnew = theta;
Qest  = param.Q;
Rest  = param.R;
