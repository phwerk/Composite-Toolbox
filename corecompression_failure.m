function F = corecompression_failure(stack,intruder_width)
% Druckfestigkeit des Kerns multipliziert mit der effektiven Druckfläche
% Lastfall: 3-Punkt-Biegeversuch
sigma_c_core = stack.core.mat.sigma_c_core;
Aeff = stack.geom.b * intruder_width;
F = sigma_c_core * Aeff;
end

