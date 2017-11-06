classdef stack
    % Laminate stack
    properties
        plys = {};
        panel_h = 325;
    end
    
    methods
        function obj = add_ply(obj,newply,panel_h)
            plycount = obj.count_plys();
            obj.plys{plycount+1} =  newply;
            if nargin >2
                obj.panel_h = panel_h;
            end
        end
        function ABD = calc_ABD(obj)
            ABD = zeros(6);
            z1 = -obj.get_thickness()/2;
            for i=1:obj.count_plys()
                Qbar = obj.plys{i}.calc_Qbar();
                z2 = z1 + obj.plys{i}.t;
                ABD = ABD + ABD_layer(Qbar,z1,z2);
                z1 = z2;
            end
        end
        function plycount = count_plys(obj)
            plycount = length(obj.plys);
        end
        function tstack = get_thickness(obj)
            tstack = 0;
            for i = 1:count_plys(obj)
                tstack = tstack + obj.plys{i}.t;
            end
        end
        function [Ex,Ey,NUxy,Gxy] = calc_effConst(obj)
            ABD = obj.calc_ABD();
            A = ABD(1:3,1:3);
            t = obj.get_thickness();
            Ex = EbarX(A,t);
            Ey = EbarY(A,t);
            NUxy = NUbarXY(A);
            Gxy = GbarXY(A,t);            
        end
        function EI = calc_EI(obj)
            Ex = obj.calc_effConst();
            I = obj.calc_I();
            EI = Ex*I;
        end
        function [panel_h,oskin_t,iskin_t,panel_t] = get_panelgeom(obj)
            panel_h = 325/1000;
            oskin_t = 2/1000;
            iskin_t = 1/1000;
            panel_t = panel_h + oskin_t + iskin_t;
        end
        function Ic_oi = calc_I(obj)
            [b,h_o,h_i,t_p] = get_panelgeom(obj);
            A_o = b*h_o;
            I_o = b*h_o^3/12;
            A_i = b*h_i;
            I_i = b*h_i^3/12;
            y_1 = h_o/2;
            y_2 = t_p-h_i/2;
            centroid = (A_o*y_1+A_i*y_2)/(A_i+A_o);

            Ic_o = I_o + A_o*(centroid-y_1)^2;
            Ic_i = I_i + A_i*(centroid-y_2)^2;
            Ic_oi = Ic_o + Ic_i;
        end
    end
    
end