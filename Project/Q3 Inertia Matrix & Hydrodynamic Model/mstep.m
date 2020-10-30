function [theta, Qest, Rest] = mstep(xs,y,u,theta,param,par,prior)
% Unpack Parameters
Ms   = par.Ms;
N    = par.N;
meas = param.meas;

% options = optimoptions('fminunc','display','none');
% theta = fminunc(@(x) -Qhat(x), theta, options);
problem = fminsetup(@Qhat,theta);
theta   = fmincon(problem);

function qh = Qhat(th)
    % Use Monte-Carlo integration to form -Qhat 
    qh = 0;
    rh = 0;
    for i = 1:Ms
        for t = 1:N-1
            % Calculations for Qest
            xx = xs(:,i,t);
            ex = xs(:,i,t+1) - RigidBodyModel(param,prior,xx,u(:,t),th);
            qh = qh + ex*ex';
            
            % Calculations for Rest
            ey = y(:,t) - meas*xx;
            rh = rh + ey*ey';
        end
    end
    % Calculate Qest and Rest
    Qest = qh/(Ms*(N-1));
    Rest = rh/(Ms*(N-1));
    
    % Calculation for Qhat
    qh = 0.5*log(det(Qest));
end
end
