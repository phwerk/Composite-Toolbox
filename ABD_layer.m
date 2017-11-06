function ABD = ABD_layer(Qbar,z1,z2)
%Returns the new ABD matrix with an added layer
A = zeros(3);
B = zeros(3);
D = zeros(3);
for i=1:3
    for j=1:3
        A(i,j) = Qbar(i,j)*(z2-z1);
        B(i,j) = Qbar(i,j)*(z2^2 -z1^2);
        D(i,j) = Qbar(i,j)*(z2^3 -z1^3);
    end
end
ABD = [A, B/2; B/2, D/3];
end

