function val = luminosityGrayscale(r, g, b)
%LUMÝNOSÝTYGRAYSCALE Summary of this function goes here
%   Detailed explanation goes here
val = (0.21 * double(r)) + (0.72 * double(g)) + (0.07 * double(b));
end
