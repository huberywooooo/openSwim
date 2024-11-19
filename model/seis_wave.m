function sw = seis_wave(mode, varargin)
    % seiswave: generate or load seismic wave data
    %
    % Usage:
    %   seiswave('gen', dtime, tt, t)     % Generate a synthetic pulse wave
    %   seiswave('read', filename)        % Load seismic data from a file
    %
    % Input Parameters:
    %   mode      - 'gen' to generate seismic wave, 'read' to load from file
    %   varargin  - Additional arguments depending on the mode:
    %               For 'gen': 
    %                   dtime (time step), tt (total time), t (pulse time)
    %               For 'read':
    %                   filename (string), the name of the file to load
    %
    % Outputs:
    %   sw - Struct or array containing generated or loaded seismic wave data
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2009-2024 Chongqing Three Gorges University
    

    % Check if the input nargin is correct
    if nargin < 1 || isempty(mode)
        error('First input must be "gen" or "read".');
    end

    switch mode
        case 'gen'
            % Ensure the correct number of input arguments for 'gen' mode
            if length(varargin) < 3
                error('For "gen" mode, provide dtime, tt, and t as input arguments.');
            end
            % Unpack input arguments for 'gen' mode
            dtime = varargin{1};
            t = varargin{2};
            tt = varargin{3};
            % Generate seismic wave
            sw = gen_wave(dtime, t, tt);
        
        case 'read'
            % Ensure the correct number of input arguments for 'read' mode
            if length(varargin) < 1
                error('For "read" mode, provide the filename as an input argument.');
            end
            % Unpack input arguments for 'read' mode
            filename = varargin{1};
            % Read seismic wave from file
            data = load(filename);
            time = data(:, 1);
            accel = data(:, 2);
            % Process seismic wave
            sw = read_wave(time, accel);
        
        otherwise
            error('Invalid mode. Please use "gen" or "read".');
    end
    
end % function seiswave 


function sw = gen_wave(dtime,t,tt)
    % FUNCTION: gen_wave
    % 
    % DESCRIPTION:
    % This function generates a synthetic pulse wave based on specified parameters.
    %
    % INPUTS:
    %   dtime - Time step (in seconds) for the simulation.
    %   tt    - Total duration of the wave (in seconds).
    %   t     - Duration of the pulse (in seconds).
    %
    % OUTPUTS:
    %   sw.time - Time vector for the pulse wave.
    %   sw.acc  - Acceleration vector of the pulse wave.
    %   sw.vel  - Velocity vector of the pulse wave.
    %   sw.dis  - Displacement vector of the pulse wave.

    % generate a pulse wave
    sw.time = dtime:dtime:tt;
    sw.time = sw.time(:);    % Ensure sw.time is a column vector

    % Define the Heaviside function using an anonymous function
    % heaviside = @(x) max(0, min(1, x));

    % Calculate the function values for each segment of the wave
    f1 = (sw.time/t).^3 .* heaviside(sw.time/t);
    f2 = (sw.time/t - 1/4).^3 .* heaviside(sw.time/t - 1/4);
    f3 = (sw.time/t - 2/4).^3 .* heaviside(sw.time/t - 2/4);
    f4 = (sw.time/t - 3/4).^3 .* heaviside(sw.time/t - 3/4);
    f5 = (sw.time/t - 4/4).^3 .* heaviside(sw.time/t - 4/4);

    % Compute the displacement of the wave
    sw.dis = 16 * (f1 - 4*f2 + 6*f3 - 4*f4 + f5);

    % Calculate the velocity and acceleration of the wave
    sw.vel = gradient(sw.dis) ./ gradient(sw.time);
    sw.acc = gradient(sw.vel) ./ gradient(sw.time);

    % Write the log file to the file
    write_log('gen_wave has been executed.');

end % function gen_wave


function sw = read_wave(time, accel)
    % read_wave: Process seismic wave data from given time and acceleration arrays.
    %
    % Usage:
    %   sw = read_wave(time, accel)
    %
    % Inputs:
    %   time  - A numeric array representing the time values of the seismic wave.
    %   accel  - A numeric array representing the corresponding acceleration values.
    %
    % OUTPUTS:
    %   sw.time - Time vector for the pulse wave.
    %   sw.acc  - Acceleration vector of the pulse wave.
    %   sw.vel  - Velocity vector of the pulse wave.
    %   sw.dis  - Displacement vector of the pulse wave.

    % Remove linear trend
    p = polyfit(time, accel, 1);
    trend = polyval(p, time);
    acc_corr = accel - trend;

    % Denoising using moving average
    window_size = 5;                                % Window size for moving average
    acc_denoised = zeros(size(acc_corr));           % Initialize output array
    for i = 1:length(acc_corr)
        if i < window_size
            acc_denoised(i) = mean(acc_corr(1:i));  % Handle start of array
        elseif i > length(acc_corr) - window_size + 1
            acc_denoised(i) = mean(acc_corr(i:end)); % Handle end of array
        else
            acc_denoised(i) = mean(acc_corr(i-window_size+1:i+window_size-1)); % Handle middle
        end
    end

    % Compute velocity and displacement using numerical integration
    vel = cumtrapz(time, acc_denoised);
    dis = cumtrapz(time, vel);

    sw.time = time;
    sw.acc = acc_denoised;
    sw.vel = vel;
    sw.dis = dis;
    
    % Write the log file to the file
    write_log('read_wave has been executed.');

end % function read_wave