function ss=plot_stress(data,scalings)
    %% Function Name: plot_stress
    % Function Purpose: This code plots the stress distribution of a tunnel structure.
    % The function takes the input of element numbers, nodes, and stress distribution; 
    % node numbers, node coordinates, and calculates the stress envelopes and reference stress grids.
    % Input Parameters:
    %    nodes: Node number, node x and y coordinates, and stress values; data(:,1-4)
    %    scalings: Scaling factor for the stress envelope;
    % Output Parameters:
    %    nodex, nodey: xy coordinates of the tunnel outline
    %    ref_stressx1-2, ref_stressy1-2: xy coordinates of the reference stress envelope
    %    stressx, stressy: xy coordinates of the moment envelope
    
    %% Instructions:
    % ps=1; angles=1;
    % filename = sprintf('c:\\users\\administrator\\documents\\ansys\\papers\\chuzhi-%d-%d-1.dat',ps,angles);
    % data=load(filename);
    % ss=plotstress(data,scalings);
    % plot(ss.nodex, ss.nodey, 'k', 'linewidth', 2); hold on; % Draw tunnel outline, thicker
    % plot(ss.ref_stressx1, ss.ref_stressy1,'linewidth', 1, 'linestyle', '-.','color',[0 0 0]);
    % plot(ss.ref_stressx2, ss.ref_stressy2,'linewidth', 1, 'linestyle', '-.','color',[0 0 0]);
    % plot(ss.stressx,ss.stressy, '--', 'linewidth', 1, 'linestyle', linestyles{times},...
    %             'color',colors(times, :),'marker', markers{times}, 'markerfacecolor', colors(times,:), 'markersize', markersizes);

    %   OpenSwim: An Open Source Library for Seismic Wave Input and Simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2009-2024 Chongqing Three Gorges University

    %% Create the element composition matrix, consisting of element nodes and stress values
    % Node numbers, coordinates, and stresses are stored in respective variables
    nodes=data(:,1); %#ok % Node number
    x=data(:,2);     % x coordinate
    y=data(:,3);     % y coordinate
    stress=data(:,4);% Stress value
    
    % Assuming x, y, and stress are defined and of the same length
    x = [x; x(1); x(2)]; % Add the first point at the end to close the curve
    y = [y; y(1); y(2)]; % Add the first point at the end to close the curve
    stress1 = [stress(2:end); stress(1); stress(2); stress(3)]; % Adjust for symmetry, nodes i and j, normal vectors in the middle
    stress2 = [stress; stress(1); stress(2)];                   % Adjust for symmetry, nodes i and j, normal vectors in the middle
    stress = (stress1 + stress2) / 2;
    
    % Initialize variables needed for envelope plotting
    stressx = []; ref_stressx1 = []; ref_stressx2 = [];
    stressy = []; ref_stressy1 = []; ref_stressy2 = [];
    
    % Calculate normal vectors and plot the envelope
    for i = 1:(length(x)-1) % Subtract 1 because we added a duplicate point to close the curve
        % Compute vector between consecutive points
        vec = [x(i+1)-x(i), y(i+1)-y(i)];
        % Compute the normal vector (perpendicular to vec, length 1)
        normal_vec = [-vec(2), vec(1)];
        normal_length = sqrt(sum(normal_vec.^2));
        normal_vec = normal_vec / normal_length;
        
        % Calculate midpoint (normal vector is centered, but values are at nodes i and j)
        mid_point = [(x(i)+x(i+1))/2, (y(i)+y(i+1))/2];
        
        % Store envelope coordinates for further processing or plotting
        stressx = [stressx, mid_point(1) + normal_vec(1)*stress(i)/scalings]; %#ok
        stressy = [stressy, mid_point(2) + normal_vec(2)*stress(i)/scalings]; %#ok
        ref_stressx1 = [ref_stressx1, mid_point(1) + normal_vec(1)]; %#ok
        ref_stressy1 = [ref_stressy1, mid_point(2) + normal_vec(2)]; %#ok
        ref_stressx2 = [ref_stressx2, mid_point(1) - normal_vec(1)]; %#ok
        ref_stressy2 = [ref_stressy2, mid_point(2) - normal_vec(2)]; %#ok
        
        %% Create a structure to store all features
        ss.nodex = x;
        ss.nodey = y;
        ss.stressx = stressx;
        ss.stressy = stressy;
        ss.ref_stressx1 = ref_stressx1;
        ss.ref_stressy1 = ref_stressy1;
        ss.ref_stressx2 = ref_stressx2;
        ss.ref_stressy2 = ref_stressy2;
    end  
    
end % function plot_stress