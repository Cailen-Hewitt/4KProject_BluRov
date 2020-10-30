function [theta, Qest, Rest] = mstep(xs,y,u,theta,param)

% Unpack Parameters
Ms = param.Ms;
N  = param.N;
C  = param.C;

problem = fminsetup(@Qhat,theta);
theta = fmincon(problem);

function qh = Qhat(th)
    % Use Monte-Carlo integration to form -Qhat 
    qh = 0;
    rh = 0;
    for i = 1:Ms
        for t = 1:N-1
            % Calculations for Qest
            xx = xs(:,i,t);
            ex = xs(:,i,t+1) - StaticThrusterModel(xx,u(:,t),th,param);
            qh = qh + ex*ex';
            
            % Calculations for Rest
            ey = y(:,t) - C*xx;
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
