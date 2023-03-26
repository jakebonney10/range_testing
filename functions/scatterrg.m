function [RG] = scatterrg(f, c, sigma, theta)

% [RG] = scatterrg(f, c, sigma, theta)
%
%   Scattering and reflection of sound at rough surfaces.
%   See Clay and Medwin, Acoustical Oceanography 1977 pg. 340
%
%   Input: (f(Hz), c(m/s), sigma(m), theta(radians))
%   Output: scattering loss per bottom bounce
%
% Ex.) 
% theta = (90 - rangle)*pi/180; % convert from incident angle to grazing angle and radians
% sigma = .01; % 1cm (cobble/sand) % guess and compare model to data
% loss = scatterrg(f,1500,sigma,theta);
% lossy_amplitdue = amplitude.*loss.^numbotbnc

k = 2*pi*f./c;
RG = exp(-2.*k.^2.*sigma.^2.*cos(theta).^2);