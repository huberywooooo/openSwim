function ss=half_fft(time,accel) 
    %% half_fft - Calculate the half-frequency Fourier Transform of the acceleration signal
    % Input parameters:
    % time - Time vector
    % accel - Acceleration vector
    % Output parameters:
    % freq - Frequency vector
    % amplitude - Amplitude vector
    % phase - Phase vector
    % topfreq - Top three frequencies and their corresponding amplitudes
    %% Example usage:
    % [freq, amplitude, phase] = half_fft(time, accel)
    % ss = half_fft(time, accel);
    % ss.freq
    % ss.amplitude
    % ss.phase
    % ss.topfreq
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University


    %% Ensure the length of the time vector and acceleration vector are the same
    if length(time) ~= length(accel)
        error('The length of the time vector and acceleration vector must be the same.');
    end
    % Calculate the time interval
    dt = mean(diff(time)); % Average time interval dt = time(2) - time(1);
    % Calculate the sampling frequency
    fs = 1/dt;
    % Get the length of the signal
    n = length(accel);
    % Perform the Fourier Transform
    y = fft(accel, n);
    
    %% Compute the amplitude of the double-sided spectrum
    p1 = abs(y/n);
    % Get the amplitude of the single-sided spectrum
    amplitude = p1(1:n/2+1);
    amplitude(2:end-1) = 2 * amplitude(2:end-1); % Multiply by 2 except for the DC and Nyquist components
    % Create the frequency vector
    freq = fs * (0:(n/2)) / n;
    
    % Find the top three frequencies and their corresponding amplitudes
    [sortedamplitudes, sortidx] = sort(abs(amplitude), 'descend');
    % Get the indices of the top three amplitudes
    topidxs = sortidx(1:3);
    % Get the corresponding frequencies and amplitudes
    top_freq(:,1) = freq(topidxs);
    top_freq(:,2) = sortedamplitudes(1:3);
    
    %% Compute the phase of the double-sided spectrum
    p2 = angle(y/n);
    % Get the phase of the single-sided spectrum
    phase = p2(1:n/2+1);
    phase(2:end-1) = 2 * phase(2:end-1); % Multiply by 2 except for the DC and Nyquist components
    
    %% Create a structure to store all features
    ss.freq = freq;
    ss.amplitude = amplitude;
    ss.phase = phase;
    ss.topfreq = top_freq;
    
end % function half_fft