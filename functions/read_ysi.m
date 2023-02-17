function [ctd] = read_ysi(filename)

% [ctd] = read_ysi(filename) 
%   
%   Read YSI .csv file and create ctd object. Compute SSP with
%   medwin(T,S,z) function. ctd object includes Temperature (C), Salinity
%   (ppt), depth (m), and pH (0-14). 

%% Load CTD data from YSI device (.csv file)
ctd.data = readmatrix(filename,'Range','B:N');
ctd.time = readmatrix(filename,'OutputType', 'char', 'ExpectedNumVariables',1,'DateLocale','en_US');
ctd.time = datetime(ctd.time,'InputFormat','MM/dd/yy HH:mm:ss', 'TimeZone','local');
ctd.time.TimeZone = 'Z'; % Convert to UTC time

%% Read variables from YSI CTD data
ctd.T = ctd.data(:,1); % Temperature (C)
ctd.S = ctd.data(:,3); % Salinity (ppt)
ctd.z = ctd.data(:,4); % Depth (m)
ctd.pH = ctd.data(:,5); % pH (0-14)

%% Compute SSP from data using Medwins Eq
ctd.c = medwin(ctd.T,ctd.S,ctd.z); % SSP (m/s)

%% Plot SSP, T, S, pH Profiles
%figure;
plot(ctd.c,ctd.z); xlabel('Sound Speed (m/s)'); axis ij; grid minor; ylabel('Depth (m)'); title('SSP');
figure;  
subplot(1,4,1); plot(ctd.c,ctd.z); xlabel('Sound Speed (m/s)'); axis ij; grid minor; ylabel('Depth (m)');
subplot(1,4,2); plot(ctd.T,ctd.z); xlabel('Temperature (C)'); axis ij; grid minor; ylabel('Depth (m)');
subplot(1,4,3); plot(ctd.S,ctd.z); xlabel('Salinity (ppt)'); axis ij; grid minor; ylabel('Depth (m)');
subplot(1,4,4); plot(ctd.pH,ctd.z); xlabel('pH (0-14)'); axis ij; grid minor; ylabel('Depth (m)');
sgtitle('Sound Speed, Temperature, Salinity, and pH Profiles');

end

