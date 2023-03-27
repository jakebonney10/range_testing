% Convolve source timeseries with impulse response (IRF)

%% Get recieve signal timeseries from .arr file...
for i = 1:length(Arr)

    irr = i; % receiver range index
    ird = 78; % receiver depth index
    isd = 1; % source depth index
    Narr = Arr( irr, ird, isd ).Narr;
    delay = real( Arr( irr, ird, isd ).delay( 1 : Narr ) ); % received arrivals time series
    amplitude = abs( Arr( irr, ird, isd ).A( 1 : Narr ) ); % received arrivals amplitude
    rangle = Arr( irr, ird, isd ).RcvrDeclAngle( 1 : Narr ); % receiver grazing angle
    numbotbnc = Arr( irr, ird, isd ).NumBotBnc( 1 : Narr ); % number of bottom bounces

    if Narr == 0
        continue
    end
    
    %% Sort ascending based on delay
    [delay,ind] = sort(delay);
    amplitude = amplitude(ind);
    rangle = rangle(ind);
    numbotbnc = cast(numbotbnc(ind), "double");

    %% Generate source signal
    A = 1; % Amplitude of source signal
    f = 69000; % Frequency of source signal
    fs = 1e6; % Sampling frequency
    vemco_duration = 0.005; % 5ms signal
    [x, t] = generate_sts(f, fs, vemco_duration, A);

    %% Calculate scattering loss and apply to amplitude
    theta = (90 - rangle)*pi/180; % convert from incident angle to grazing angle and radians
    sigma = .01; % 1cm (cobble/sand) % guess and compare model to data
    SL = 157.5; % Source Level for converting normalized amplitude to Pa
    loss = scatterrg(f,1500,sigma,theta);
    lossy_amplitude = amplitude.*loss.^numbotbnc.*(10^(SL/20)/1e6); % value of 100 comes from source level 160dB

    %% Convolve by shifting source signal over arrival impulse response
    clear y 
    [y, t2] = convolve(lossy_amplitude, delay, x, fs, vemco_duration);

    %% Demodulation complex envelope calculation
    [X1,X2] = demod(y,f,fs,'qam');
    ymag = sqrt(X1.^2+X2.^2);
    spl_convolved(i) = 20*log10(max(ymag)/1e-6);
    alpha = 19.5279; % absorption coeficient
    spl_abs(i) = spl_convolved(i) - Pos.r.r(i)*alpha/1000; % loss due to absorption
    TL(i) = TL_geometric(Pos.r.r(i),alpha,15);
end

%% Plot 
plot(1,157.5,'rx','MarkerSize',10,'LineWidth',2,'DisplayName','Source Level') % Plot SL of Hi Pingers @ 1m
hold on
plot(Pos.r.r, spl_att,'r','DisplayName','Bellhop Arrivals Convolution')
plot(rkm_incoherent*1000, SL - tl_incoherent,'b','LineWidth',2,'DisplayName','Bellhop Incoherent TL')
xlim([0 1000])
ylim([60 160])
grid on; grid minor
ylabel('SPL (dB re 1 uPa)')
xlabel('Range (meters)')
title('Bellhop Arrivals vs Incoherent TL Output')
legend
plot(Pos.r.r, SL - TL,'k','LineWidth',2,'DisplayName','Simple Geometric TL')


