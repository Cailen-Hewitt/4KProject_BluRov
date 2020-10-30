clear;
close all
clc;

%% Load Data
load('systemInitialisation.mat');
load('systemIdentification.mat');

%% Store Parameters into structure
param.M     = 100;                  % Number of particles in BPF
param.Ms    = 100;                  % Number of samples from backward simulator (smoother)
param.maxit = 600;                  % Maximum number of EM iterations
param.N     = prior.N;              % Number of time steps
param.np    = prior.np;             % Number of Process model states
param.nm    = prior.nm;             % Number of Measurement model states
param.D     = prior.D;              % Time step size

param.P0    = 1e-2*eye(param.np);	% Initial state noise covariance estimate
param.Q     = 1e-3*eye(param.np);	% State process noise covariance estimate
param.R     = 1e-3*eye(param.nm);   % State measure noise covariance estimate
param.C     = prior.C;              % linear measurement model tranformation matrix
param.x0    = [0;0];                % Initial conditions

param.theta(1) = 1;                 % Initial theta(1) estimate
param.theta(2) = 1;                 % Initial theta(2) estimate
param.theta(3) = 0.5;               % Initial theta(3) estimate

% Process Model Variables

%% Run EM
% [theta,thit,Qest,Rest] = emFFBSi(y,u,param);

%% Plot parameter iterations
plot(thit.')

Qerr = 1e-3*eye(2) - Qest
Rerr = 1e-3*eye(2) - Rest
terr = [0.4;0.7;1] - thit(:,end)