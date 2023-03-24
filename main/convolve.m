%% Convolve source timeseries with impulse response (IRF)

% Load the time delay and arrival amplitude pairs
tb = table(rts',h');
tb = sortrows(tb);
delay = tb.Var1;
amplitude = tb.Var2;

% Define the parameters
A = 1; % Amplitude of source signal
f = 69000; % Frequency of source signal
fs = 1e6; % Sampling frequency
vemco_duration = 0.005; % 5ms signal
t = 0:1/fs:vemco_duration; % Time vector for source signal
t = t'; 

% Generate source signal
x = A*sin(2*pi*f*t);

%% Convolve by shifting source signal over arrival impulse response
y = zeros(600000,1);
for i = 1:length(delay)
    n_start = round(delay(i)*fs);
    n_end = n_start + vemco_duration*fs;
    y(n_start:n_end) = y(n_start:n_end) + amplitude(i)*x;
end

t2 = (0:599999)/fs;

%% Demodulation complex envelope calculation
[X1,X2] = demod(y,f,fs,'qam');
ymag = sqrt(X1.^2+X2.^2);

%% Plot signals
subplot(4,1,2)
stem(rts,h)
title( [ 'Bellhop Arrivals ','Src_z  = ', num2str( Pos.s.z( isd ) ), ...
   ' m    Rcvr_z = ', num2str( Pos.r.z( ird ) ), ...
   ' m    Rcvr_r = ', num2str( Pos.r.r( irr ) ), ' m' ] )
xlabel( 'Time (s)' )
ylabel( 'Amplitude' )

subplot(4,1,1)
plot(t, x)
title('Source Signal')
xlabel('Time (s)')
ylabel('Amplitude')
xlim([0 0.030])

subplot(4,1,3)
plot(t2, y)
title('Receive Signal')
xlabel('Time (s)')
ylabel('Amplitude')
xlim([0.41 0.44])

subplot(4,1,4)
plot(t2,ymag)
xlim([0.41 0.44])
title('Complex Envelope')
xlabel('Time (s)')
ylabel('Amplitude')