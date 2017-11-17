classdef Layup
% Layup object contains the plys, the core and the materials.
% 
% Plys can be added either on the inner or outerside.
% Plys can be counted and thickness and materials can be returned.
% The ABD matrix and the effective constants can be calculated.
% The Layup informations can be brought into .fem format to change
% simulations.

    properties
        plys_o = {};        % Cell of Ply objects on the outer side
        plys_i = {};        % Cell of Ply objects on the inner side
        core = nan;         % Core
        materials = {};     % Materials used for the layup -> getMaterials()
    end
    
    methods
        function obj = Layup()
            % Constructor
        end
        
        function [plys_o,plys_i,core] = getLayup(obj)
            % Return ply and core cells
            plys_o = obj.plys_o;
            plys_i = obj.plys_i;
            core = obj.core;
        end
        
        function [plys_o, plys_i] = getPlys(obj)
            % Return plys cells
            plys_o = obj.plys_o;
            plys_i = obj.plys_i;
        end
        
        function core = getCore(obj)
            % Return core object
            core = obj.core;
        end
        
        function obj = addPly(obj,newply,outside)
            % Add a ply object to one of the ply cells
            [plycount_o, plycount_i] = obj.countPlys(); % Count plys
            % Outside is a boolean to check if ply shall be out- or inside
            if outside == true
                obj.plys_o{plycount_o+1} =  newply;     % Add ply to outside plys
            else
                obj.plys_i{plycount_i+1} =  newply;     % Add ply to inside plys
            end
        end
        
        function obj = addCore(obj,core)
            % Add core object (Check missing if core already exists)
            obj.core =  core;
        end
        
        function [plycount_o, plycount_i] = countPlys(obj)
            % Return the number of ply objects on each side
            plycount_o = length(obj.plys_o);
            plycount_i = length(obj.plys_i);
        end
        
        function ABD = ABD(obj)
            % Calculates the ABD matrix for the laminate
            % Only 
            ABD = zeros(6);
            [t_l,t_c] = obj.getThickness();             % Return laminate thickness
            z1 = -t_l/2;
            [plycount_o, plycount_i] = obj.countPlys(); % Return number of plys
            for i=1:plycount_o
                z2 = z1 + obj.plys_o{i}.t;              
                ABD = ABD + obj.plys_o{i}.ABD(z1,z2);   % Calculate ABD matrix for ply 
                z1 = z2;
            end
            z1 = z1 + t_c;                              % Add the core thickness for the innerside plys
            z2 = z2 + t_c;
            for j=1:plycount_i
                z2 = z1 + obj.plys_i{j}.t;
                ABD = ABD + obj.plys_i{j}.ABD(z1,z2);
                z1 = z2;
            end
        end
        
        function [t_l, t_c, t_so, t_si] = getThickness(obj)
            % Count the layup, core, plys thicknesses
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
            % Return the effective Constants (Only correct for symmetric layups)
            ABD = obj.ABD();    
            A = ABD(1:3,1:3);                                   % Get A matrix
            [~,~,t_so, t_si] = obj.getThickness();              % Get ply thicknesses
            t = t_so + t_si;                                    % Get total ply thickness
            Ex = EbarX(A,t);                        
            Ey = EbarY(A,t);
            NUxy = NUbarXY(A);
            Gxy = GbarXY(A,t);            
        end
        
        function materials = getMaterials(obj)
            % Returns a cell with all materials which occur in the laminate
            layup = obj.getLayup;                               % Array with [plys_o,plys_i,core]
            materials = cell(1);
            for i=1:length(layup)                               % Iterate over the array above
                for j = 1:length(layup(i))                      % Iterate over each element in either plys_o,plys_i,core
                    element = layup(i);   
                    elemMat = element{j}.getProperties();
                    for k = 1:length(materials)                 % Iterate over current layup materials
                        if isequal(materials{k},elemMat)== 1    % Check if material aready exists
                            break;
                        end
                        if k==length(materials)
                           materials = {materials{:},elemMat }; % If it doesn't exist yet, add material
                        end
                    end
                end
            end
            materials = materials(2:end);                       % Delete first empty entry
            obj.materials = materials;                          % add materials to object
        end
        
        function matFem = matToFem(obj)
        %Return material in .fem file format
        mat = obj.getMaterials();
        matFem = {};
        for i = 1:length(mat)                                   % Iterate over materials
            matFem(i,:) = formatMat(mat{i},i);                  % return material in .fem format
        end
        end

        function plyFem = plyToFem(obj)
        %Return plys in .fem file format
        [plys_o,plys_i] = obj.getPlys();
        mat = obj.getMaterials();
        plyFem = {};
        for i = 1:length(plys_o)                                % Iterate over outside plys
            id = i;
            MID = getMatId(mat,plys_o{i});                      % Set the corresponding material id
            plyFem(id,:) = formatPly(plys_o{i},id,MID,1);       % return ply in .fem format
        end
        for i = 1:length(plys_i)                                % Iterate over inside plys
            id = length(plys_o)+i;
            MID = getMatId(mat,plys_i{i});
            plyFem(id,:) = formatPly(plys_i{i},id,MID,2);
        end
        % Add Laminate
        row1 = '$HMNAME LAMINATES              1"laminate1"';   
        row2 = '$HWCOLOR LAMINATES             1       5';
        row3 = 'STACK,1';
        for i = 1:id
            row3 = [row3,',',num2str(i)];                       % Add stacking order
        end
        plyFem(id+1,:) = {row1,row2,row3,''};                   % return cell with .fem formated lines
        end
    end
end

