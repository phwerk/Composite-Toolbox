function Q = reduced_isotropic_stiffness(E,NU)
%Generate Stiffness Matrix
Q = [E/(1-NU*NU)  , NU*E/(1-NU*NU), 0;
    NU*E/(1-NU*NU), E/(1-NU*NU)   , 0;
    0             , 0             , E/2/(1+NU)];
end

