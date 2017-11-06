function y = GbarXY(A,t)
%Gbarxy This function returns the average laminate shear
% modulus. Its input are two arguments:
% A -3x3stiffness matrix for balanced symmetric
% laminates.
% t - thickness of laminate
a = inv(A);
y = 1/(t*a(3,3));
end