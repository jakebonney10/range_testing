function [receiver] = read_vemco(filename)

% [receiver] = read_vemco(filename)
%
%   Retrieve VEMCO receiver data from Excel File
%
%   VR2W_134922: Control Receiver Tag Line
%   VR2W_135471: Control Receiver Tag Line 
%   VR2W_135470: Bottom Reciever Soundtrap Line
%   VR2W_135472: Bottom Reciever Soundtrap Line
%   r134922, r135470, r135471, r135472
% 
%   Ex.)
%       filename = 'VR2W_135472_20210506_west.csv';
%       r135472 = read_vemco(filename); % Attribute receiver object to receiver ID

[~,~,receiver.data]=xlsread(filename); % parse data from excel file
receiver.time = receiver.data(:,1); % detection time (UTC)
receiver.time = datetime(receiver.time(2:end)); % convert time to datetime
receiver.tag = receiver.data(:,3); % detection tag ID
receiver.tag = string(receiver.tag(2:end)); % convert tag ID to string
receiver.table = table(receiver.time,receiver.tag); % create table of receiver detection time and tag ID

end