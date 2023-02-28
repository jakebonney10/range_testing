function [prof] = make_bellhop_ssp(filename, f)

% [prof] = make_bellhop_profile(filename, f)
%
%   Creates Bellhop water column profile given ctd file from ysi and frequency f (kHz).  
%
%   Ex.)
%       filename = 'CTD1_080421.csv';
%       f = 69; % frequency (kHz)
%       prof = make_bellhop_profile('filename')

%% Read YSI CTD data
ctd = read_ysi(filename);

%% Calculate attenuation
[alpha_am] = absorption_AM(f, ctd.S, ctd.T, ctd.pH, ctd.z); % Ainslie-McColm attenuation (dB/km)
[alpha_kf] = absorption_KF(f, ctd.T, ctd.z); % Kinsler-Frey attenuation (dB/km)

%% Convert from dB/km to dB/wavelength
lambda = 1500/(f*1000); % wavelength (m)
alpha_am_lambda = alpha_am/1000*lambda; % absorption (dB/wavelength)
alpha_kf_lambda = alpha_kf/1000*lambda; % absorption (dB/wavelength)

%% Create table for .env file 
cs = zeros(length(ctd.c),1); % generate vector of zeros for shear speed
rho = ones(length(ctd.c),1); % generate vector of ones for density 
slash = repmat('/',length(ctd.c),1); % generate vector of '/' for .env formatting
prof = table(ctd.z,ctd.c,cs,rho,alpha_am_lambda, slash); % generate table to copy and paste into .env file
prof = sortrows(prof); % sort ascending based on depth 
[~,x] = unique(prof(:,1)); % make sure no repeated depth values
prof = prof(x,:) % print table with repeated depth rows removed

end