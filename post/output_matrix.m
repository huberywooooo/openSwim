function output_matrix(matrix,filename)
    % output_matrix: write a matrix to a specified file.
    %
    % Syntax:
    %   output_matrix(matrix, filename)
    %
    % Inputs:
    %   matrix   - A 2D array containing the data to be written to file.
    %   filename - A string specifying the path and name of the output file.
    %
    % Description:
    %   This function writes the contents of the input matrix to a file, 
    %   formatting each element with specific precision. The last element 
    %   of each row is printed with a newline, while other elements are 
    %   separated by a tab.
    %
    % Example:
    %   output_matrix(myMatrix, 'outputmatrix.dat')
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University
    

    % Check if the input matrix is a 2D array
    if ~ismatrix(matrix)
        error('Input matrix must be a 2D array.');
    end

    % Check if the filename is empty
    if nargin < 2 || isempty(filename)
        filename = 'outputmatrix.dat';
    end

    % Open the file for writing
    filepath = fullfile(pwd(), 'temp', filename);
    fileID = fopen(filepath, 'w');  
    [m, n] = size(matrix);           % Get the size of the matrix

    % Loop through each row of the matrix
    for i = 1:m
        % Loop through each column of the matrix
        for j = 1:n
            % If it's the last column, print a new line after the value
            if j == n
                fprintf(fileID, '%15.2f \n', matrix(i, j));
            else
                % Otherwise, print the value followed by a tab
                fprintf(fileID, '%15.2f\t', matrix(i, j));
            end
        end
    end
    fclose(fileID);

end  % function output_matrix