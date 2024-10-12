function write_log(message)
    % write_log - Writes a message to the log file and displays it in the MATLAB console.
    %
    % Usage:
    %   write_log(message)
    %
    % Input Parameters:
    %   message - A string containing the message to be logged.
    %
    % Description:
    %   This function appends the provided message to the 'log.dat' file and
    %   also displays the message in the MATLAB console using the fprintf function.
    %   It is useful for logging messages during script execution for debugging or
    %   record-keeping purposes.
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University

    
    % Open the log file in append mode
    workingDir = fullfile(pwd, 'temp', 'log.dat');
    fileID = fopen(workingDir, 'a');
    
    % Check if the file was opened successfully
    if fileID == -1
        error('Failed to open the log file.');
    end
    
    % Write the message to the log file
    fprintf(fileID, '%s\n', message);
    fprintf(fileID, '%s\n', datetime('now'));

    
    % Close the file
    fclose(fileID);
    
    % Display the message in the MATLAB console
    fprintf('%s\n', message);
    fprintf('%s\n', datetime('now'));

end % function write_log