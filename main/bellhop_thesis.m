%--------------------%
%  Jake Bonney
%  RIDEM DMF/URI
%  Bellhop Modeling
%  4/27/21
%--------------------%

clc; clear all; close all;

%% Filename
filename = ['BI_june_sand' ];

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
[rkm_sand_surface, tl_sand] = plottlr(append(filename, '.shd'),4);
grid on; grid minor;

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


