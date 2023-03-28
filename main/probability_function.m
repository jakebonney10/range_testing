SNR = 157.5 - tl_incoherent - XM_rms;
PFA = 0.002;
PD = PD_neyman_pearson(SNR,PFA);

figure
plot(rkm_incoherent*1000, PD,'k')
xlim([0 960])

%%
% Define the logistic function
logistic = @(x,a,b,c) 1./(1+exp(-a*(x-b))) + c;

% Set the range of SNR values to evaluate
SNR_values = -10:0.1:20;

% Set the PFA value
PFA = 0.05;

% Fit the logistic function to the data using logistic regression
[coefficients, goodness_of_fit] = fit(SNR_data, PD_data, logistic, 'StartPoint', [1, 0, 0.5]);

% Calculate the corresponding PD values for each SNR value using the fitted parameters
PD_values = coefficients.a./(1+exp(-coefficients.b*(SNR_values-coefficients.c))) + coefficients.d;

% Plot the PD values as a function of SNR
plot(SNR_values, PD_values, 'b.-');
xlabel('SNR');
ylabel('PD');
title(['PD vs SNR (PFA = ', num2str(PFA), ')']);
grid on;