function [TL] = TL_geometric(range,alpha,depth)
%GEOMETRIC_MODEL A simple geometric propagation model for underwater sound.
%   This function computes the transmission loss for a given range (m) and
%   attenuation coeficient alpha (db/km).

TL = 10.*log10(depth) + 10.*log10(range) + alpha.*(range./1000);

end

