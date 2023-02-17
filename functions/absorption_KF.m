function [alpha_KF] = absorption_KF( f, T, z ) 

% [alpha_KF] = absorption_KF( f, T, z ) 
%
%   Kinsler-Frey attenuation w/ temperature (°C) valid range: 0 <= T_C <= 30
%   hydrostatic pressure (atm) valid range: 1 <= P_atm <= 400
%   See: Kinsler, Frey, Coppens, and Sanders. Fundamentals of 
%   Acoustics, 3rd Ed.  Pages 158 through 160.  Model reprinted from
%   Fisher and Simmons.  J. Acoust. Soc. Am 62, 558, 1976
%
%   Input: (f(kHz), T(C), z(m))
%   Output: absorption (dB/km); for Bellhop convert to dB/wavelength


% Kinsler/Frey
P = (z.*1025.*9.81)./101325;
f1 = 1320.*(T + 273.15).*exp(-1700./(T + 273.15));
f2 = (1.55e+7).*(T + 273.15).*exp(-3052./(T + 273.15)); 
A = (8.95e-8).*(1 + .023.*T - (5.1e-4).*T.^2); 
B = (4.88e-7).*(1 + .013.*T).*(1 - (.9e-3).*P); 
C = (4.76e-13).*(1 - .04.*T + (5.9e-4).*T.^2).*(1 - (3.8e-4).*P); 
alpha_KF = ((A.*f1.*((f*1000).^2))./(f1.^2 + (f*1000).^2) +...
    (B.*f2.*((f*1000).^2))./(f2.^2 + (f*1000).^2) +...
    C.*((f*1000).^2))*1000;
end
