function [wind] = plot_wind_speed(filename,start_time, end_time, title)

% [wind] = read_wind_speed(filename)
%   Read and plot wind speed from NOAA NDBC NWPR1 station (41.5,-71.33)
%   
%   Ex.)
%       filename = 'wind_nwpr1_08-04.xlsx'
%       [wind] = read_wind_speed(filename)
%       start_time = '2021-08-04T15:38'; % 11/17='2020-11-17T16:30', 11/19='2020-11-19T15:45', 05/06(wp)='2021-05-06T15:00', 05/06(ep)='2021-05-06T19:00', 05/21='2021-05-21T16:00'
%       end_time = '2021-08-04T19:43'; % 11/17='2020-11-17T17:30', 11/19='2020-11-19T16:45', 05/06(wp)='2021-05-06T18:30', 05/06(ep)='2021-05-06T20:15', 05/21='2021-05-21T18:30'
%       title = 'Wind Speed 05-21 (Source: NOAA NDBC NWPR1)'
%
%% Read wind speed 
[wind] = read_wind_speed(filename)

%% Plot wind speed and gust
figure
plot(wind.time,wind.speed)
hold on
plot(wind.time,wind.gust)
grid on; grid minor
xlabel('Time (UTC)'); ylabel('Wind Speed (Knots)'); title(title);
start_limit = datetime(start_time,'InputFormat','uuuu-MM-dd''T''HH:mm');
end_limit = datetime(end_time,'InputFormat','uuuu-MM-dd''T''HH:mm');
xlim([start_limit end_limit])

%% Add wind direction to right y axis of plot
yyaxis right
plot(wind.time,wind.direction)
ylabel('Wind Direction (deg clockwise from North)')
ylim([0 360])
legend('Wind Speed (8 min ave)', 'Wind Gust (peak 5-8 sec)', 'Wind Direction (8 min ave)')
