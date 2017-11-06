function Ic_oi = calc_I(panel_t, panel_h, oskin_t, iskin_t)
%calculate second moment of inertia for rectangular cross section
b = panel_h/1000;
h_o = oskin_t/1000;
h_i = iskin_t/1000;
t_p = panel_t/1000;

A_o = b*h_o;
I_o = b*h_o^3/12;
A_i = b*h_i;
I_i = b*h_i^3/12;

y_1 = h_o/2;
y_2 = t_p-h_i/2;

centroid = (A_o*y_1+A_i*y_2)/(A_i+A_o);

Ic_o = I_o + A_o*(centroid-y_1)^2;
Ic_i = I_i + A_i*(centroid-y_2)^2;
Ic_oi = Ic_o + Ic_i;
end

