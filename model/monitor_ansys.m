function monitor_ansys(workingDir)
    % monitor_ansys - A helper function to automatically monitor the ANSYS running status.
    %
    % This function continuously checks the size of an output file generated
    % by ANSYS to determine when the simulation has completed. It monitors
    % the specified working directory and stops once the output file's size
    % remains unchanged, indicating that ANSYS has finished writing results.
    %
    % Parameters:
    % workingDir - A string representing the path to the working directory where 
    %              ANSYS output files are being generated.
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University
    
    
    % Monitor the ANSYS output file until its size no longer changes.
    outputFile = fullfile(workingDir, 'output.txt');
    lastSize = -1;
    
    while true
        % Check if the output file exists
        if exist(outputFile, 'file') == 2
            % Get the current file size
            outputFileinfo = dir(outputFile);
            currentSize = outputFileinfo.bytes;
            
            % If the file size has not changed, assume ANSYS has completed
            if currentSize == lastSize
                break;
            else
                lastSize = currentSize;
            end
        end
        
        % Wait for a moment before checking again
        pause(2); % Check every second
    end
    
    % Write a message to the file
    write_log('monitor_ansys has been executed......openSwim.');
    
end % function monitor_ansys