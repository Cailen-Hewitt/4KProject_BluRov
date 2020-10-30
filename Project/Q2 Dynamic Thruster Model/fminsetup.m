function problem = fminsetup(Qhat,theta)
%fminsetup This function will setup the structure problem for fmincon
problem.objective = Qhat;
problem.x0        = theta;
problem.Aineq     = [];     % Aineq*theta <= bineq
problem.bineq     = [];     
problem.Aeq       = [];     % Aeq*theta = beq
problem.beq       = [];
problem.lb        = [];     % Theta upper bound
problem.ub        = [];     % Theta lower bound
problem.nonlcon   = @nonlcon;
problem.solver    = 'fmincon';
problem.options   = optimoptions('fmincon','display','none');

    function [c,ceq] = nonlcon(x)
    c = [];                 % c(x) <= 0 
    ceq = [];               % ceq(x) = 0 
    end
end

