%--------------------%
%  Jake Bonney
%  RIDEM DMF/URI
%  Bellhop Modeling
%  4/27/21
%--------------------%

clc; clear all; close all;

%% Filename
filename = ['west_passage_8-4'];

%% Plot Model SSP
figure
plotssp(filename + ".env")
title('SSP')
grid on;

%% Bellhop Rays 
figure
bellhop(filename) % Change env file to 'R' case (ray)
plotray(filename)

%% Bellhop shd + TL 
bellhop(filename) % Change env file to 'IB' case (incoherent TL, Gaussian Beam) 
figure
plotshd(append(filename, '.shd'), 69000) 
figure 
[tl, rkm] = plottlr(append(filename, '.shd'),10);
grid on; grid minor;

%% Bellhop arrivals
%bellhop(filename) % Change env file to 'A' case (arrival)
plotarr(append(filename, '.arr'), 501, 78, 1) % irr (receiver range), ird (receiver depth), isd (source depth)

%% Propagate the source through the channel by convolving the modeled channel with the source signal (a 5 ms, 69 kHz ping).
%TStart = -0.001; % Vemco 5ms pulse
%TEnd   =  0.004;
%sample_rate = 192000;
%t_sts       = linspace( TStart, TEnd, ( TEnd - TStart ) * sample_rate )';
%omega = 2 * pi * 69000; % Vemco 69 kHz source center frequency
%pulse = 'P'; 
%[ S, PulseTitle ] = cans(t_sts, omega, pulse) % create source timeseries
%delayandsum() % convolve source timeseries with arrival time series.
%plotts(filename)  % plot either the source or receiver timeseries.

%% Save variables
save('TL_sr_june','rkm_incoherent','tl_incoherent')

%% Run Bellhop tlr
[rkm_sand_surface, tl_sand_surface] = plottlr(append('BI_june_sand', '.shd'),1);
[rkm_sand_depth, tl_sand_depth] = plottlr(append('BI_june_sand', '.shd'),25);
[rkm_silt_surface, tl_silt_surface] = plottlr(append('BI_june_silt', '.shd'),1);
[rkm_silt_depth, tl_silt_depth] = plottlr(append('BI_june_silt', '.shd'),25);

%% Plot Bellhop, RMS noise level, threshold
figure
plot(1,157.5,'rx','MarkerSize',10,'LineWidth',3,'DisplayName','Source Level') % Plot SL of Hi Pingers @ 1m
hold on
yline(80,'DisplayName','RMS Noise Level','LineWidth',2)
yline(88,'-.', 'DisplayName','D50 Detection Threshold','LineWidth',2)
grid on; grid minor
ylim([60 160]); xlim([0 1200])
ylabel('SPL (dB re 1 uPa)')
xlabel('Range (meters)')
title('Block Island Summer Scenarios')
set(gca,'FontSize',12)
legend

plot(rkm_sand_surface(25:end)*1000,157.5-tl_sand_surface(25:end),'r','DisplayName','Receiver @ Surface/Sandy Bottom','LineWidth',1)
plot(rkm_sand_depth(25:end)*1000,157.5-tl_sand_depth(25:end),'r--','DisplayName','Receiver @ Depth/Sandy Bottom','LineWidth',1)
plot(rkm_silt_surface(25:end)*1000,157.5-tl_silt_surface(25:end),'b','DisplayName','Receiver @ Surface/Silty Bottom','LineWidth',1)
plot(rkm_silt_depth(25:end)*1000,157.5-tl_silt_depth(25:end),'b--','DisplayName','Receiver @ Depth/Silty Bottom','LineWidth',1)

D50_sand_surface = rkm_sand_surface(find(tl_sand_surface(25:end) >= (157.5 - 80 - 8),1)+25)*1000
D50_sand_depth = rkm_sand_depth(find(tl_sand_depth(25:end) >= (157.5 - 80 - 8),1)+25)*1000
D50_silt_surface = rkm_silt_surface(find(tl_silt_surface(25:end) >= (157.5 - 80 - 8),1)+25)*1000
D50_silt_depth = rkm_silt_depth(find(tl_silt_depth(25:end) >= (157.5 - 80 - 8),1)+25)*1000

%% Compare average of broadband frequency method (68500-69500)
% run bellhop for both frequencies and save the TL output. 
tl_ave = (tl_68500+tl_69500)./2;
plot(rkm, 157.5 - tl_69000, 'r')
hold on
plot(rkm, 157.5 - tl_68500)
plot(rkm, 157.5 - tl_69500)
plot(rkm, 157.5 - tl_ave, 'k--')
xlim([0 1.250]); ylim([60 160])
grid on; legend;
ylabel('SPL (dB re 1 uPa)')
xlabel('Range (km)')
title('Vemco Broadband Model Comparison')