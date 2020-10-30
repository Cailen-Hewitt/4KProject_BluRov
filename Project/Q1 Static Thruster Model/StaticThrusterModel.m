function [xp1] = StaticThrusterModel(x,u,theta,param)
%STATIC THRUSTER MODEL This is a discrete euler approximation

%% Inputs
% PWM voltage input

%% Unpack Parameters
J  = theta(1);
km = theta(2);
Cd = theta(3);
D = param.D;

%% Euler Discretisation of Static Thruster Process Model
R  = 0.25;                                                % Resistance ohms 
b = 0.5;                                                  % Viscous friction in water
L = 0.005;                                                % Inductance
% r = 0.076;                                                % Propeller Diameter 
% rho = 998;                                                % Density of water at 20C

% dx  = [x(2,:) + K1*u(1,:);                              % Omega
%        -K1*x(1,:) - K2*x(2,:) + u(2,:)];                % Current

% dx  = [(km*((u(1,:)-km*x(1,:))/R)-b*x(1,:).^2)/J;       % Omega
%        (u(1,:)/R)-(km*x(1,:)/R)];                       % Current
   
dx  = [(km*((u(1,:)-km*x(1,:))/R)-b*x(1,:).^2)/J;         % Omega
       (u(1,:)/L)-(R/L)*x(2,:)-(km/L)*x(1,:)];            % Current         
   
xp1 = [x(1,:) + D*(dx(1,:));
       x(2,:) + D*(dx(2,:))];
      

end

