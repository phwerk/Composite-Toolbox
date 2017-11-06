function ABD = ABD(stack)
%Calculate ABD Matrix
plycount = stack.count_plys();
tstack = stack.get_thickness();
ABD = zeros(6);
z1 = -tstack/2;
for i=1:plycount
    Q = reducedcompliance(stack.plys(i).material);
    theta = stack.plys(i).theta;
    Qbar = Qbar(Q,theta);
    z2 = z1 + stack.plys(i).t;
    ABD = ABD_layer(ABD,Qbar,z1,z2);
    z1 = z2;
end
end

