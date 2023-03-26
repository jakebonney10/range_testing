% bellhop_arrivals script
% Bonney
% 3/1/2023

% GOAL: Run Bellhop in "arrivals" mode and propagate the source through the
%       channel by convolving the model with the source signal (5ms, 69kHz ping). 

clc, clearvars

%% Filename
filename = ['west_passage_8-4_A'];

%% Run Bellhop in Arrivals mode and 
bellhop(filename) % Change env file to 'A' case (arrival mode)

%% Read .arr file output
[ Arr, Pos ] = read_arrivals_asc(append(filename, '.arr'));

%% Get recieve signal timeseries from .arr file...
%  Plot arrivals for given range and depth index
irr = 241; % receiver range index
ird = 78; % receiver depth index
isd = 1; % source depth index
Narr = Arr( irr, ird, isd ).Narr;
delay = real( Arr( irr, ird, isd ).delay( 1 : Narr ) ); % received arrivals time series
amplitude = abs( Arr( irr, ird, isd ).A( 1 : Narr ) ); % received arrivals amplitude
rangle = Arr( irr, ird, isd ).RcvrDeclAngle( 1 : Narr ); % receiver grazing angle
numbotbnc = Arr( irr, ird, isd ).NumBotBnc( 1 : Narr ); % number of bottom bounces

%% Sort ascending based on delay
[delay,ind] = sort(delay);
amplitude = amplitude(ind);
rangle = rangle(ind);
numbotbnc = cast(numbotbnc(ind), "double");
