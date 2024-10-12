function plot_contour(mode, filename)
    % plot_contour function for plotting contour plots
    % input:
    %   mode: '2D' or '3D'
    %   filename: name of the data file
    % output:
    %   contour plot
    %
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University


    if isempty(mode)
        mode = '2D';
    end

    switch mode
        case '2d'
            plot_contour2d(filename);
        case '3d'
            plot_contour3d(filename);
    end

end % function plot_contour


function plot_contour2d(filename)
    %% -----------------------------------------------------------------
    %%%
    % 1. The 'plotcontour' function uses 'patch' to display the results of
    %    2D finite element nodes and elements.
    % 2. Usage:
    %    filename='dd25-200.dat';
    %    plotcontour(filename);
    %    The data file follows the Tecplot output format or is directly exported from ANSYS (ansys2tecplot.inp).
    %    The first three lines contain the title, variables, and element/node information.
    %    Node XY coordinates, displacements, and element-node composition follow.
    %    Node numbers and element numbers are sequentially arranged.
    %    Example format:
    %      title="ansys analysis"
    %      variables="x","y","displacement"
    %      zone n= 19481.0, e= 19200.0, f=fepoint, et=quadrilateral
    %  
    %       0.000000    0.000000    0.001416
    %       5.000000    0.000000    0.001161
    %      10.000000    0.000000    0.000909
    %      15.000000    0.000000    0.000706
    %  
    %       1.      3.    561.    560.
    %       3.      4.    680.    561.
    %       4.      5.    799.    680.
    % 
    % Main variables:
    % 'nodes', 'elements': node XY coordinates and displacements matrix;
    % 'x', 'y', 'displacement': node x, y coordinates, displacements;
    % 'nodexyz', 'nodeuvw': nodal coordinates and displacement results for each element;
    % 
    % 'patch' function requires four nodes' coordinates ('nodexyz') and displacements ('nodeuvw'):
    %  patch('Vertices', nodexyz,...
    %         'Faces', faces,...
    %         'FaceVertexCData', nodeuvw,...
    %         'FaceColor', 'interp',...
    %         'EdgeColor', 'none');hold on;

    tic % Start the timer

    %% Read element and node information
    fid = fopen(filename);
    
    % Read title and variables
    title = fgetl(fid); %#ok
    variables = fgetl(fid); %#ok
    node_elem_info = fgetl(fid); %#ok % Node and element information 
    % Skip a blank line
    fgetl(fid); 
    
    % Read node and element data
    nodes = [];
    elements = [];
    while ~feof(fid)
        line = fgetl(fid);
        if isempty(line)  % Break if empty line
            break;
        end
        % Read all numbers in the line using sscanf
        num = sscanf(line, '%f');
        % Ensure 'num' is not empty and is a column vector
        if ~isempty(num) && isnumeric(num) 
            num = num'; % Convert to row vector
            % Check if the line has 3 columns (assumed node data)
            if length(num) == 3
                % Append to 'nodes'
                nodes = [nodes; num]; %#ok
            else
                % Otherwise, append to 'elements'
                elements = [elements; num]; %#ok
            end
        end
    end
    % Close the file
    fclose(fid);
    
    %% Extract node coordinates and displacements
    x = nodes(:, 1);
    y = nodes(:, 2);
    displacement = nodes(:, 3);
    
    %% Plot each element
    hold on;
    for i = 1:size(elements,1)
        % Get the node indices for the current element
        elemidx = elements(i,:);
        
        % Get coordinates of the current element's nodes
        nodexyz = [x(elemidx), y(elemidx)];
        % Get displacements of the current element's nodes
        nodeuvw = displacement(elemidx, :);
        
        % Define the faces (4-node quadrilateral)
        faces = [1, 2, 3, 4];
        % Use 'patch' to plot the element contour
        patch('Vertices', nodexyz,...
              'Faces', faces,...
              'FaceVertexCData', nodeuvw,...
              'FaceColor', 'interp',...
              'EdgeColor', 'none');
    end
    
    % Set the axes and display settings
    axis equal;
    toc % Display elapsed time

end % function plot_contour


function plot_contour3d(filename)
    % 1. The plotcontour function uses patch to display the results of 3D finite element elements and nodes;
    % 2. Usage:
    % filename='ddd-p25-45-1.dat';
    % plotcontour(filename);
    % The data file follows the Tecplot output format or is directly exported from ANSYS (ansys2tecplot.inp).
    % The first three lines contain title, variables, element and node information, 
    % node xyz coordinates, displacements, and element-node composition;
    % Node and element numbers are sequentially arranged.
    % Example format:
    % title="ansys analysis"
    % variables="x","y","z","displacement"
    % zone n= 52111.0, e= 48000.0, f=fepoint, et=brick
    %  
    %     0.000000  150.000000    0.000000    0.000003
    %     0.000000    0.000000    0.000000    0.028500
    %     0.000000  145.000000    0.000000    0.000006
    %     0.000000  140.000000    0.000000    0.000016
    %     0.000000  135.000000    0.000000    0.000035
    %   195.000000  145.000000  185.000000    0.000000
    %   195.000000  145.000000  190.000000    0.000000
    %   195.000000  145.000000  195.000000    0.000000
    %  
    %       2.    102.    141.     31.   2581.   4103.   8003.   5779.
    %     102.    103.    142.    141.   4103.   4104.   9134.   8003.
    %     103.    104.    143.    142.   4104.   4105.  10265.   9134.
    %     104.    105.    144.    143.   4105.   4106.  11396.  10265.
    %     105.    106.    145.    144.   4106.   4107.  12527.  11396.
    
    % Main variables:
    % 'nodes', 'elements': node xyz coordinates and displacements matrix;
    % 'x', 'y', 'z', 'displacement': node x, y, z coordinates, displacements;
    % 'nodexyz', 'nodeuvw': nodal coordinates and displacement results for each element;
    % The 'patch' command requires the eight-node coordinates of the 'nodexyz' face and node displacements ('nodeuvw').
    % patch('Vertices', nodexyz,...
    %         'Faces', faces,...
    %         'FaceVertexCData', nodeuvw,...
    %         'FaceColor', 'interp',...
    %         'EdgeColor', 'none');hold on;


    tic % Start the timer
    
    %% Read element and node information
    % Open file
    fid = fopen(filename);
    
    if fid == -1
        error('Failed to open file');
    end
    
    
    % Read title and variables
    title = fgetl(fid);%#ok
    variables = fgetl(fid);%#ok
    node_elem_info = fgetl(fid); %#ok % Node and element count information
    
    % Skip a blank line
    fgetl(fid); 
    
    %% Read node information
     
end % function plot_contour3d