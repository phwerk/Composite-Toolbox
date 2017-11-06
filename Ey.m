function Ey = Ey(E1,E2,NU21,G12,theta)
%Ey This function returns the elastic modulus
% along the y-direction in the global
% coordinate system.
m = cos(theta*pi/180);
n = sin(theta*pi/180);
denom = m^4 + (E2/G12 - 2*NU21)*n*n*m*m + (E2/E1)*n^4;
Ey = E2/denom;
end