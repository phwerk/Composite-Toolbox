function S = reduced_isotropic_compliance(E,NU)
%Generate Compliance Matrix
S = [1/E    , -NU/E , 0;
     -NU/E  , 1/E   , 0;
     0      , 0     , 2*(1+NU)/E];
end

