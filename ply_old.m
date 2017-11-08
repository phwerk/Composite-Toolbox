classdef ply
    % Ply
    properties
        mat =[];
        t = [];
        theta = [];
    end
    
    methods
        function obj = ply(mat,theta,t)
            obj.mat = mat;
            obj.t = t;
            obj.theta = theta;
        end
        function Q = calc_Qbar(obj)
            mat = num2cell(obj.mat);
            Q = reduced_stiffness(mat{:});
            Q = Qbar(Q,obj.theta);
        end
    end
end