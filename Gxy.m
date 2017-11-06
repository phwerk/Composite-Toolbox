function Gxy = Gxy(E1,E2,NU12,G12,theta)
%Gxy This function returns the shear modulus
% Gxy in the global
% coordinate system.
m = cos(theta*pi/180);
n = sin(theta*pi/180);
denom = n^4 + m^4 + 2*(2*G12*(1 + 2*NU12)/E1 + 2*G12/E2 - 1)*n*n*m*m;
Gxy = G12/denom;
end