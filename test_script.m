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

mat = {E1,E2,NU12,G12,rho,Xt,Xc,Yt,Yc,S};
t1 = 0.5;
t2 = 0.3;
theta1 = 30;
theta2 = 10;

% Check Material Class
mat1 = Material(mat{:});
mat1.reduced_stiffness();
mat1.reduced_compliance();
mat1.reduced_isotropic_compliance();
mat1.reduced_isotropic_stiffness();
E1 = 2.0E+05;                       % Change Material
mat = {E1,E2,NU12,G12,rho,Xt,Xc,Yt,Yc,S};
mat1 = mat1.set_properties(mat{:}); % !Muss auf Objekt referenziert werden!
mat1.get_properties();

% Check Ply Class
ply1 = Ply(mat1,theta1,t1);
Qbar = ply1.Qbar();
Sbar = ply1.Sbar();
effConst = ply1.calc_effConst();
ABD1 = ply1.ABD(0,t1);
ply1 = ply1.set_properties(mat1,theta2,t2);
ABD2 = ply1.ABD(0,t2);
ply2 = Ply(mat1,theta2,t2);
% Check Core Class
core1 = Core(mat1, t2);


% Check Layup Class
layup1 = Layup();
layup1 = layup1.add_ply(ply1,true);
layup1 = layup1.add_ply(ply2,true);
layup1 = layup1.add_ply(ply1,true);
layup1 = layup1.add_ply(ply2,true);
ABD = layup1.ABD();

% Check Panel Class




%% Run simulation
system('C:\TEST\3PB.bat','-echo')
pause(30);

%% Get results from .pch file
filename = 'C:\TEST\3PB.pch';
fid = fopen(filename);
C = textscan(fid, '%s','Delimiter','');
C = C{:};
row = ~cellfun(@isempty, strfind(C,'54 '));
row_content = C{find(row)};
disp_z_old = str2num(row_content(53:64));
fclose(fid)



%% Prepare string for material change
matc = num2cell(mat);
[E1,E2,NU12,G12]=deal(matc{:}); 
E1 = num2str(E1,'%-5.2e');
E2 = num2str(E2,'%-5.2e');
NU12 = num2str(NU12,'%-5.2e');
G12 = num2str(G12,'%-5.2e');
matchange = ['MAT8           1',E1,E2,NU12,G12];

%% Overwrite old .fem file with new data
dir = 'C:\TEST\';
ref_file_name = '3PB';
ref_file = [dir,ref_file_name,'.fem'];
newfile_name = '';
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
system('C:\TEST\3PB.bat','-echo')

%% Get results from .pch file
filename = 'C:\TEST\3PB.pch';
fid = fopen(filename);
C = textscan(fid, '%s','Delimiter','');
C = C{:};
row = ~cellfun(@isempty, strfind(C,'54 '));
row_content = C{find(row)};
disp_z_new = str2num(row_content(53:64));
fclose(fid);


% c_EI = 5.11E+03;
% c_A = 358.9;
% c_YTS = 1.09E+05;
% c_UTS = 1.31E+05;
% c_MaxLoad = 2.93E+03;
% c_MaxDefl = 1.20E-02;
% c_Energy = 1.76E+01;


% E_v = EbarX(stack_v);
% E_h = EbarX(stack_h);
% 
% I_v = calc_I(panel_v_t, panel_v_h, oskin_v_t, iskin_v_t);
% I_h = calc_I(panel_h_t, panel_h_h, oskin_h_t, iskin_h_t);
% EI_v = E_v * E_Iv;
% EI_h = E_h * E_Ih;
% 
% A_v = (panel_v_t-core_v_t)*panel_v_h;
% A_h = (panel_h_t-core_h_t)*panel_h_h;

