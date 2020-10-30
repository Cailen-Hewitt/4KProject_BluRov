function [x,w,ll] = bpf(y,u,theta,param,par,prior,seed)
if nargin < 7
    seed = sum(100*clock);
end

rng(seed);

% Unpack Parameters
n = par.n;
N  = par.N;
M  = par.M;
x  = zeros(par.n,M,N+1);
w  = zeros(M,N);
Q = param.Q;
R = param.R;

% Define estimation variables
theta(1) = par.theta(1);
theta(2) = par.theta(2);
theta(3) = par.theta(3);

% Samples from the initial prediction density 
x(:,:,1) = y(:,1) + sqrt(Q)*randn(n,M);

ll = 0;

for t = 1:N
    % Evaluate log-weights
    e      = y(:,t) - param.meas*x(:,:,t);
    ebar   = R\e;
    w(:,t) = -0.5*(n*log(2*pi) + log(det(R)) + sum(e.*ebar));
    
    % Compute log-likelihood
    ll = ll + log(sum(exp(w(:,t)))/M);
    
    % Normalise log-weights
    mw     = max(w(:,t));
    w(:,t) = w(:,t) - mw - log(sum(exp(w(:,t) - mw)));
    
    % draw sample from prediction density (mixture density)
    ii         = randsample(M,M,true,exp(w(:,t)));
    xf         = x(:,ii,t);
    x(:,:,t+1) = RigidBodyModel(param, prior, xf, u(:,t), theta) + sqrtm(Q)*randn(n,M);
end
end
