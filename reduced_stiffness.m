function Q = reduced_stiffness(E1,E2,NU12,G12)
%Generate Stiffness Matrix
NU21 = NU12*E2/E1;
Q = [E1/(1-NU12*NU21)    , NU12*E2/(1-NU12*NU21), 0 ;
    NU12*E2/(1-NU12*NU21), E2/(1-NU12*NU21)     , 0 ;
    0                    , 0                    ,G12];
end

