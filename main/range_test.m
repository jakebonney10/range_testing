%--------------------%
%  Jake Bonney
%  RIDEM DMF/URI
%  Range Test Analysis
%  4/30/21
%--------------------%

clc; clear all; close all;

%% Specify test name, filename, control receiver, ST location, test tags used
test_name = 'West Passage 08/04/21';
filename = 'wp_august'; load([filename,'.mat']) % Load ST processed data file
control_receiver = r135471;     % r134922 (control), r135470 (bottom), r135472 (top)
ST_location = [gps_waypoints.Latitude(3),gps_waypoints.Longitude(3)]; % Soundtrap GPS location
tag = ["A69-1602-59951"];       % A69-1602-59950/1 (Lo/Hi 7m), A69-1602-21114/5 (Lo/Hi 3m)

%% Automate Processing
tic

% Find control receiver ping time index (make sure Vemco file is trimmed accordingly!)
PingTimeIndex = find(control_receiver.time >= SampleStartTimeUTC & control_receiver.time <= SampleStopTimeUTC);
PingTagIndex = PingTimeIndex(find(control_receiver.tag(PingTimeIndex) == tag)); % Find which tag occurred at each PingTimeIndex 

clear peak_mean loc_mean
for i = 1:length(PingTagIndex)
    % Determine ping index
    ti = find(t >= control_receiver.time(PingTagIndex(i))- seconds(3.75) & t <= control_receiver.time(PingTagIndex(i))+ seconds(1.25)); % (+- 2.5 Hi pwr 11/19)

    % Find peaks of transmission
    [peaks, locs] = findpeaks(XM(ti), t(ti),'MinPeakHeight',1e4,'MinPeakDistance',seconds(.25),'NPeaks',8,'SortStr','descend');
    peak_mean(i) = mean(peaks); % Calculate mean pressure level of ping peaks
    loc_mean(i) = mean(locs); % Calculate mean of ping peak times
    error(i) = std(peaks); % Compute standard deviation of peaks

%         % Plot demod/dec ST data interval
%         figure(i+1)
%         plot(t(ti),XM(ti)); hold on % Demod/dec ST data 
%         plot(locs, peaks, '*')  % Plot peaks of transmissions
%         
%         % Format plot
%         xlabel('Time (UTC)'); ylabel('Pressure (µPa)');title("Demodulated/Decimated ST Data "+ test_name)
%         set(gca,'FontSize',15) % Sets FontSize to 15
%         legend('Soundtrap')
%         grid on; grid minor;
    
        % Plot line for receiver time
        %xline(control_receiver.time(PingTagIndex(i)),'r','LineWidth',2,'DisplayName','A69-1602-59951 (Hi/7m)')

end

% Compute Range for pings using GPS track
gps_time = datenum(gps_track.Time, 'yyyy-mm-ddTHH:MM:SS'); % Convert gps time string to datenum vector
gps_time = datetime(gps_time,'ConvertFrom','datenum'); % Convert gps datenum to datetime vector
SPL = 20*log10(peak_mean); % Convert Pressure (uPa) to SPL (dB)

clear range closest_index
for i = 1:length(loc_mean)
    target = loc_mean(i); % Target value.
    temp = abs(target - gps_time); % Temporary "distances" array.
    closest_index(i) = find(temp == min(abs(target - gps_time))); % Find "closest" values array wrt. target value.
    range(i) = deg2km(distance(ST_location(1),ST_location(2),gps_track.Latitude(closest_index(i)),gps_track.Longitude(closest_index(i))))*1000; % Compute range (m) from hydrophone to ping
end

% Circle pings that werent detected
r135470.detections = []; r135472.detections = [];
for i = 1:length(loc_mean)  
    if any(r135470.time >= loc_mean(i)-seconds(2.5) & r135470.time <= loc_mean(i)+seconds(2.5))
        r135470.detections(i) = 1;
    else 
        r135470.detections(i) = 0;
    end

    if any(r135472.time >= loc_mean(i)-seconds(2.5) & r135472.time <= loc_mean(i)+seconds(2.5))
        r135472.detections(i) = 1;
    else 
        r135472.detections(i) = 0;
    end
end

% Plot SPL, rms noise, non-detections vs Range
figure
plot(range,SPL, 'r*'); hold on
plot(range(find(r135470.detections == 0)), SPL(find(r135470.detections == 0)), 'ko', 'MarkerSize', 10)
plot(range(find(r135472.detections == 0)), SPL(find(r135472.detections == 0)), 'kx', 'MarkerSize', 10)

toc

%% Plot SL of Hi and Lo Power Pings
plot(1,157.5,'rx','MarkerSize',10,'LineWidth',3) % Plot SL of Hi Pingers @ 1m

%% Format Plot
xlabel('Range(m)'); ylabel('SPL (dB re 1 µPa)'); title("SPL vs Range: " + test_name)
ylim([65 160])
set(gca,'FontSize',15) % Sets FontSize to 15
grid on; grid minor;
legend('Hi Power Average (Tag 7m depth)', 'NOT DETECTED (VR2W 10m depth)','NOT DETECTED (VR2W 10m depth)', 'Hi SL (157.5 dB re 1 µPa)')

%% Compute RMS noise entire drift
XM_rms = 20*log10(sqrt(mean(XM(find(t >= r135471.time(1),1):find(t >= r135471.time(end),1)).^2))); % 08-04 ep
yline(XM_rms,'DisplayName', 'RMS Noise Level (entire drift)')