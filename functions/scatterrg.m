function RG = scatterrg(f, c, sigma, theta)
k = 2*pi*f./c;
RG = exp(-2.*k.^2.*sigma.^2.*cos(theta).^2);