function y = Ebary(A,t)
%Ebary This function returns the average laminate modulus
% in the y-direction. Its input are two arguments:
% A -3x3stiffness matrix for balanced symmetric
% laminates.
% t - thickness of laminate
a = inv(A);
y = 1/(t*a(2,2));
end
