function ansys_error(errFilePath)
    % read_ansys_error - Read the ANSYS .err file and output any error messages.
    %
    % Usage:
    %   read_ansys_error(errFilePath)
    %
    % Input Parameters:
    %   errFilePath - Full path to the ANSYS .err file.
    %
    % Description:
    %   This function reads the provided ANSYS .err file from the specified
    %   location, searches for any lines that contain the keyword 'ERROR', and
    %   prints the associated error messages to the MATLAB console.
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University

    
    % Check if the input argument is provided and not empty
    if nargin < 1 || isempty(errFilePath)
        write_log('ansys_error has been not found......openSwim.');
        return;
    end

    % Open the .err file in read mode
    fileID = fopen(errFilePath, 'r');
    
    % Check if the file was opened successfully
    if fileID == -1
        error('Failed to open the .err file. Check if the file path is correct.');
    end
    
    % Initialize a flag to track whether errors were found
    errorFound = false;
    
    % Read the file line by line
    while ~feof(fileID)
        % Get a line from the file
        currentLine = fgets(fileID);
        
        % Check if the line contains the word 'ERROR'
        if contains(currentLine, 'ERROR')
            % If this is the first error found, display a message
            if ~errorFound
                disp('Errors found in the ANSYS .err file:');
                errorFound = true;
            end
            
            % Print the error message to the console
            disp(currentLine);  % Display the error line
        end
    end
    
    % Close the file after reading
    fclose(fileID);
    
    % If no errors were found, notify the user
    if ~errorFound
        disp('No errors found in the ANSYS .err file.');
    end
end % function ansys_error