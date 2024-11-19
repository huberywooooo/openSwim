function ss = plot_moment(data, scalings)
    %% Function Name: plot_moment
    % Purpose: This function plots the moment distribution for tunnel structures.
    % It takes element and node data as input, including moment distribution and node coordinates,
    % and plots the tunnel contour, reference moment envelope, and moment distribution.
    %
    % Input Parameters:
    %    elems: Element IDs, node IDs (i and j) and moment data (data(:,1-5))
    %    nodes: Node IDs, x and y coordinates (data(:,6-8))
    %    scalings: Scaling factor for the moment envelope
    %
    % Output Structure:
    %    nodex, nodey: Tunnel contour xy-coordinates
    %    ref_momentx1, ref_momenty1: Reference moment envelope 1 xy-coordinates
    %    ref_momentx2, ref_momenty2: Reference moment envelope 2 xy-coordinates
    %    momentx, momenty: Moment envelope xy-coordinates
    %
    % Example usage:
    %    ps = 1; angles = 1;
    %    filename = sprintf('c:\\users\\administrator\\documents\\ansys\\papers\\chuzhi-%d-%d-1.dat', ps, angles);
    %    data = load(filename);
    %    ss = plot_moment(data, scalings);
    %    plot(ss.nodex, ss.nodey, 'k', 'LineWidth', 2); hold on;
    %    plot(ss.ref_momentx1, ss.ref_momenty1, 'LineWidth', 1, 'LineStyle', '-.', 'Color', [0 0 0]);
    %    plot(ss.ref_momentx2, ss.ref_momenty2, 'LineWidth', 1, 'LineStyle', '-.', 'Color', [0 0 0]);
    %    plot(ss.momentx, ss.momenty, '--', 'LineWidth', 1, 'Color', colors(times, :));
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2009-2024 Chongqing Three Gorges University

    %% Initialize element matrix (element IDs, node i and j IDs, and moment values)
    elements(:,1) = data(:,1); elements(:,2) = data(:,2); elements(:,3) = data(:,3);
    elements_i(:,1) = data(:,2); elements_i(:,2) = data(:,4);
    elements_j(:,1) = data(:,3); elements_j(:,2) = data(:,5);
    
    %% Initialize node matrix (node ID, x coordinate, y coordinate)
    nodes(:,1) = data(:,6); nodes(:,2) = data(:,7); nodes(:,3) = data(:,8);
    
    %% Reorder node numbers based on element node sequence
    % Find the positions of node IDs in the elements matrix
    [~, idx] = ismember(elements_i(:,1), nodes(:,1));
    nd_i = nodes(idx, :);
    
    [~, idx] = ismember(elements_j(:,1), nodes(:,1));
    nd_j = nodes(idx, :);
    
    %% Initialize variables for envelope plotting
    nodexy = zeros(size(elements, 1), 4);
    moment = zeros(size(elements, 1), 4);
    ref_moment1 = zeros(size(elements, 1), 4);
    ref_moment2 = zeros(size(elements, 1), 4);
    
    %% Loop through each element to calculate normal vectors and plot the moment envelope
    for i = 1:size(elements, 1)
        % Calculate vector from node i to node j
        vec = [nd_j(i,2)-nd_i(i,2), nd_j(i,3)-nd_i(i,3)];
        
        % Compute normal vector (perpendicular to vec with length 1)
        normal_vec = [-vec(2), vec(1)];
        normal_length = sqrt(sum(normal_vec.^2));
        
        if normal_length ~= 0
            normal_vec = normal_vec / normal_length; % Normalize the vector
        end
        
        %% Calculate the scaled envelope lengths based on the moment
        % Calculate arrow endpoint for node i
        end_x_i = nd_i(i,2) + normal_vec(1) * elements_i(i,2) / scalings;
        end_y_i = nd_i(i,3) + normal_vec(2) * elements_i(i,2) / scalings;
        
        % Calculate arrow endpoint for node j
        end_x_j = nd_j(i,2) + normal_vec(1) * elements_j(i,2) / scalings;
        end_y_j = nd_j(i,3) + normal_vec(2) * elements_j(i,2) / scalings;
        
        % Store the coordinates of the envelope for plotting or further processing
        nodexy(i, :) = [nd_i(i,2), nd_i(i,3), nd_j(i,2), nd_j(i,3)];
        moment(i, :) = [end_x_i, end_y_i, end_x_j, end_y_j];
        ref_moment1(i, :) = [nd_i(i,2) + normal_vec(1), nd_i(i,3) + normal_vec(2), nd_j(i,2) + normal_vec(1), nd_j(i,3) + normal_vec(2)];
        ref_moment2(i, :) = [nd_i(i,2) - normal_vec(1), nd_i(i,3) - normal_vec(2), nd_j(i,2) - normal_vec(1), nd_j(i,3) - normal_vec(2)];
        
        %% Reformat matrices for plotting
        nodex = nodexy(:, [1, 3])'; nodey = nodexy(:, [2, 4])';
        momentx = moment(:, [1, 3])'; momenty = moment(:, [2, 4])';
        ref_momentx1 = ref_moment1(:, [1, 3])'; ref_momenty1 = ref_moment1(:, [2, 4])';
        ref_momentx2 = ref_moment2(:, [1, 3])'; ref_momenty2 = ref_moment2(:, [2, 4])';
    end
    
    %% Store results in a structure for output
    ss.nodex = nodex;
    ss.nodey = nodey;
    ss.momentx = momentx;
    ss.momenty = momenty;
    ss.ref_momentx1 = ref_momentx1;
    ss.ref_momenty1 = ref_momenty1;
    ss.ref_momentx2 = ref_momentx2;
    ss.ref_momenty2 = ref_momenty2;

end
