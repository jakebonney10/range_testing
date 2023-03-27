function [x, t] = generate_sts(f, fs, signal_duration, amplitude)

% [sts] = generate_sts(f, fs, duration, amplitude)
%
%   Generates source time series for convolution.
%
%   Input: (frequency f(Hz), sampling frequency fs(Hz), source duration(s), amplitude)
%   Output: source time series t
%
% Ex.) 
% A = 1; % Amplitude of source signal
% f = 69000; % Frequency of source signal
% fs = 1e6; % Sampling frequency
% vemco_duration = 0.005; % 5ms signal
% [x,t] = generate_sts(f, fs, vemco_duration, A)


t = (0:1/fs:signal_duration)'; % Time vector for source signal
x = amplitude*sin(2*pi*f*t);
