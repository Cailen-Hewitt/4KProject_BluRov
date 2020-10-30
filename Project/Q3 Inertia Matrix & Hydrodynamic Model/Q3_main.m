clear
close all
clc

% Load data
data = load('Exp1.mat');
y    = data.y;

prior.Ix  = 16;                                           % Inertia in x direction 
prior.Iy  = 6;                                            % Inertia in y direction
prior.Iz  = 6;                                            % Inertia in z direction
prior.Ixy = 0;                                            % Ixy = Iyx (Fossen) 
prior.Iyz = 0;                                            % Iyz = Izy (Fossen)
prior.Ixz = 0;                                            % Ixz = Izx (Fossen)

% Define Variables 
param.m    = 9.5;                                         % Mass of robot [kg]
param.B    = 1.4;                                         % Buoyancy of robot [kg]
param.D    = 0.1;                                         % Time difference [s]
param.xg   = 0;                                           % CoG of x direction [m]
param.yg   = 0;                                           % CoG of y direction [m]
param.zg   = 0.01;                                        % CoG of z direction [m]
param.Q    = 1e-3*diag([1 1 1 1 1 1]);                    % State noise
param.R    = 1e-3*diag([1 1 1 1 1 1]);                    % Measurement noise
param.meas = diag([1 1 1 1 1 1]);                         % Measurement model
param.u    = [tanh(linspace(-5, 5, 500)); zeros(5,500)];

% Initialise Particle Filter
par.n          = 6;                                       % Number of states
par.M          = 1000;                                    % Number of particles in PF
par.Ms         = 50;                                      % Number of samples from backward simulator (smoother)
par.theta      = [1 1 1];                                 % Initial estimates [Ix Iy Iz]      
par.maxit      = 1000;                                    % Maximum number of EM iterations
par.N          = length(y);

%% Run EM
[thnew,thit]   = emFFBSi(y,param.u,param,par,prior);
save('theta.mat','thit');


%% Generate Data from different Experiments
% Use this function to generate 'experimental' data
% DataGeneration(param, par, prior);

%% Plot theta
load('theta.mat')
plot(thit')
title('Estimation of the Variables');
xlabel('Iterations');
ylabel('Estimated Values');