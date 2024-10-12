function call_ansys(inputFile, ansysPath, workingDir)
    % call_ansys - A function to set up and run an ANSYS simulation.
    %
    % Syntax:
    %   call_ansys(inputFile, ansysPath, workingDir)
    %
    % Description:
    %   This function initializes the parameters for an ANSYS simulation based on 
    %   the provided input file. It sets the necessary paths and prepares the 
    %   working directory for running the simulation.
    %
    % Inputs:
    %   inputFile  - (string) The path to the input file containing simulation parameters.
    %   ansysPath   - (string) The directory path where the ANSYS software is installed.
    %   workingDir  - (string) The directory path where the simulation results will be saved.
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and Simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University


    % Define the ANSYS executable, input file, and working directory
    if nargin < 1 || isempty(inputFile)
        % Prompt the user to select an input file
        choice = input('Please choose one of the following options: [model], load, post: ', 's');

        % Default filename
        defaultFiles = {
            fullfile(pwd, 'test/', 'model.inp');
            fullfile(pwd, 'test/', 'solve.inp');
            fullfile(pwd, 'test/', 'post.inp')};

        % Set the input file based on user choice
        switch lower(choice)
            case 'solve'
            inputFile = defaultFiles{2}; % Load input file
            case 'post'
            inputFile = defaultFiles{3}; % Post-processing input file
            otherwise
            inputFile = defaultFiles{1}; % Default to model.inp
        end
    end

    % Display the selected input file name
    disp(['Using input file: ', inputFile]);

    if nargin < 2 || isempty(ansysPath)
        % find the ANSYS installation path
        ansysPath = find_ansys();
    end

    if nargin < 3 || isempty(workingDir)
        workingDir = fullfile(pwd, 'temp');
    end

    % Create the command to run ANSYS in batch mode without GUI
    command = sprintf('cd "%s" && "%s" -b -np 1 -smp -i "%s" -o output.txt', workingDir, ansysPath, inputFile);

    % Execute the command
    system(command);
    
    % Monitoring the ANSYS running status
    monitor_ansys(workingDir);

end % function run_model


function ansysPath = find_ansys()
    % find_ansys - A helper function to automatically search for ANSYS installation.
    %
    % Outputs:
    %   ansysPath - (string) The path to the found ANSYS executable or an empty string if not found.

    ansysPath = 'C:\Program Files\ANSYS Inc\v192\ANSYS\bin\winx64\ANSYS192.exe';
    fprintf('find_ansys has been executed: %s\n', ansysPath);

end % function find_ansys