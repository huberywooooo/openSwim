function clear_log(workingDir)
    % clear_log - A helper function to check if a directory exists and delete all files in it.
    %
    % Inputs:
    %   directory - A string specifying the path to the directory to be checked.
    %
    % Description:
    %   This function checks whether the specified directory exists, and if it does, 
    %   it deletes all files within the directory.
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and Simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University


    % Check if the directory exists
    if exist(workingDir, 'dir') ~= 7
        % Directory does not exist, create it
        mkdir(workingDir);
        disp(['Directory ' workingDir ' has been created.']);
    else
        % Directory exists, list all files in the directory
        files = dir(fullfile(workingDir, '*.*'));
        
        % Loop through each file in the directory
        for i = 1:length(files)
            % Skip if it's a directory (since we only want to delete files)
            if ~files(i).isdir
                % Build the full path to the file
                filePath = fullfile(workingDir, files(i).name);
                % Delete the file
                delete(filePath);
            end
        end
        
        write_log('clear_log has been executed......openSwim.');
    end

end % function clear_log