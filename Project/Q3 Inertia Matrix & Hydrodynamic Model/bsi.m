function xs = bsi(x,wp,u,theta,param,par,prior)

% Unpack Parameters
n  = par.n;
M  = par.M;
Ms = par.Ms;
N  = par.N;
Q  = param.Q;

% Sample at time t = N
xs = zeros(n,Ms,N);
b  = randsample(M,Ms,true,exp(wp(:,N)));
xs(:,:,N) = x(:,b,N);

% Compute constants
const = -0.5*(n*log(2*pi) + log(det(Q)));

% Run backward simulator
for t = N-1:-1:1
   for j = 1:Ms
        % Compute required weights and normalise them (log-weights)
        xx      = x(:,:,t);
        ee      = xs(:,j,t+1) - RigidBodyModel(param,prior,xx,u(:,t),theta);
        eebar   = Q\ee;
        ws = wp(:,t) + const - 0.5*sum(ee.*eebar)';
        
        % Normalise log-weights
        mw = max(ws);
        ws = ws - mw - log(sum(exp(ws - mw)));
        
        % Sample a single integer from the above computed log-weghts
        b  = randsample(M,1,true,exp(ws));
        xs(:,j,t) = x(:,b,t);
   end
end
end
