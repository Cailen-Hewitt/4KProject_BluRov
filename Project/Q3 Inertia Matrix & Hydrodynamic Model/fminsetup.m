function problem = fminsetup(Qhat,theta)
% fminsetup This function will setup the structure problem for fmincon
problem.objective = Qhat;
problem.x0        = theta;
problem.Aineq     = [];
problem.bineq     = [];
problem.Aeq       = [];
problem.beq       = [];
problem.lb        = [0 0 0];
problem.ub        = [100 100 100];
problem.nonlcon   = @nonlcon;
problem.solver    = 'fmincon';
problem.options   = optimoptions('fmincon','display','none');

    function [c,ceq] = nonlcon(x)
    c = [];
    ceq = [];
    end
end

