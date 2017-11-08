function F = coreshear_failure(stack)
% Schubfestigkeit des Kerns multipliziert mit der Fläche, die aufgespannt
% wird von der Panel Breite und dem Abstand der Mittelpunkte der Lagen
% Lastfall: 3-Punkt-Biegeversuch
h = stack.geom.h;
b = stack.geom.b;
F = tau_c*h*b;
end

