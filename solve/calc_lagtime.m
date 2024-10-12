function lag = calc_lagtime(para, node_x, node_y)
    % calc_lagtime calculates the lag times for different wave modes at specified node coordinates.
    %
    % Inputs:
    % - wavemode: An integer indicating the wave mode:
    %   - pwave for P-wave
    %   - svwave for SV-wave
    % - para: A structure containing parameters such as alpha, beta, cp, cs, size_x, and size_y
    % - node_x: The x-coordinate of the node
    % - node_y: The y-coordinate of the node
    %
    % Outputs:
    % - lag: A structure containing lag times for different wave paths
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University

    global wavemode; %#ok
    
    % Extract parameters from the input structure
    alpha = para.alpha;
    beta = para.beta;
    cp = para.cp;
    cs = para.cs;
    size_x = para.size_x;
    size_y = para.size_y;
    
    % % Initialize the output lag structure
    % lag = struct('time1', 0, 'time2', 0, 'time3', 0, 'time4', 0, 'time5', 0, 'time6', 0, 'time7', 0, 'time8', 0, 'time9', 0);
    
    % Calculate lag times based on the wave mode
    switch lower(wavemode)
        case 'pwave'
            % P-wave lag times
            lag.time1 = node_y * cos(alpha) / cp;
            lag.time2 = (2 * size_y - node_y) * cos(alpha) / cp;
            lag.time3 = (size_y - node_y) / cs / cos(beta) + (size_y - (size_y - node_y) * tan(alpha) * tan(beta)) * cos(alpha) / cp;
            lag.time4 = node_y * cos(alpha) / cp + size_x * sin(alpha) / cp;
            lag.time5 = (2 * size_y - node_y) * cos(alpha) / cp + size_x * sin(alpha) / cp;
            lag.time6 = (size_y - node_y) / cs / cos(beta) + (size_y - (size_y - node_y) * tan(beta) * tan(alpha)) * cos(alpha) / cp + size_x * sin(alpha) / cp;
            lag.time7 = node_x * sin(alpha) / cp;
            lag.time8 = (2 * size_y + node_x * tan(alpha)) * cos(alpha) / cp;
            lag.time9 = size_y / cs / cos(beta) + (size_y * cos(alpha) + node_x * sin(alpha) - size_y * tan(beta) * sin(alpha)) / cp;
        case 'svwave'
            % SV-wave lag times
            lag.time1 = node_y * cos(alpha) / cs;
            lag.time2 = (2 * size_y - node_y) * cos(alpha) / cs;
            lag.time3 = (size_y - node_y) / cp / cos(beta) + (size_y - (size_y - node_y) * tan(alpha) * tan(beta)) * cos(alpha) / cs;
            lag.time4 = node_y * cos(alpha) / cs + size_x * sin(alpha) / cs;
            lag.time5 = (2 * size_y - node_y) * cos(alpha) / cs + size_x * sin(alpha) / cs;
            lag.time6 = (size_y - node_y) / cp / cos(beta) + (size_y - (size_y - node_y) * tan(beta) * tan(alpha)) * cos(alpha) / cp + size_x * sin(alpha) / cs;
            lag.time7 = node_x * sin(alpha) / cs;
            lag.time8 = (2 * size_y + node_x * tan(alpha)) * cos(alpha) / cs;
            lag.time9 = size_y / cp / cos(beta) + (size_y * cos(alpha) + node_x * sin(alpha) - size_y * tan(beta) * sin(alpha)) / cs;
        otherwise
            error('Invalid wavemode. wavemode must be P wave or SV wave.');
    end

end % function calc_lagtime
