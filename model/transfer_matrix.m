function matrix = transfer_matrix(para)
    % transfer_matrix computes the transformation matrices for different wave modes.
    %
    % Inputs:
    % - wavemode: An integer indicating the wave mode:
    %   - pwave for P-wave
    %   - svwave for SV-wave
    %   - shwave for SH-wave
    % - para: A structure containing global variables alpha and beta
    %
    % Outputs:
    % - matrix: A structure containing transformation matrices for incident and reflected waves
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2009-2024 Chongqing Three Gorges University

    
    global wavemode; %#ok

    % Extract alpha and beta from the input parameters
    alpha = para.alpha;
    beta = para.beta;
    
    % Initialize the output matrix structure
    matrix = struct('t1', zeros(2,2), 't2', zeros(2,2), 't3', zeros(2,2));
    
    % Define transformation matrices based on the wave mode
    switch lower(wavemode)
        case 'pwave' % P-wave
            % Incident P-wave transformation matrix
            matrix.t1(1,1) = sin(alpha);
            matrix.t1(1,2) = cos(alpha);
            matrix.t1(2,1) = -cos(alpha);
            matrix.t1(2,2) = sin(alpha);
            
            % Reflected P-wave transformation matrix
            matrix.t2(1,1) = sin(alpha);
            matrix.t2(1,2) = -cos(alpha);
            matrix.t2(2,1) = cos(alpha);
            matrix.t2(2,2) = sin(alpha);
            
            % Reflected SV-wave transformation matrix
            matrix.t3(1,1) = sin(beta);
            matrix.t3(1,2) = -cos(beta);
            matrix.t3(2,1) = cos(beta);
            matrix.t3(2,2) = sin(beta);
            
        case 'svwave' % SV-wave
            % Incident SV-wave transformation matrix
            matrix.t1(1,1) = cos(alpha);
            matrix.t1(1,2) = -sin(alpha);
            matrix.t1(2,1) = sin(alpha);
            matrix.t1(2,2) = cos(alpha);
            
            % Reflected SV-wave transformation matrix
            matrix.t2(1,1) = -cos(alpha);
            matrix.t2(1,2) = -sin(alpha);
            matrix.t2(2,1) = sin(alpha);
            matrix.t2(2,2) = -cos(alpha);
            
            % Reflected P-wave transformation matrix
            matrix.t3(1,1) = -cos(beta);
            matrix.t3(1,2) = -sin(beta);
            matrix.t3(2,1) = sin(beta);
            matrix.t3(2,2) = -cos(beta);
            
        case 'shwave' % SH-wave
            disp('Transformation matrix for SH wave is not yet implemented.');
            
        otherwise
            disp('wavemode must be P wave, SV wave, or SH wave.');
    end
    
end % function transfer_matrix