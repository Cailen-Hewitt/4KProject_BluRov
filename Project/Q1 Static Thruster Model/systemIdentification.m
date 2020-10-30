clear;
clc;

%% Documents and Information
% TODO Add references

%% Load Data
data = load('systemInitialisation.mat');

%% Meaurement and input data
y = data.y;                            % Output data
u = data.u;                            % Input data

%% Store Parameters into structure
param.M     = 100;                     % Number of particles in BPF
param.Ms    = 50;                      % Number of samples from backward simulator (smoother)
param.maxit = 600;                     % Maximum number of EM iterations
param.N     = length(y);	           % Number of time steps
param.np    = 2;                       % Number of Process model states %FIXME
param.nm    = 3;                       % Number of Measurement model states %FIXME
param.D     = 0.1;                     % Time step size
param.P0    = 0.01*eye(param.np);	   % Initial State noise covariance
param.Q     = 0.01*eye(param.np);	   % State process noise covariance
param.R     = 0.01*eye(param.nm);      % State measure noise covariance
param.S     = 0.01*eye(param.nm);      % FIXME What is this
param.C     = [1 0;0 1];     % Measirement model

param.theta(1) = 1;                    % Friction
param.theta(2) = 5;                    % R motor resistance
param.theta(3) = 1;                    % J mass inertia

%% Run EM
[theta,thit,Qest,Rest] = emFFBSi(y,u,param);

%% Plot parameter iterations
plot(thit.')
disp(theta)
disp(Qest)
disp(Rest)
