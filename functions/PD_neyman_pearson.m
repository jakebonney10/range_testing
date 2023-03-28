function [PD] = PD_neyman_pearson(SNR,PFA)
%PD_neyman_pearson 
%   
%   function [PD] = PD_neyman_pearson(SNR,PFA)
%
%   Calculate full probability of detection function using the Neyman
%   Pearson criterion for a given SNR and probability of false alarm. 
%   Typical false alarm values are .01-.05 (1%-5%).

PD = PFA.^(1./(1+SNR));

end

