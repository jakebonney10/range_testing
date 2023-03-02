function [dB] = SPL(p)
%SPL Calculate the sound pressure level (SPL) in dB re 1 μPa.
%   Input: Sound pressure in μPa.

dB = 20*log10(p);

end

