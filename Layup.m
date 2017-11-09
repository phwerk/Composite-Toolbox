classdef Layup

    properties
        plys = {};
        core;
    end
    
    methods
        function obj = Layup()
        end
        
        function [plys,core] = get_layup(obj)
            plys = obj.plys;
            core = obj.core;
        end
        
        function plys = get_plys(obj)
            plys = obj.plys;
        end
        
        function core = get_core(obj)
            core = obj.core;
        end
        
        function obj = add_ply(obj,newply)
            plycount = obj.count_plys();
            obj.plys{plycount+1} =  newply;
        end
        
        function obj = add_core(obj,core)
            obj.core =  core;
        end
        
        function plycount = count_plys(obj)
            plycount = length(obj.plys);
        end
        
        function ABD = ABD(obj)
            ABD = zeros(6);
            [~,~,t_s,~] = obj.get_thickness();
            z1 = -t_s/2;
            for i=1:obj.count_plys()
                z2 = z1 + obj.plys{i}.t;
                ABD = ABD + obj.plys{i}.ABD(z1,z2);
                z1 = z2;
            end
        end
        function [t_l, t_c, t_so, t_si] = get_thickness(obj)
            t_l = 0;
            t_c = obj.core.t;
            t_s = 0;
            for i = 1:count_plys(obj)
                t_s = t_s + obj.plys{i}.t;
            end
            t_l = t_c + t_s;
            t_so = t_s/2;
            t_si = t_s/2;
        end
        
        function [Ex,Ey,NUxy,Gxy] = calc_effConst(obj)
            ABD = obj.ABD();
            A = ABD(1:3,1:3);
            [~,~,t_skin] = obj.get_thickness();
            Ex = EbarX(A,t);
            Ey = EbarY(A,t);
            NUxy = NUbarXY(A);
            Gxy = GbarXY(A,t);            
        end
        
    end
end

