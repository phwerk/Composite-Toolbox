function Tinv = Tinv_matrix(theta)
%Generate Inverse of Rotation Matrix
m = cos(theta*pi/180);
n = sin(theta*pi/180);
Tinv = [m*m, n*n, -2*m*n;
        n*n, m*m, 2*m*n ;
        m*n,-m*n, m*m-n*n];
end

