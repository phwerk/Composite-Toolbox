classdef Core

    properties
        mat;
        t; 
    end
    
    methods
        function obj = Core(mat,t)
            obj.mat = mat;
            obj.t = t;
        end
        
        function obj = set_properties(obj,mat,t)
            obj.mat = mat;
            obj.t = t;
        end

        function Qbar = Qbar(obj)
            %Generate Stiffness Matrix
            Qbar = obj.mat.reduced_stiffness();
        end
        
        function Sbar = Sbar(obj)
            %Generate Compliance Matrix
            Sbar = obj.mat.reduced_compliance();
        end

       
        function [Ex,Ey,NUxy,NUyx,Gxy] = calc_effConst(obj)
            [Ex,Ey,NUxy,Gxy] = obj.mat.get_properties();
            NUyx = NUxy*Ey/Ex; 
        end
        
        function ABD = ABD(obj,z1,z2)
            %Returns the ABD matrix for this ply 
            A = zeros(3); B = zeros(3); D = zeros(3);
            Qbar = obj.Qbar();
            for i=1:3
                for j=1:3
                    A(i,j) = Qbar(i,j)*(z2-z1);
                    B(i,j) = Qbar(i,j)*(z2^2 -z1^2);
                    D(i,j) = Qbar(i,j)*(z2^3 -z1^3);
                end
            end
            ABD = [A, B/2; B/2, D/3];    
        end
      
    end
end

