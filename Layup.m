classdef Layup

    properties
        plys_o = {};
        plys_i = {};
        core = nan;
    end
    
    methods
        function obj = Layup()
        end
        
        function [plys_o,plys_i,core] = get_layup(obj)
            plys_o = obj.plys_o;
            plys_i = obj.plys_i;
            core = obj.core;
        end
        
        function [plys_o, plys_i] = get_plys(obj)
            plys_o = obj.plys_i;
            plys_i = obj.plys_o;
        end
        
        function core = get_core(obj)
            core = obj.core;
        end
        
        function obj = add_ply(obj,newply,outside)
            [plycount_o, plycount_i] = obj.count_plys();
            if outside == true
                obj.plys_o{plycount_o+1} =  newply;
            else
                obj.plys_i{plycount_i+1} =  newply;    
            end
        end
        
        function obj = add_core(obj,core)
            obj.core =  core;
        end
        
        function [plycount_o, plycount_i] = count_plys(obj)
            plycount_o = length(obj.plys_o);
            plycount_i = length(obj.plys_i);
        end
        
        function ABD = ABD(obj)
            ABD = zeros(6);
            [t_l,t_c] = obj.get_thickness();
            z1 = -t_l/2;
            [plycount_o, plycount_i] = obj.count_plys();
            for i=1:plycount_o
                z2 = z1 + obj.plys_o{i}.t;
                ABD = ABD + obj.plys_o{i}.ABD(z1,z2);
                z1 = z2;
            end
            z1 = z1 + t_c;
            z2 = z2 + t_c;
            for j=1:plycount_i
                z2 = z1 + obj.plys_i{j}.t;
                ABD = ABD + obj.plys_i{j}.ABD(z1,z2);
                z1 = z2;
            end
        end
        
        function [t_l, t_c, t_so, t_si] = get_thickness(obj)
            t_l = 0;    t_so = 0;   t_si = 0;   t_c = 0;
            [plycount_o, plycount_i] = obj.count_plys();
            for i = 1:plycount_o
                t_so = t_so + obj.plys_o{i}.t;
            end
            for j = 1:plycount_i
                t_si = t_si + obj.plys_i{j}.t;
            end
            t_l = t_so + t_si;
            if isnan(obj.core) ~= 1
                t_c = obj.core.t;
                t_l = t_l + t_c;
            end
        end
        
        function [Ex,Ey,NUxy,Gxy] = calc_effConst(obj)
            ABD = obj.ABD();
            A = ABD(1:3,1:3);
            [~,~,t_so, t_si] = obj.get_thickness();
            t = t_so + t_si;
            Ex = EbarX(A,t);
            Ey = EbarY(A,t);
            NUxy = NUbarXY(A);
            Gxy = GbarXY(A,t);            
        end
        
    end
end

