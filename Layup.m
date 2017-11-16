classdef Layup

    properties
        plys_o = {};
        plys_i = {};
        core = nan;
        materials = {};
    end
    
    methods
        function obj = Layup()
        end
        
        function [plys_o,plys_i,core] = getLayup(obj)
            plys_o = obj.plys_o;
            plys_i = obj.plys_i;
            core = obj.core;
        end
        
        function [plys_o, plys_i] = getPlys(obj)
            plys_o = obj.plys_o;
            plys_i = obj.plys_i;
        end
        
        function core = getCore(obj)
            core = obj.core;
        end
        
        function obj = addPly(obj,newply,outside)
            [plycount_o, plycount_i] = obj.countPlys();
            if outside == true
                obj.plys_o{plycount_o+1} =  newply;
            else
                obj.plys_i{plycount_i+1} =  newply;    
            end
        end
        
        function obj = addCore(obj,core)
            obj.core =  core;
        end
        
        function [plycount_o, plycount_i] = countPlys(obj)
            plycount_o = length(obj.plys_o);
            plycount_i = length(obj.plys_i);
        end
        
        function ABD = ABD(obj)
            ABD = zeros(6);
            [t_l,t_c] = obj.getThickness();
            z1 = -t_l/2;
            [plycount_o, plycount_i] = obj.countPlys();
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
        
        function [t_l, t_c, t_so, t_si] = getThickness(obj)
            t_l = 0;    t_so = 0;   t_si = 0;   t_c = 0;
            [plycount_o, plycount_i] = obj.countPlys();
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
        
        function [Ex,Ey,NUxy,Gxy] = calcEffConst(obj)
            ABD = obj.ABD();
            A = ABD(1:3,1:3);
            [~,~,t_so, t_si] = obj.getThickness();
            t = t_so + t_si;
            Ex = EbarX(A,t);
            Ey = EbarY(A,t);
            NUxy = NUbarXY(A);
            Gxy = GbarXY(A,t);            
        end
        
        function materials = getMaterials(obj)
            layup = obj.getLayup;
            materials = cell(1);
            for i=1:length(layup)
                for j = 1:length(layup(i))
                    component = layup(i);
                    compMat = component{j}.getProperties();
                    for k = 1:length(materials)
                        if isequal(materials{k},compMat)== 1
                            break;
                        end
                        if k==length(materials)
                           materials = {materials{:},compMat };
                        end
                    end
                end
            end
            materials = materials(2:end);
            obj.materials = materials;
        end
        
        function matFem = matToFem(obj)
        %Return material in .fem file format
        mat = obj.getMaterials();
        matFem = {};
        for i = 1:length(mat)
            matFem(i,:) = formatMat(mat{i},i);
        end
        end

        function plyFem = plyToFem(obj)
        %Return material in .fem file format
        [plys_o,plys_i] = obj.getPlys();
        mat = obj.getMaterials();
        plyFem = {};
        for i = 1:length(plys_o)
            id = i;
            MID = getMatId(mat,plys_o{i});
            plyFem(id,:) = formatPly(plys_o{i},id,MID,1);
        end
        for i = 1:length(plys_i)
            id = length(plys_o)+i;
            MID = getMatId(mat,plys_i{i});
            plyFem(id,:) = formatPly(plys_i{i},id,MID,2);
        end
        
        row1 = '$HMNAME LAMINATES              1"laminate1"';
        row2 = '$HWCOLOR LAMINATES             1       5';
        row3 = 'STACK,1';
        for i = 1:id
            row3 = [row3,',',num2str(i)];
        end
        plyFem(id+1,:) = {row1,row2,row3,''};
        end
    end
end

