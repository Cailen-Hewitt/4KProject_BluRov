function proc = RigidBodyModel(param, prior, x, u, theta)
% Makes the rigid body process model of the BlueROV2
% The model came from this paper:
% https://flex.flinders.edu.au/file/27aa0064-9de2-441c-8a17-655405d5fc2e/1/ThesisWu2018.pdf?fbclid=IwAR1vlUQtEFovlqo7rS43w8GCuDO9OH2ibywPMj2Ni2y8uVFqqrk1sJk1Dho

%% Unpack Parameters
m  = param.m;
Ts = param.D;
xg = param.xg;
yg = param.yg;
zg = param.zg;

%% Define Parameters that will be estimated
Ix  = theta(1);
Iy  = theta(2);
Iz  = theta(3);
Ixy = prior.Ixy;
Iyz = prior.Iyz;
Ixz = prior.Ixz;

%% Define Added Masses
Xu = 0.1;
Yv = 0.2;
Zw = 0.1;
Kp = 0;
Mq = 0;
Nr = 0;

%% Find the Process Model
% Mass matrix [1]
MRB = [m 0 0 0 m*zg -m*yg;
       0 m 0 -m*zg 0 m*xg;
       0 0 m m*yg -m*xg 0;
       0 -m*zg m*yg Ix -Ixy -Ixz;
       m*zg 0 -m*xg -Ixy Iy -Iyz;
       -m*yg m*xg 0 -Ixz -Iyz Iz];

% Coriolis matrix*x [1]
CRB = [m.*x(3,:).*x(5,:);
       -m.*x(3,:).*x(4,:);
       m.*x(2,:).*x(4,:) - m.*x(1,:).*x(5,:);
       m.*x(3,:).*x(2,:) - m.*x(2,:).*x(3,:) + Iz.*x(6,:).*x(4,:) + Iy.*x(5,:).*x(6,:);
       -m.*x(3,:).*x(1,:) - m.*x(1,:).*x(3,:) + Iz.*x(6,:).*x(4,:) + Ix.*x(4,:).*x(6,:);
       m.*x(2,:).*x(1,:) - m.*x(1,:).*x(2,:) + Iy.*x(5,:).*x(4,:) - Ix.*x(4,:).*x(5,:)];
 
% Added mass matrix [1]
MA  = -diag([Xu Yv Zw Kp Mq Nr]);

% Added Coriolis matrix*x [1]
CA = [Zw.*x(3,:).*x(5,:);
      -Zw.*x(3,:).*x(4,:) - Xu.*x(1,:).*x(6,:);
      -Yv.*x(2,:).*x(4,:) + Xu.*x(1,:).*x(5,:);
      -Zw.*x(3,:).*x(2,:) + Yv.*x(2,:).*x(3,:) - Nr.*x(6,:).*x(5,:) + Mq.*x(5,:).*x(6,:);
      Zw.*x(3,:).*x(1,:) - Xu.*x(1,:).*x(3,:) + Nr.*x(6,:).*x(4,:) - Kp.*x(4,:).*x(6,:);
      -Yv.*x(2,:).*x(1,:) + Xu.*x(1,:).*x(2,:) - Mq.*x(5,:).*x(4,:) + Kp.*x(4,:).*x(5,:)];

% Hydrodynamic damping matrix [1]
D = [Xu.*x(1,:);
     Yv.*x(2,:);
     Zw.*x(3,:);
     Kp.*x(4,:);
     Mq.*x(5,:);
     Nr.*x(6,:)];

% Hydrostatic Model [1]
% G = [(m-B)*sin(theta);
%      -(m-B)*cos(theta)*sin(phi);
%      -(m-B)*cos(theta)*cos(phi);
%      zg*m*cos(theta)*sin(phi);
%      zg*m*sin(theta);
%      0];

% Derivative of states [1]
dx = (MRB + MA)\(u - (CRB + CA) - D);

% Descritisation of model
proc = [x(1,:) + Ts*dx(1,:);
        x(2,:) + Ts*dx(2,:);
        x(3,:) + Ts*dx(3,:);
        x(4,:) + Ts*dx(4,:);
        x(5,:) + Ts*dx(5,:);
        x(6,:) + Ts*dx(6,:)];

end

