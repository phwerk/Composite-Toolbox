classdef Core
% Core object contains a material object and a thickness
%
% Similiar methods as Ply class
% See also ply

    properties
        mat;                        % Material object
        t;                          % thickness
    end
    
    methods
        function obj = Core(mat,t)
            % Constructor
            obj.mat = mat;
            obj.t = t;
        end
        
        function obj = set_properties(obj,mat,t)
            % Change properties
            obj.mat = mat;
            obj.t = t;
        end

        function Qbar = Qbar(obj)
            % Generate stiffness matrix
            Qbar = obj.mat.reduced_stiffness();
        end
        
        function Sbar = Sbar(obj)
            % Generate compliance matrix
            Sbar = obj.mat.reduced_compliance();
        end

       
        function [Ex,Ey,NUxy,NUyx,Gxy] = calc_effConst(obj)
            % Returns the effective constants
            [Ex,Ey,NUxy,Gxy] = obj.mat.get_properties();
            NUyx = NUxy*Ey/Ex; 
        end
        
        function ABD = ABD(obj,z1,z2)
            %Returns the ABD matrix for this ply 
            A = zeros(3); B = zeros(3); D = zeros(3);
            Qbar = obj.Qbar();
            A = Qbar *(z2-z1);
            B = Qbar *(z2^2 -z1^2)* 1/2;
            D = Qbar *(z2^3 -z1^3)* 1/3;
            ABD = [A, B; B, D];    
        end
      
    end
end

