function [node_spring, node_damp] = calc_spring(para, info)
    % calc_spring calculates the spring constants and damping coefficients for a node
    % on a specific face of a structure based on given parameters.
    %
    % Usage:
    % [node_spring, node_damp] = calc_spring(para, info)
    %
    % Inputs:
    %   - para: A structure with fields:
    %   - k_n1: Normal spring stiffness coefficient
    %   - k_t1: Tangential spring stiffness coefficient
    %   - c_n: Normal damping coefficient
    %   - c_t: Tangential damping coefficient
    %   - size_x: The size of the structure in the x-direction
    %   - size_y: The size of the structure in the y-direction
    %   - info: An integer indicating the face of the structure:
    %   - left for the left face
    %   - right for the right face
    %   - bottom for the bottom face
    %
    % Outputs:
    % - node_spring: A 2x2 matrix containing the spring constants for the node
    % - node_damp: A 2x2 matrix containing the damping coefficients for the node
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University
    

    switch info
        case 1 % Left face
            node_spring(1, 1) = para.k_n1 / para.size_x;
            node_spring(2, 2) = para.k_t1 / para.size_x;
            node_damp(1, 1) = para.c_n;
            node_damp(2, 2) = para.c_t;
            
        case 2 % Right face
            node_spring(1, 1) = para.k_n1 / para.size_x;
            node_spring(2, 2) = para.k_t1 / para.size_x;
            node_damp(1, 1) = para.c_n;
            node_damp(2, 2) = para.c_t;
            
        case 3 % Bottom face
            node_spring(1, 1) = para.k_t1 / para.size_y;
            node_spring(2, 2) = para.k_n1 / para.size_y;
            node_damp(1, 1) = para.c_t;
            node_damp(2, 2) = para.c_n;
        otherwise
            error('Invalid info. info must be 1 for left, 2 for right, or 3 for bottom face.');
    end

end % function calc_spring