function S = reduced_compliance(E1,E2,NU12,G12)
%Generate Compliance Matrix
S = [1/E1   , -NU12/E1, 0;
    -NU12/E1, 1/E2    , 0;
    0       , 0       ,1/G12];
end

