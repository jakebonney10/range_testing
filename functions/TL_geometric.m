function [TL] = TL_geometric(range,alpha)
%GEOMETRIC_MODEL A simple geometric propagation model for underwater sound.
%   This function computes the transmission loss for a given range (m) and
%   attenuation coeficient alpha (db/km).

TL = 20.*log(range) + alpha.*(range./1000);

end

