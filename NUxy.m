function NUxy = NUxy(E1,E2,NU12,G12,theta)
%NUxy This function returns Poisson’s ratio
% NUxy in the global
% coordinate system. 
m = cos(theta*pi/180);
n = sin(theta*pi/180);
denom = m^4 + (E1/G12 - 2*NU12)*n*n*m*m + (E1/E2)*n*n;
numer = NU12*(n^4 + m^4) - (1 + E1/E2 - E1/G12)*n*n*m*m;
NUxy = numer/denom;
end