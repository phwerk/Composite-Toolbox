function Ex = Ex(E1,E2,NU12,G12,theta)
%Ex This function returns the elastic modulus
% along the x-direction in the global
% coordinate system.
m = cos(theta*pi/180);
n = sin(theta*pi/180);
denom = m^4 + (E1/G12 - 2*NU12)*n*n*m*m + (E1/E2)*n^4;
Ex = E1/denom;
end