function [y, t] = convolve(amplitude, delay, x, fs, signal_duration)

% [y, t] = convolve(amplitude, delay, x, fs, signal_duration)

%
%   Convolves source times series with bellhop arrivals output to generate
%   a receive time series by shifting source signal over arrival impulse
%   response.
%
%   Input: (amplitude and delay bellhop output, source signal, sampling frequency fs(Hz), source duration(s))
%   Output: receive amplitude y, receive time series t
%
% Ex.) 
% [delay,ind] = sort(delay);
% amplitude = amplitude(ind);
% fs = 1e6; % Sampling frequency
% vemco_duration = 0.005; % 5ms signal
% [x, t] = generate_sts(f, fs, vemco_duration, A)
% [y, t2] = convolve(amplitude, delay, x, fs, vemco_duration)

y = zeros(round((delay(end)-delay(1)+ 15*signal_duration)*1e7),1);
for i = 1:length(delay)
    n_start = round(delay(i)*fs);
    n_end = n_start + signal_duration*fs;
    y(n_start:n_end) = y(n_start:n_end) + amplitude(i)*x;
end
t = (0:length(y)-1)/fs;