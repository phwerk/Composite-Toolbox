classdef Ply
% Ply object contains material object and the angle and thickness
% information. 
% The rotated stiffness and compliance matrices can be
% computed as well as the effective constants. 
% For the ABD-matric calculation in the layup class the Ply class provides 
% an ABD calulation for one Ply.
 
    properties
        mat;            % Material object
        theta;          % Angle in degrees
        t;              % Thickness
    end
    
    methods
        function obj = Ply(mat,theta,t)
            % Constructor
            obj.mat = mat;
            obj.theta = theta;
            obj.t = t;
        end
        function obj = setProperties(obj,mat,theta,t)
            % Change properties
            obj.mat = mat;
            obj.theta = theta;
            obj.t = t;
        end
        
        function [mat,theta,t] = getProperties(obj)
            % Return properties
            mat = obj.mat;
            theta = obj.theta;
            t = obj.t;
        end
        function Qbar = Qbar(obj)
            % Generate rotated stiffness matrix
            Q = obj.mat.reducedStiffness();     % Generate Q_12    
            T = obj.T_matrix();                 % Get Rotation Matrix
            Tinv = inv(T);                      % Inverse of Rotation Matrix
            Qbar = Tinv*Q*Tinv.';               % Rotate Q_12 -> Q_xy
        end
        
        function Sbar = Sbar(obj)
            % Generate rotated compliance matrix
            S = obj.mat.reducedCompliance();    % Generate S_12
            T = obj.T_matrix();
            Sbar = T.'*S*T;                     % Rotate S_12 -> S_xy
        end
        
        function T = T_matrix(obj)
            % Generate rotation matrix
            theta = obj.theta;
            m = cos(theta*pi/180);
            n = sin(theta*pi/180);
            T = [m*m, n*n, 2*m*n;
                n*n , m*m, -2*m*n;
                -m*n, m*n, m*m-n*n];
        end     
        
        function [Ex,Ey,NUxy,NUyx,Gxy] = calcEffConst(obj)
            % Calculate the effective constants in x,y direction
            theta = obj.theta;
            m = cos(theta*pi/180);
            n = sin(theta*pi/180);
            [E1,E2,NU12,G12]= obj.mat.getProperties();  % Get material properties      
            NU21 = NU12*E2/E1; 
            %Ex
            denom = m^4 + (E1/G12 - 2*NU12)*n*n*m*m + (E1/E2)*n^4; % Denmoninator
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
        
        function ABD = ABD(obj,z1,z2)
            % Returns the ABD matrix for this ply 
            A = zeros(3); B = zeros(3); D = zeros(3);
            Qbar = obj.Qbar();              % Get Q_xy
            A = Qbar *(z2-z1);              % Calculate A-matrix
            B = Qbar *(z2^2 -z1^2) * 1/2;   % Calculate B-matrix
            D = Qbar *(z2^3 -z1^3) * 1/3;   % Calculate D-matrix
            ABD = [A, B; B, D];    
        end
        
    end
end

