function [x,w] = bpf(y,u,theta,param,seed)

if nargin < 5
    seed = sum(100*clock);
end

rng(seed);

% Unpack Parameters
P0 = param.P0;
Q  = param.Q;
R  = param.R;
C  = param.C;

% Prealloction of variables
np = param.np;
nm = param.nm;
M  = param.M;
N  = param.N;
x  = zeros(np,M,N+1);
w  = zeros(M,N);

% Samples from the initial prediction density p(x(1) | theta) = N([y(1);0;0],P0)
x(:,:,1) = [param.x0] + sqrtm(P0)*randn(np,M);

ll = 0;

for t = 1:N
    % Evaluate log-weights
    e      = y(:,t) - C*x(:,:,t);
    ebar   = R\e;
    w(:,t) = -0.5*(nm*log(2*pi) + log(det(R)) + sum(e.*ebar)');
    
    % Normalise log-weights
    mw     = max(w(:,t));
    w(:,t) = w(:,t) - mw - log(sum(exp(w(:,t) - mw)));
    
    % draw sample from prediction density (mixture density)
    ii         = randsample(M,M,true,exp(w(:,t)));
    x(:,:,t)   = x(:,ii,t);
    x(:,:,t+1) = dynamicThrusterModel(x(:,:,t),u(:,t),theta,param) + sqrtm(Q)*randn(np,M);
end
