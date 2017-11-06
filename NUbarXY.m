function y = NUbarxy(A)
%NUbarxy This function returns the average laminate
% Poisson’s ratio NUxy. Its input are two arguments:
% A -3x3stiffness matrix for balanced symmetric
% laminates.
a = inv(A);
y = -a(1,2)/a(1,1);
end
