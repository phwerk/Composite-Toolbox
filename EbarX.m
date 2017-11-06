function y = Ebarx(A,t)
%Ebarx This function returns the average laminate modulus
% in the x-direction. Its input are two arguments:
% A -3x3stiffness matrix for balanced symmetric
% laminates.
% H - thickness of laminate
a = inv(A);
y = 1/(t*a(1,1));
end