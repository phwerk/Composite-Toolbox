classdef Material
% Material objects contain the material parameters
% They can be changed, returned and the stiffness and compliance matrix can
% be calculated

    properties
        % Default Material
        E1 = 1.2E+05;
        E2 = 1.2E+05;
        NU12 = 0.3E-01;
        G12 = 3.9E+03;
        rho = 1.6E-09;
        Xt = 665.0;
        Xc = 566.0;
        Yt = 665.0;
        Yc = 566.0;
        S = 92.0;
    end
    
    methods
        function obj = Material(E1,E2,NU12,G12,rho,Xt,Xc,Yt,Yc,S)
            % Constructor
            obj.E1 = E1;    obj.E2 = E2;            
            obj.NU12 = NU12;obj.G12 = G12;
            obj.rho = rho;  obj.Xt = Xt;
            obj.Xc = Xc;    obj.Yt = Yt;
            obj.Yc = Yc;    obj.S = S;
        end
        
        function obj = setProperties(obj,E1,E2,NU12,G12,rho,Xt,Xc,Yt,Yc,S)
            % Change properties
            obj.E1 = E1;    obj.E2 = E2;            
            obj.NU12 = NU12;obj.G12 = G12;
            obj.rho = rho;  obj.Xt = Xt;
            obj.Xc = Xc;    obj.Yt = Yt;
            obj.Yc = Yc;    obj.S = S;
        end
        
        function [E1,E2,NU12,G12,rho,Xt,Xc,Yt,Yc,S] = getProperties(obj)
            % Returns all properties
            E1 = obj.E1;    E2 = obj.E2;
            NU12 = obj.NU12;G12 = obj.G12;
            rho = obj.rho;  Xt = obj.Xt;
            Xc = obj.Xc;    Yt = obj.Yt;
            Yc = obj.Yc;    S = obj.S;
        end
        
        function Q = reducedStiffness(obj)
            % Generate stiffness matrix for orthogonal material
            NU12 = obj.NU12;    E1 = obj.E1;
            E2 = obj.E2;        G12 = obj.G12;
    
            NU21 = NU12*E2/E1;
            Q = [E1/(1-NU12*NU21)    , NU12*E2/(1-NU12*NU21), 0 ;
                NU12*E2/(1-NU12*NU21), E2/(1-NU12*NU21)     , 0 ;
                0                    , 0                    ,G12];
        end
        
        function S = reducedCompliance(obj)
            % Generate compliance matrix for orthogonal material
            NU12 = obj.NU12;    E1 = obj.E1;
            E2 = obj.E2;        G12 = obj.G12;
            
            S = [1/E1   , -NU12/E1, 0;
                -NU12/E1, 1/E2    , 0;
                0       , 0       ,1/G12];
        end
        
        function Q = reducedIsotropicStiffness(obj)
            % Generate stiffness matrix for isotropic material
            E= obj.E1; NU = obj.NU12;
            
            Q = [E/(1-NU*NU)  , NU*E/(1-NU*NU), 0;
                NU*E/(1-NU*NU), E/(1-NU*NU)   , 0;
                0             , 0             , E/2/(1+NU)];
        end
        
        function S = reducedIsotropicCompliance(obj)
            % Generate compliance matrix for isotropic material
            E = obj.E1; NU = obj.NU12;
            
            S = [1/E    , -NU/E , 0;
                 -NU/E  , 1/E   , 0;
                 0      , 0     , 2*(1+NU)/E];
        end

    end
end

