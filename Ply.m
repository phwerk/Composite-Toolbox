classdef Ply

    properties
        mat;
        theta;
        t; 
    end
    
    methods
        function obj = Ply(mat,theta,t)
            obj.mat = mat;
            obj.theta = theta;
            obj.t = t;
        end

        function Qbar = Qbar(obj)
            %Generate Rotated Stiffness Matrix
            Q = obj.mat.reduced_stiffness();
            T = T_matrix(obj.theta);
            Tinv = inv(T);
            Qbar = Tinv*Q*Tinv.';
        end
        
        function Sbar = Sbar(obj)
            %Generate Rotated Compliance Matrix
            S = obj.mat.reduced_compliance();
            T = T_matrix(obj.theta);
            Sbar = T.'*S*T;
        end
        
        function T = T_matrix(theta)
            %Generate Rotation Matrix
            m = cos(theta*pi/180);
            n = sin(theta*pi/180);
            T = [m*m, n*n, 2*m*n;
                n*n , m*m, -2*m*n;
                -m*n, m*n, m*m-n*n];
        end     
        
        function [Ex,Ey,NUxy,NUyx,Gxy] = calc_effConst(obj)
            theta = obj.theta;
            [E1,E2,NU12,G12,~,~,~,~,~,~] = obj.mat.get_properties();
            m = cos(theta*pi/180);
            n = sin(theta*pi/180);
            %Ex
            denom = m^4 + (E1/G12 - 2*NU12)*n*n*m*m + (E1/E2)*n^4;
            Ex = E1/denom;
            %Ey
            denom = m^4 + (E2/G12 - 2*NU21)*n*n*m*m + (E2/E1)*n^4;
            Ey = E2/denom;
            %NUxy
            denom = m^4 + (E1/G12 - 2*NU12)*n*n*m*m + (E1/E2)*n*n;
            numer = NU12*(n^4 + m^4) - (1 + E1/E2 - E1/G12)*n*n*m*m;
            NUxy = numer/denom;
            %NUyx
            denom = m^4 + (E2/G12 - 2*NU21)*n*n*m*m + (E2/E1)*n*n;
            numer = NU21*(n^4 + m^4) - (1 + E2/E1 - E2/G12)*n*n*m*m;
            NUyx = numer/denom;
            %Gxy
            denom = n^4 + m^4 + 2*(2*G12*(1 + 2*NU12)/E1 + 2*G12/E2 - 1)*n*n*m*m;
            Gxy = G12/denom;
        end
        
        function ABD = ABD_layer(obj,z1,z2)
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

