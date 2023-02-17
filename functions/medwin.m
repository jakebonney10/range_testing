function [c] = medwin(T,S,z)

% [c] = medwin(T,S,z) 
%   
%   Medwin's Equation for SSP w inputs (T,S,z), Temperature (C), 
%   Salinity (ppt), and Depth (m). Output c (m/s).

c = 1449.2+4.6.*T-(5.5*10^(-2)).*T.^2+(2.9*10^(-4)).*T.^3+(1.34-10^(-2).*T).*(S-35)+(1.6*10^(-2)).*z;

end

