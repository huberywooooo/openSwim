function [p, e, t] = import_msh(filename)
    % import_msh reads the .msh file and plots the mesh using pdemesh.
    % It returns the node coordinates (p), edge segments (e), and triangles (t).

    % Open the file and read its contents
    fid = fopen(filename, 'rt');
    if fid == -1
        error('Unable to open file %s', filename);
    end
    
    % Read all lines into a cell array
    fileContent = textscan(fid, '%s', 'Delimiter', '\n');
    fclose(fid);
    
    % Skip the header lines
    headerLines = fileContent{1:8};  %#ok % Assuming the first 8 lines are header
    nodesStartLine = 9;              % Nodes start from line 9
    
    % Find the number of nodes and read them
    numNodes = str2double(fileContent{nodesStartLine});
    nodesData = fileContent{nodesStartLine+1:nodesStartLine+numNodes};
    
    % Parse the node data
    nodes = cellfun(@(x) str2double(x(2:end)), nodesData, 'UniformOutput', false);
    nodes = cell2mat(nodes); % Convert to matrix form
    p = nodes(:, 2:3); % Extract x and y coordinates
    
    % Find the number of elements and read them
    elementsStartLine = nodesStartLine + numNodes + 1;
    numElements = str2double(fileContent{elementsStartLine});
    elementsData = fileContent{elementsStartLine+1:elementsStartLine+numElements};
    
    % Parse the element data
    elements = cellfun(@(x) str2double(x(2:end)), elementsData, 'UniformOutput', false);
    elements = cell2mat(elements); % Convert to matrix form
    
    % Extract the triangle information for plotting
    t = elements(:, 2:4); % Assuming elements are stored as [elementID node1 node2 node3 ...]
    
    % Find the number of edges and read them
    edgesStartLine = elementsStartLine + numElements + 1;
    numEdges = str2double(fileContent{edgesStartLine});
    edgesData = fileContent{edgesStartLine+1:edgesStartLine+numEdges};
    
    % Parse the edge data
    edges = cellfun(@(x) str2double(x(2:end)), edgesData, 'UniformOutput', false);
    edges = cell2mat(edges); % Convert to matrix form
    
    % Extract the edge information for plotting
    e = edges(:, 2:3); % Assuming edges are stored as [edgeID node1 node2 ...]
    
    % Plot the mesh
    pdemesh(p(:, 1), p(:, 2), e, t);
    
    % Return the parsed data
    return;

end % function import_msh