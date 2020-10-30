clear;
close all;
clc;
%% Load Input Data
% data10V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','10 V');
% data12V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','12 V');
% data14V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','14 V');
% data16V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','16 V');
% data18V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','18 V');
% data20V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','20 V');

%% Create simulated experimental data
% Prior Parameters
prior.np = 3;                   % Number of Process model states
prior.nm = 3;                   % Number of Measurement model states
prior.D  = 0.1;                 % Time step size
prior.N  = 600;                 % Number of time steps

prior.Q = 1e-5*eye(prior.np);   % State process noise covariance estimate
prior.R = 1e-3*eye(prior.nm);   % State measure noise covariance estimate
prior.C = [1 0 0];

% Inputs with added noise covariance R
u = [zeros(1,200) ones(1,200) zeros(1,200)];
% u = u + sqrtm(prior.S)*rand(prior.nm,prior.T);

% Prior Correct Unknown Values
prior.theta(1) = 0.4;   % k
prior.theta(2) = 0.7;   % c
prior.theta(3) = 1;     % m

% Prior variables
prior.m   = 0;      % mass of underwater vehicle [kg]
prior.mf  = 0;      % 
prior.d0  = 0;      % 
prior.df  = 0;      % 
prior.Xdu = 0;      % Added mass in surge

x(:,1) = [0;0;1];
for t = 1:length(u)
    % State space model with added noise covariance Q
    x(:,t+1) = dynamicThrusterModel(x(:,t),u(:,t),prior.theta,prior);% + sqrtm(prior.Q)*randn(prior.np,1);
    
    % Output with Sensor transformation and added noise covarince R
    y(:,t)   = prior.C*x(:,t) + sqrtm(prior.R)*randn(prior.nm,1);

end

subplot(411)
    plot(u(1,:));
subplot(412)
    plot(x(1,:));
subplot(413)
    plot(x(2,:));
subplot(414)
    plot(x(3,:));

%% Save Meaurement and input data
save('systemInitialisation.mat','u','y','prior');