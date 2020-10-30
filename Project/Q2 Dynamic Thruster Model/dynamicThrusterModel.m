function [xp1] = dynamicThrusterModel(x,tau,theta,param)
%DYNAMIC THRUSTER MODEL This is a discrete euler approximation
%% References
% T. I. Fossen and M. Blanke, "Nonlinear output feedback control of 
% underwater vehicle propellers using feedback form estimated axial flow 
% velocity," in IEEE Journal of Oceanic Engineering, vol. 25, no. 2, pp. 241-255, April 2000, doi: 10.1109/48.838987.

%% Unpack Parameters
% k = theta(1);
% c = theta(2);
% m = theta(3);
Ts = param.D;

%% Euler Discretisation of Dynamic Thruster Process Model
% H*dx + D0*x + D1(x,y)*x + |n|*E*x = f(n)
%                                 y = h'*x
% 2*pi*Jm*dn + Kn*n + abs(n)*(Qnn*n - QnVa*Va) = tau
% x = [u;Va;n]
rho        = 997;
A_thruster = 0.339;
A_surge    = 0.1;
l          = 0.013;
gamma      = 1;
T_surge    = 5;
t          = 0.1;
w          = 0.2;
D          = 0.076;
alpha      = [1 1];
beta       = [1 1];
Kn         = 1;
Jm         = 1;
Cd         = 1;

m    = 9.5;
mf   = rho*A_thruster*l*gamma;
Xdu  = 0.05*m;
Xu   = (Xdu - m)/T_surge;
Xuu  = -0.5*rho*Cd*A_surge;
df   = -Xuu/((1-t)*w^2);
d0   = -Xu/((1-t)*w);

Tnn  = rho*D^4*alpha(2);
TnVa = rho*D^3*alpha(1);
Qnn  = rho*D^5*beta(2);
QnVa = rho*D^4*beta(1);


H   = [m - Xdu,  0, 0;
       0      , mf, 0;
       0      ,  0, 2*pi*Jm];

D0  = [-Xu,  0, 0;
       -d0, d0, 0;
         0,  0, Kn];

D1  = [        -Xuu*abs(x(1,:)),                       0, 0;
       -df*abs(x(2,:) - x(1,:)), df*abs(x(2,:) - x(1,:)), 0;
                              0,                       0, 0];

E   = [0, (1 - t)*TnVa,   0;
       0,         TnVa,   0;
       0,        -QnVa, Qnn];

f   = [(1 - t)*Tnn*x(3,:)*abs(x(3,:));
       Tnn*x(3,:)*abs(x(3,:));
       tau];

dx  = H\(f - (D0 + D1 + abs(x(3,:))*E)*x);

xp1 = [x(1,:) + Ts*(dx(1,:));
       x(2,:) + Ts*(dx(2,:));
       x(3,:) + Ts*(dx(3,:))];
end

