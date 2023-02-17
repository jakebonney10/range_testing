function [wind] = read_wind(filename)

% [wind] = read_wind_speed(filename)
%   Read wind speed from NOAA NDBC NWPR1 station (41.5,-71.33)
%   
%   Ex.)
%       filename = 'wind_nwpr1_08-04.xlsx'
%       [wind] = read_wind_speed(filename)
%   
 
%% Get Wind Spd Data
[~,~,wind.data]=xlsread(filename);
wind.time = wind.data(:,6);
wind.time = datetime(wind.time(4:end),'InputFormat','uuuu-MM-dd''T''HH:mm'); % Time in UTC
wind.speed = str2double(wind.data(4:end,8)); % Wind speed (m/s) averaged over an eight-minute period for buoys
wind.gust = str2double(wind.data(4:end,9)); % Peak 5 or 8 second gust speed (m/s) measured during the eight-minute or two-minute period.
wind.direction = str2double(wind.data(4:end,7)); % Wind direction (the direction the wind is coming from in degrees clockwise from true N)

%% Replace extreme values in wind speed Data
for i = 1:length(wind.gust)
    % replace wind gust extreme values
    if wind.gust(i) == 99
        wind.gust(i) = wind.gust(i-1)
    end
    % replace wind speed extreme values
    if wind.speed(i) == 99
        wind.speed(i) = wind.speed(i-1)
    end
    % replace wind direction extreme values
    if wind.direction(i) == 999
        wind.direction(i) = wind.speed(i-1)
    end
end

%% Convert wind speed from m/s to knots
wind.speed = convvel(wind.speed,'m/s','kts');
wind.gust = convvel(wind.gust,'m/s','kts');

end