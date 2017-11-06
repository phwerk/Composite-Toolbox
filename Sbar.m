function Sbar = Sbar(S,theta)
%Generate Rotated Compliance Matrix
T = T(theta);
Tinv = Tinv(theta);
Sbar = T.'*S*T;
end

