function DataGeneration(param, par, prior)
% Determines states based on different input values
% Meant to simulate experiments

%% States & Inputs
% x   = [u; v; w; p; q; r]
% u = [X; Y; Z; K; M; N];

%% Unpack Initial Inertias
theta(1) = prior.Ix;
theta(2) = prior.Iy;
theta(3) = prior.Iz;

%% Tuning Parameters
R    = 0.001*eye(par.n);

%% Create simulated experimental data
% Initialise states and Inputs
x(:,1) = [0; 0; 0; 0; 0; 0];
u = param.u;

for t = 1:500
    x(:,t+1) = RigidBodyModel(param, prior, x(:,t), u(:,t), theta) + 1e-2*randn(par.n,1); 
end

y = param.meas*x(:,1:end-1) + sqrtm(R)*randn(par.n,500);   

%% Save Meaurement and Input data
% save('Exp2.mat','u','y','x','theta');

end

