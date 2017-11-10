classdef Panel
  
    properties
        layup;
        l;
        b;
    end
    
    methods
        function obj = Panel(l,b,layup)
            obj.l = l;
            obj.b = b;
            obj.layup = layup;
        end
        
        function obj = add_layup(obj,layup)
            obj.layup = layup;
        end
        
        function obj = change_layup(obj,layup)
            obj.layup = layup;
        end
        
        function obj = change_geom(obj,l,b)
            obj.l = l;
            obj.b = b;
        end
        
        function [Ex,Ey,NUxy,Gxy] = calc_effConst(obj)
            [Ex,Ey,NUxy,Gxy] = obj.layup.calc_effConst();
        end
        
        function Ic_oi = calc_I(obj)
            [t_l,~,t_so,t_si] = obj.layup.get_thickness();
            %calculate second moment of inertia for rectangular cross section
            b = obj.b/1000;     t_l = t_l/1000;
            h_o = t_so/1000;    h_i = t_si/1000;

            A_o = b*h_o;
            I_o = b*h_o^3/12;
            A_i = b*h_i;
            I_i = b*h_i^3/12;

            y_1 = h_o/2;
            y_2 = t_l-h_i/2;

            centroid = (A_o*y_1+A_i*y_2)/(A_i+A_o);

            Ic_o = I_o + A_o*(centroid-y_1)^2;
            Ic_i = I_i + A_i*(centroid-y_2)^2;
            Ic_oi = Ic_o + Ic_i;
        end
        
        function EI = calc_EI(obj)
            I = obj.calc_I();
            E = obj.calc_effConst();
            EI = E*I;
        end
        
        function FPF = calc_FPF(obj)
            
        end
        function LPF = calc_LPF(obj)
            
        end
        
        function energy = calc_energy(obj)
            
        end
        
        function deflection = calc_deflection(obj)
            
        end
        
        function results = eval_3PB(obj,dir,model_name)
            %% Prepare string for material change
            layup = obj.layup.get_layup();
            
            matc = num2cell(mat);
            [E1,E2,NU12,G12]=deal(matc{:}); 
            E1 = num2str(E1,'%-5.2e');
            E2 = num2str(E2,'%-5.2e');
            NU12 = num2str(NU12,'%-5.2e');
            G12 = num2str(G12,'%-5.2e');
            matchange = ['MAT8           1',E1,E2,NU12,G12];

            %% Overwrite old .fem file with new data
            ref_file_name = model_name;
            ref_file = [dir,ref_file_name,'.fem'];
            newfile_name = 'run1';
            newfile = [dir,ref_file_name,newfile_name,'.fem'];

            fid = fopen(ref_file,'r');
            C = textscan(fid, '%s','Delimiter','');
            C = C{:};
            row = ~cellfun(@isempty, strfind(C,'CFK'));
            C{find(row)+2} = matchange;
            fclose(fid);

            fid = fopen(newfile,'w');
            fprintf(fid,'%s\n', C{:});
            fclose(fid);


            %% Run simulation
            system([dir,model_name,'.bat','-echo')

            %% Get results from .pch file
            filename = [dir,model_name,'.pch'];
            fid = fopen(filename);
            C = textscan(fid, '%s','Delimiter','');
            C = C{:};
            row = ~cellfun(@isempty, strfind(C,'54 '));
            row_content = C{find(row)};
            disp_z_new = str2num(row_content(53:64));
            fclose(fid);
        end
    end
end

