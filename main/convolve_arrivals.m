% convolve_arrivals script
% Bonney
% 3/29/2023

% GOAL:  Read Bellhop "arrivals" mode output and propagate the source through the
%       channel by convolving the model with the source signal (5ms, 69kHz ping). 
%       Generate a plot showing receive level as a function of range. 

clc, clearvars

%% Read .arr file output
filename = ['west_passage_8-4_A'];

%% Generate source signal
A = 1; % Amplitude of source signal
f = 69000; % Frequency of source signal
fs = 1e6; % Sampling frequency
vemco_duration = 0.005; % 5ms signal
[x, t] = generate_sts(f, fs, vemco_duration, A);

%% Loop through each receiver range and perform convolution...
for k = 1:length(filename)
    
    [ Arr, Pos ] = read_arrivals_asc(append(filename(k,:), '.arr'));

    for j = [find(Pos.r.z >= 10,1)] % 9/80 for wp, 1/166 for BI, 26 for SR, 47 for EP
    
        for i = 1:length(Arr)
    
            irr = i; % receiver range index
            ird = j; % receiver depth index (80/9 for WP/EP, 26 for SR)
            isd = 1; % source depth index
            Narr = Arr( irr, ird, isd ).Narr;
            delay = real( Arr( irr, ird, isd ).delay( 1 : Narr ) ); % received arrivals time series
            amplitude = abs( Arr( irr, ird, isd ).A( 1 : Narr ) ); % received arrivals amplitude
            rangle = Arr( irr, ird, isd ).RcvrDeclAngle( 1 : Narr ); % receiver grazing angle
            numbotbnc = Arr( irr, ird, isd ).NumBotBnc( 1 : Narr ); % number of bottom bounces
        
            if Narr == 0
                continue
            end
            
            % Sort ascending based on delay
            [delay,ind] = sort(delay);
            amplitude = amplitude(ind);
            rangle = rangle(ind);
            numbotbnc = cast(numbotbnc(ind), "double");
        
            % Calculate scattering loss and apply to amplitude
            theta = (90 - rangle)*pi/180; % convert from incident angle to grazing angle and radians
            sigma = .01; % 1cm (cobble/sand) % guess and compare model to data
            SL = 157.5; % Source Level for converting normalized amplitude to Pa
            loss = scatterrg(f,1500,sigma,theta);
            lossy_amplitude = amplitude.*loss.^numbotbnc.*(10^(SL/20)/1e6); % value of 100 comes from source level 160dB
        
            % Convolve by shifting source signal over arrival impulse response
            clear y 
            [y, t2] = convolve(lossy_amplitude, delay, x, fs, vemco_duration);
        
            % Demodulation complex envelope calculation
            [X1,X2] = demod(y,f,fs,'qam');
            ymag = sqrt(X1.^2+X2.^2);
        
            % Convert to SPL (dB) from pressure (Pa)
            SPL_conv(i) = SPL(max(ymag)/1e-6);
            alpha = 19.5279; % absorption coeficient (dB/km)
            SPL_att(i) = SPL_conv(i) - Pos.r.r(i)*alpha/1000; % loss due to absorption
            TL(i) = TL_geometric(Pos.r.r(i),alpha,15);
        end
    
        % Plot 
        plot(Pos.r.r, SPL_att,'b','DisplayName','Bellhop Arrivals Convolution')
        hold on
        
        % Smooth the signal using a moving average filter
        windowSize = 50;
        b = (1/windowSize)*ones(1,windowSize);
        a = 1;
        SPL_smooth = filter(b,a,SPL_att(5:end)); 
        SPL_smooth = [SPL_smooth((windowSize/2+1):end), zeros(1,windowSize/2)]; % account for filter delay
        plot(Pos.r.r(5:end), SPL_smooth,'k','DisplayName','Bellhop Arrivals Convolution Smooth')
        title( [ 'Bellhop Arrivals ','Src_z  = ', num2str( Pos.s.z( isd ) ), ...
           ' m    Rcvr_z = ', num2str( Pos.r.z( ird ) ), ...
           ' m    Rcvr_r = ', num2str( Pos.r.r( irr ) ), ' m' ] )
        grid on
        hold on
        
        % Calculate D50 Range
        NL = 80; % Noise Level (dB)
        DT = 8; % Detection Threshold (dB)
        yline(NL+DT,'-.', 'DisplayName','D50 Detection Threshold','LineWidth',2)
        disp(filename(k,:))
        disp(Pos.r.z(j))
        D50 = Pos.r.r(find(SPL_smooth(100:end) <= (NL + DT),1)+100)
    end

end

%% Save variables
XM_rms = 82;
save(filename, 'Pos', 'SPL_smooth', 'XM_rms')
