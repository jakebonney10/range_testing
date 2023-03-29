SNR = 157.5 - tl_incoherent - XM_rms;
PFA = 0.002;
PD = PD_neyman_pearson(SNR,PFA);
plot(rkm_incoherent*1000, PD,'k-')