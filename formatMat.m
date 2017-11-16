function matFEM = formatMat(objMat,id)
%Return one material into .fem file format
[E1,E2,NU12,G12,rho,Xt,Xc,Yt,Yc,S] = objMat.getProperties();
id = ['       ',num2str(id,'%d')];
E1 = num2str(E1,'%-5.2e');
E2 = num2str(E2,'%-5.2e');
NU12 = num2str(NU12,'%-5.2e');
G12 = num2str(G12,'%-5.2e');
rho = num2str(rho,'%-5.2e');
Xt = num2str(Xt,'%-5.2e');
Xc = num2str(Xc,'%-5.2e');
Yt = num2str(Yt,'%-5.2e');
Yc = num2str(Yc,'%-5.2e');
S = num2str(S,'%-5.2e');
o = ['        '];
row1 = ['$HMNAME MAT             ',id,'"material',id(8),'" "MAT8"'];
row2 = ['$HWCOLOR MAT            ',id,'      11'];
%                       id,E1,E2,NU12,G12,G1Z,G2Z,Rho,A1,A2,TREF,Xt,Xc,Yt,Yc,S,GE,F12,STRN    
row3 = ['MAT8    ',id,E1,E2,NU12,G12,o  ,o  ,rho,o ,o ,o   ,Xt,Xc,Yt,Yc,S,o ,o  ,o];
matFEM = {row1,row2,row3};
end

