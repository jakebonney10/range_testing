% bellhop_arrivals script
% Bonney
% 3/1/2023

% GOAL: Run Bellhop in "arrivals" mode and propagate the source through the
%       channel by convolving the model with the source signal (5ms, 69kHz ping). 
%       Plot a single arrival range/depth index.

clc, clearvars

%% Filename
filename = ['west_passage_8-4_A'];

%% Run Bellhop in Arrivals mode and 
bellhop(filename) % Change env file to 'A' case (arrival mode)

%% Read .arr file output
[ Arr, Pos ] = read_arrivals_asc(append(filename, '.arr'));

%% Get recieve signal timeseries from .arr file...
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

%% Convolve source timeseries with impulse response (IRF)

% Generate source signal
A = 1; % Amplitude of source signal
f = 69000; % Frequency of source signal
fs = 1e6; % Sampling frequency
vemco_duration = 0.005; % 5ms signal
[x, t] = generate_sts(f, fs, vemco_duration, A);

% Calculate scattering loss and apply to amplitude
theta = (90 - rangle)*pi/180; % convert from incident angle to grazing angle and radians
sigma = .01; % 1cm (cobble/sand) % guess and compare model to data
SL = 160; % Source Level for converting normalized amplitude to Pa
loss = scatterrg(f,1500,sigma,theta);
lossy_amplitude = amplitude.*loss.^numbotbnc.*(10^(SL/20)/1e6); % value of 100 comes from source level 160dB

%% Convolve by shifting source signal over arrival impulse response
[y, t2] = convolve(lossy_amplitude, delay, x, fs, vemco_duration);

%% Demodulation complex envelope calculation
[X1,X2] = demod(y,f,fs,'qam');
ymag = sqrt(X1.^2+X2.^2);
spl_convolved = 20*log10(max(ymag)/1e-6);

%% Plot signals
subplot(5,1,1)
plot(t, x)
title('Source Signal')
xlabel('Time (s)')
ylabel('Amplitude')
xlim([0 0.030])

subplot(5,1,2)
stem(delay, amplitude)
title( [ 'Bellhop Arrivals ','Src_z  = ', num2str( Pos.s.z( isd ) ), ...
   ' m    Rcvr_z = ', num2str( Pos.r.z( ird ) ), ...
   ' m    Rcvr_r = ', num2str( Pos.r.r( irr ) ), ' m' ] )
xlabel( 'Time (s)' )
ylabel( 'Amplitude' )
xl = xlim;

subplot(5,1,3)
plot(t2, y)
title('Receive Signal')
xlabel('Time (s)')
ylabel('Amplitude')
xlim([xl(1) xl(2)])

subplot(5,1,4)
plot(t2,ymag)
xlim([xl(1) xl(2)])
title('Complex Envelope')
xlabel('Time (s)')
ylabel('Amplitude')
