function [alpha_AM] = absorption_AM( f, S, T, pH, z ) 

% [alpha_AM] = absorption_AM( f, S, T, pH, z ) 
%
%   Francois-Garrison/Ainslie-McColm attenuation.
%   See Ainslie and McColm, JASA 103(3):1671- 1998
%
%   Input: (f(kHz), S(ppt), T(C), pH(0-14), z(m))
%   Output: absorption (dB/km); for Bellhop convert to dB/wavelength
%
%   IF NO PH LEVELS USE DEFAULT OF PH=8 

% Ainslie-McColm
f1 = 0.78 .* sqrt( S./ 35 ) .* exp( T./ 26 );   % boron
f2 = 42 .* exp( T./ 17 );   % magnesium
alpha_AM = 0.106 .* f1 .* f.^2 ./ ( f.^2 + f1.^2 ) .* exp( ( pH - 8 ) / 0.56 ) + ...
    + 0.52 .* ( 1 + T./ 43 ) .* ( S./ 35 ) .* f2 .* f.^2 ./ ( f.^2 + f2.^2 ) .* exp( (-z./1000)./ 6 ) + ...
    + 0.00049 .* f.^2 .* exp( - ( T./27 + (z./1000)./ 17 ) );
end
