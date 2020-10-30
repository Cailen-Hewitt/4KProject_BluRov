function xs = bsi(xp,wp,u,theta,param)

% Unpack Parameters
np = param.np;
M  = param.M;
Ms = param.Ms;
N  = param.N;
Q  = param.Q;

% Sample at time t = N
xs = zeros(np,Ms,N);
b  = randsample(M,Ms,true,exp(wp(:,N)));
xs(:,:,N) = xp(:,b,N);

% Compute constants
const = -0.5*(np*log(2*pi) + log(det(Q)));

% Run backward simulator
for t = N-1:-1:1
   for j = 1:Ms
        % Compute required weights and normalise them (log-weights)
        xx      = xp(:,:,t);
        ee      = xs(:,j,t+1) - dynamicThrusterModel(xx,u(:,t),theta,param);
        eebar   = Q\ee;
        ws = wp(:,t) + const - 0.5*sum(ee.*eebar)';
        
        % Normalise log-weights
        mw = max(ws);
        ws = ws - mw - log(sum(exp(ws - mw)));
        
        % Sample a single integer from the above computed log-weghts
        b  = randsample(M,1,true,exp(ws));
        xs(:,j,t) = xp(:,b,t);
   end
end