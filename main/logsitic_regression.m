%--------------------%
%  Jake Bonney
%  RIDEM DMF/URI
%  Logistic Regression
%  10/7/21
%--------------------%

clc; clear all; close all;

%% Logistic Regression Analysis 

d = readtable('GLM_data_matlab.xlsx','ReadRowNames',true,"UseExcel",true)
y = d.Detection;
X = d.Range;
test = d.Test;

%% Plot Regression and Confidence Intervals Splice plot
range_test = 2;% 1=wp_nov17, 2=wp_nov19, 3=wp_may06, 4=ep_may06, 5=sr_jun23, 6=wp_aug04
index = find(test == range_test);
glm_data = sortrows([X(index) y(index)]);
mdl = fitglm(glm_data(:,1),glm_data(:,2),'linear','Distribution','binomial')
plotSlice(mdl)

%% Plot GLM fit
colororder({'k','k'})
yyaxis right
[b,dev,stats] = glmfit(glm_data(:,1),glm_data(:,2),'binomial','Link','logit');
range_vector = linspace(0,1250,1250);
[yfit, dylo, dyhi] = glmval(b,range_vector,'logit',stats);

% Plot GLM fit
h_glm = plot(range_vector,yfit,'k-','LineWidth',2,'DisplayName','GLM (95% Confidence Bounds)')

% Plot detections
plot(glm_data(:,1),glm_data(:,2),'ko','LineWidth',1,'DisplayName','VR2W Detections (0/1)')

% Plot 95% confidence bounds
err_lo = yfit-dylo;
err_hi = yfit+dylo;
%plot(range_vector,err_lo,'k--',range_vector,err_hi,'k--') 
h = shade(range_vector,err_lo,'k-',range_vector,err_hi,'k-','FillType',[2 1],'LineWidth',1,'Marker','none');

% Format
ylim([0 1]);
ylabel('Probability of Detection')

%% Plot and calculate d50 range
%yline(0.5,'m','DisplayName','50% Detection Probability','LineWidth',2)
d50_lo = find(err_lo <= 0.5, 1)
d50_hi = find(err_hi <= 0.5, 1)
d50 = find(yfit <= 0.5, 1)
xline(range_vector(d50),'m--','DisplayName','D50 Range','LineWidth',2)
% legend('AutoUpdate','off')
% xline(range_vector(d50_lo),'m--','DisplayName','D50 Range Bounds','LineWidth',2)
% xline(range_vector(d50_hi),'m--','DisplayName','D50 upper bound','LineWidth',2)

%% Calculate Detection threshold level
d50modelrange_lo = find(rkm_incoherent*1000 >= d50_lo,1);
d50modelrange_hi = find(rkm_incoherent*1000 >= d50_hi,1);
d50modelrange = find(rkm_incoherent*1000 >= d50,1);

d50threshold_lo = 157.5-tl_incoherent(d50modelrange_lo)- XM_rms;
d50threshold_hi = 157.5-tl_incoherent(d50modelrange_hi)- XM_rms;
d50threshold = 157.5-tl_incoherent(d50modelrange)- XM_rms

%% Calculate Detection Threshold Range w/ Bellhop Output and NL
threshold = 8; % dB above NL
tl_incoherent_trim = tl_incoherent(20:end);
rkm_incoherent_trim = rkm_incoherent(20:end);
bhop_range = rkm_incoherent_trim(find(tl_incoherent_trim >= (157.5 - XM_rms - threshold),1))*1000

%% Plot detection threshold and bhop range
detection_threshold = XM_rms + threshold;
yline(detection_threshold,'g','DisplayName','Detection Threshold (8 dB > NL)','LineWidth',2)

%% Plot GLM fit all locations
plot(linspace(0,1250,1250),yfit,'c-','LineWidth',2)
legend('West Passage 11/17/21','West Passage 11/19/21','West Passage 05/06/21','East Passage 05/06/21','Sakonnet River 06/23/21','West Passage 08/04/21','d50 Probability')