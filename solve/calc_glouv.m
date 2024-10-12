function [uu, vv, sigma1, sigma2] = calc_glouv(para, matrix, laguv, info)
    % Function Description:
    % This function computes the global displacement, velocity, and strain 
    % from local coordinates using the input parameters.
    %
    % Inputs:
    %   para  - structure containing material properties (cp, cs, lambda, shear)
    %   matrix - structure containing transformation matrices (t1, t2, t3)
    %   laguv - structure containing displacement and velocity in local coordinates 
    %           (ucs1, ucs2, ucs3, vcs1, vcs2, vcs3)
    %   info - integer, indicates how to adjust strain components (1, 2, or 3)
    %
    % Outputs:
    %   uu - global displacement vector
    %   vv - global velocity vector
    %   sigma1, sigma2 - global strain components
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and Simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University


    global wavemode; %#ok

    % Extract material properties
    cp = para.cp;
    cs = para.cs;
    lambda = para.lambda;
    shear = para.shear;

    % Extract local displacements and velocities
    ucs1 = laguv.ucs1;
    ucs2 = laguv.ucs2;
    ucs3 = laguv.ucs3;
    vcs1 = laguv.vcs1;
    vcs2 = laguv.vcs2;
    vcs3 = laguv.vcs3;

    % Initialize displacement and velocity vectors (2D)
    temp_u1 = [ucs1; 0];
    temp_u2 = [ucs2; 0];
    temp_u3 = [0; ucs3];
    temp_v1 = [vcs1; 0];
    temp_v2 = [vcs2; 0];
    temp_v3 = [0; vcs3];

    % Initialize strain tensors (2x2 matrices)
    temp_s1 = zeros(2, 2);
    temp_s2 = zeros(2, 2);
    temp_s3 = zeros(2, 2);

    % Set strain tensors based on wave mode (P-wave or SV-wave)
    if strcmp(wavemode, 'pwave')  % P-wave
        temp_s1(1, 1) = -(lambda + 2 * shear) / cp * vcs1;
        temp_s1(2, 2) = -lambda / cp * vcs1;
        temp_s2(1, 1) = -(lambda + 2 * shear) / cp * vcs2;
        temp_s2(2, 2) = -lambda / cp * vcs2;
        temp_s3(1, 2) = -shear / cs * vcs3;
        temp_s3(2, 1) = -shear / cs * vcs3;
    elseif strcmp(wavemode, 'svwave')  % SV-wave
        temp_s1(1, 2) = -shear / cs * vcs1;
        temp_s1(2, 1) = -shear / cs * vcs1;
        temp_s2(1, 2) = -shear / cs * vcs2;
        temp_s2(2, 1) = -shear / cs * vcs2;
        temp_s3(1, 1) = -lambda / cp * vcs3;
        temp_s3(2, 2) = -(lambda + 2 * shear) / cp * vcs3;
    end

    % Compute global displacement, velocity, and strain using transformation matrices
    uu = matrix.t1' * temp_u1 + matrix.t2' * temp_u2 + matrix.t3' * temp_u3;
    vv = matrix.t1' * temp_v1 + matrix.t2' * temp_v2 + matrix.t3' * temp_v3;
    sigma1 = matrix.t1' * temp_s1 * matrix.t1 + ...
             matrix.t2' * temp_s2 * matrix.t2 + ...
             matrix.t3' * temp_s3 * matrix.t3;

    % Adjust strain components based on info parameter
    if info == 1
        sigma11 = sigma1 * [-1; 0];  % Adjust strain components (info=1)
    elseif info == 2
        sigma11 = sigma1 * [1; 0];   % Adjust strain components (info=2)
    elseif info == 3
        sigma11 = sigma1 * [0; -1];  % Adjust strain components (info=3)
    end

    sigma1 = sigma11(1);
    sigma2 = sigma11(2);

end % function calc_glouv