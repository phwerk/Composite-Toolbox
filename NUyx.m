function NUyx = NUyx(E1,E2,NU21,G12,theta)
%NUyx This function returns Poisson’s ratio
% NUyx in the global
% coordinate system.
m = cos(theta*pi/180);
n = sin(theta*pi/180);
denom = m^4 + (E2/G12 - 2*NU21)*n*n*m*m + (E2/E1)*n*n;
numer = NU21*(n^4 + m^4) - (1 + E2/E1 - E2/G12)*n*n*m*m;
NUyx = numer/denom;
end