function uv = calc_laguv(para, lag, time, sw, info)
    % Function to calculate local coordinate system displacements and velocities
    % based on the given parameters and time delays.
    %
    % Inputs:
    %   para: Structure containing amplitude coefficients A1 and A2, and time step dtime.
    %   lag: Structure containing time lags for each component.
    %   time: Current time.
    %   sw: Structure or function handle providing displacement and velocity functions.
    %   info: Integer indicating the surface (1: left, 2: right, 3: bottom).
    %
    % Outputs:
    %   uv: Structure containing the calculated displacements and velocities for each component.
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University


    % Extract parameters
    A1 = para.A1;
    A2 = para.A2;
    dtime = para.dtime;
    
    % Calculate the time indices based on the current time and time lags
    timeIndices = round((time - [lag.time1, lag.time2, lag.time3, ...
                               lag.time4, lag.time5, lag.time6, ...
                               lag.time7, lag.time8, lag.time9]) / dtime);
    
    % Initialize the output structure
    uv = struct('ucs1', 0, 'vcs1', 0, ...
                'ucs2', 0, 'vcs2', 0, ...
                'ucs3', 0, 'vcs3', 0);
    
    % Process based on the info parameter
    switch info
        case 1 % Left surface
            [uv.ucs1, uv.vcs1] = calc_lag(timeIndices(1), sw, 1);
            [uv.ucs2, uv.vcs2] = calc_lag(timeIndices(2), sw, A1);
            [uv.ucs3, uv.vcs3] = calc_lag(timeIndices(3), sw, A2);
        case 2 % Right surface
            [uv.ucs1, uv.vcs1] = calc_lag(timeIndices(4), sw, 1);
            [uv.ucs2, uv.vcs2] = calc_lag(timeIndices(5), sw, A1);
            [uv.ucs3, uv.vcs3] = calc_lag(timeIndices(6), sw, A2);
        case 3 % Bottom surface
            [uv.ucs1, uv.vcs1] = calc_lag(timeIndices(7), sw, 1);
            [uv.ucs2, uv.vcs2] = calc_lag(timeIndices(8), sw, A1);
            [uv.ucs3, uv.vcs3] = calc_lag(timeIndices(9), sw, A2);
    end

end % function calc_laguv


function [dis, vel] = calc_lag(idx, sw, amp)
    %calc_lag Calculate displacement and velocity for a given time index.
    %
    %   [dis, vel] = calc_lag(idx, sw, amp) returns the displacement and
    %   velocity for the given time index IDX, using the wave object SW and
    %   scaling by the amplitude amp.
    %
    %   Inputs:
    %       idx - Time index for which to calculate displacement and velocity.
    %       sw  - Wave object containing displacement and velocity data.
    %       amp - Amplitude scaling factor.
    %
    %   Outputs:
    %       dis - Amplitude-scaled displacement at the given time index.
    %       vel - Amplitude-scaled velocity at the given time index.


    % Check if the index is valid for calculation
    if idx <= 0
        dis = 0;
        vel = 0;
    else
        % Calculate displacement and velocity
        dis = amp * sw.dis(idx);
        vel = amp * sw.vel(idx);
    end

end % function calc_lag