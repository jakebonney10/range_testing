%% Convolve source timeseries with impulse response (IRF)

% Define the parameters
A = 1; % Amplitude of source signal
f = 69000; % Frequency of source signal
fs = 1e6; % Sampling frequency
vemco_duration = 0.005; % 5ms signal
t = (0:1/fs:vemco_duration)'; % Time vector for source signal
SL = 160; % Source Level for converting normalized amplitude to Pa

% Calculate scattering loss and apply to amplitude
theta = (90 - rangle)*pi/180; % convert from incident angle to grazing angle and radians
sigma = .01; % 1cm (cobble/sand) % guess and compare model to data
loss = scatterrg(f,1500,sigma,theta);
lossy_amplitude = amplitude.*loss.^numbotbnc.*(10^(SL/20)/1e6); % value of 100 comes from source level 160dB

% Generate source signal
x = A*sin(2*pi*f*t);

%% Convolve by shifting source signal over arrival impulse response
y = zeros(600000,1);
for i = 1:length(delay)
    n_start = round(delay(i)*fs);
    n_end = n_start + vemco_duration*fs;
    y(n_start:n_end) = y(n_start:n_end) + lossy_amplitude(i)*x;
end

t2 = (0:599999)/fs;

%% Demodulation complex envelope calculation
[X1,X2] = demod(y,f,fs,'qam');
ymag = sqrt(X1.^2+X2.^2);

%% Plot signals
subplot(4,1,1)
plot(t, x)
title('Source Signal')
xlabel('Time (s)')
ylabel('Amplitude')
xlim([0 0.030])

subplot(4,1,2)
stem(delay, amplitude)
title( [ 'Bellhop Arrivals ','Src_z  = ', num2str( Pos.s.z( isd ) ), ...
   ' m    Rcvr_z = ', num2str( Pos.r.z( ird ) ), ...
   ' m    Rcvr_r = ', num2str( Pos.r.r( irr ) ), ' m' ] )
xlabel( 'Time (s)' )
ylabel( 'Amplitude' )
xl = xlim;

subplot(4,1,3)
plot(t2, y)
title('Receive Signal')
xlabel('Time (s)')
ylabel('Amplitude')
xlim([xl(1) xl(2)])

subplot(4,1,4)
plot(t2,ymag)
xlim([xl(1) xl(2)])
title('Complex Envelope')
xlabel('Time (s)')
ylabel('Amplitude')