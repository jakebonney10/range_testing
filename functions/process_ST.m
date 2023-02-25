function process_ST(filename)

% process_ST(filename) 
%   
%   This function processes the soundtrap .wav file for range testing
%   analysis. It handles the calibration, demodulation, decimation, and filtering
%   steps outlined in the MS thesis. It saves the magnitude of the signal XM and 
%   datetime vector t to a .mat file. It requires the 3rd party function xml2struct. 

%% Specify Soundtrap filename
tic
filename = '5777.201119103847'; % Soundtrap file handle
disp(['Soundtrap File: ', filename])

%% XML read sample start/stop time
STxml = xml2struct(filename + ".log.xml");
SampleStartTimeUTC = append(STxml.ST.PROCu_EVENT{1,2}.WavFileHandler.Attributes.SamplingStartTimeUTC,'.000');
SampleStopTimeUTC = append(STxml.ST.PROCu_EVENT{1,4}.WavFileHandler.Attributes.SamplingStopTimeUTC,'.000');
t1 = datenum(SampleStartTimeUTC,'yyyy-mm-ddTHH:MM:SS.FFF'); % sampling start time (ms)
t2 = datenum(SampleStopTimeUTC,'yyyy-mm-ddTHH:MM:SS.FFF'); % sampling stop time (ms)
disp(['Sampling Start: ', SampleStartTimeUTC])
disp(['Sampling Stop: ', SampleStopTimeUTC])

%% Convert .wav data to units of µPa using end-end calibration value (from soundtrap manual)
disp('Reading/Converting data to units of µPa...')
[y, Fs] = audioread(filename + ".wav") ; % read wav data from file
cal = 173.3; % value from calibration sheet
cal = power(10, cal / 20); % convert calibration from dB into ratio
y = y * cal; % multiply wav data by calibration to convert to units of uPa

%% Demodulate
disp('Demodulating Data...')
Fc = 69000; % Carrier Frequency (Hz)
[X1,X2] = demod(y,Fc,Fs,'qam'); % Quadrature demodulation

%% Decimate
disp('Decimating Data...')
X1 = decimate(X1,12); X1 = decimate(X1,2); % Decimate real part by factor of 24 (12 and 2) 
X2 = decimate(X2,12); X2 = decimate(X2,2); % Decimate imaginary part by factor of 24 (12 and 2) 

%% Low Pass Filter
disp('Applying Low Pass Filter...')
Fstop = 2000;                   % Cut off frequency in Hz
Wn = ((Fs/24)/2);               % Normalized freq Wn 
[b,a] = butter(6,Fstop/Wn);     % Butterworth low pass filter
X1 = filtfilt(b,a,X1);          % filtfilt zero phase shift
X2 = filtfilt(b,a,X2);          % filtfilt zero phase shift

%% Compute Magnitude and Phase
disp('Computing Magnitude/Phase...')
XM = sqrt(X1.^2+X2.^2); % Magintude
XP = atan2(X2,X1); % Phase

%% Create datetime vector with first/last ping interval
disp('Creating decimated Datetime vector...')
t_num = linspace(t1,t2,length(y)); % create time vector from start time to stop time
t = datetime(t_num,'ConvertFrom','datenum'); % create datetime vector

%% Save Variables
disp(['Saving variables to ', filename,'.mat'])
save([filename,'.mat'],'XM','t','SampleStartTimeUTC','SampleStopTimeUTC')
toc

%% Contencate vectors from same day
% x1.XM = XM; x1.t = t; x1.SampleStartTimeUTC = SampleStartTimeUTC;
% x2.XM = XM; x2.t = t;
% x3.XM = XM; x3.t = t; x3.SampleStopTimeUTC = SampleStopTimeUTC;

% XM = [x1.XM; x2.XM(2:end); x3.XM(2:end)];
% t = [x1.t x2.t(2:end) x3.t(2:end)];
% SampleStartTimeUTC = x1.SampleStartTimeUTC;
% SampleStopTimeUTC = x3.SampleStopTimeUTC;
% save('sk_june','XM','t','SampleStartTimeUTC', 'SampleStopTimeUTC')

end