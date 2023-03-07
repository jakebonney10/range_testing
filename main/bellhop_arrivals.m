% bellhop_arrivals script
% Bonney
% 3/1/2023

% GOAL: Run Bellhop in "arrivals" mode and propagate the source through the
%       channel by convolving the model with the source signal (5ms, 69kHz ping). 

clc, clearvars

%% Filename
filename = ['west_passage_8-4_A'];

%% Plot Model SSP
figure
plotssp(filename + ".env")
title('SSP')
grid on;

%% Run Bellhop in Arrivals mode
bellhop(filename) % Change env file to 'A' case (arrival mode)

%% Plot arrivals for given range and depth index
irr = 501; % receiver range index
ird = 78; % receiver depth index
isd = 1; % source depth index
plotarr(append(filename, '.arr'), irr, ird, isd) 

%% Create source signal timeseries


%% Create receiver timeseries


%% Propagate the source through the channel by convolving the model with the source signal

