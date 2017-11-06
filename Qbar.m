function Qbar = Qbar(Q,theta)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
T = T_matrix(theta);
Tinv = Tinv_matrix(theta);
Qbar = Tinv*Q*Tinv.';
end

