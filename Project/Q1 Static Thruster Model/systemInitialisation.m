clear;
close all;
clc;
%% Load Input Data
% data10V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','10 V');
% data12V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','12 V');
data14V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','14 V');
% data16V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','16 V');
% data18V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','18 V');
% data20V = xlsread('T200-Public-Performance-Data-10-20V-September-2019.xlsx','20 V');

%% Create simulated experimental data
% Prior Parameters
prior.np = 2;
prior.nm = 2;
prior.D  = 0.1;
prior.T  = 200;
prior.Q = 1e-10*eye(prior.np);         
prior.R = 1e-10*eye(prior.nm);
prior.S = 0.001*eye(prior.nm);
prior.C = [1 0;0 1];            

% Inputs with added noise covariance R
u = data14V(:,1)';
    
% Prior Correct Unknown Values
prior.theta(1) = 0.25;                 % J
prior.theta(2) = 0.025;                % ke
prior.theta(3) = 0.1;                  % kf

x(:,1) = [0; 0];

for t = 1:length(u)
    % State space model
    x(:,t+1) = StaticThrusterModel(x(:,t),u(:,t),prior.theta,prior) + sqrtm(prior.Q)*randn(prior.np,1);
    
    % Output with Sensor transformation and added noise covarince Q
    y(:,t)   = prior.C*x(:,t) + sqrtm(prior.R)*randn(prior.nm,1);
end

subplot(311)
hold on
plot(u);
title("Input");

subplot(312)
hold on
plot(y(1,:));
title("Omega");

subplot(313)
hold on
plot(y(2,:));
title("current");


%% Save Meaurement and input data
% save('systemInitialisation.mat','u','y','prior');