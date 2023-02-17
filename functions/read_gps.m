function [gps] = read_gps(filename, title, API_key)

%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%
%   Ex.)
%       filename = 'Track_2020-11-17 131614'
%       title = 'GPS Track (11/17/20)'
%       API_key = ***Get Google API Key from Google Maps Account***
%       function [gps] = plot_gps(filename, title, API_key)

%% Read GPS Data
gps = gpxread(filename)

%% Plot GPS Track
figure
plot(gps.Longitude, gps.Latitude, '.r', 'MarkerSize', 20)
plot_google_map('MapScale',1,'APIKey',API_key)
title(title)
grid on, grid minor

end