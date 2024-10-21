%%%%-----------------------------OpenSwim--------------------------------------
%
%       Description:
%       SWIM calculates equivalent nodal loads of seismic waves 
%       obliquely incident for geotechnical engineering earthquake resistance.
%       It includes common impulses, natural waves, and artificial P, SV, and SH wave components. 
%       Input data from node_inf.dat contains node numbers, 
%       xy coordinates, and influence areas, named left, right, and bottom.
%       The output file consists of three boundary equivalent nodal loads.
%       P-wave and SV-wave differ in four aspects:
%       - Reflection coefficient (para)
%       - Transformation matrix (transfer)
%       - Delay time (lagtime)
%       - Stress matrix (temp33)
%
%   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
%   Author(s): Hubery H.B. Woo (hbw8456@163.com)
%   Copyright 2023-2024 Chongqing Three Gorges University


%--------------------------------------------------------------------------
%             L O A D   P A T H   A N D   C L E A R   V A R I A B L E S 
%--------------------------------------------------------------------------
% Get the current directory path
addpath(genpath(pwd),'-begin'); 

clear; close; 

% Define the global parameters
global wavemode alpha; %#ok
wavemode = 'svwave'; % seiswave type (pwave or svwave)
alpha = 20 * pi / 180;  % Angle of seismic wave incidence

%--------------------------------------------------------------------------
%             L O A D   E A R T H Q U A K E   W A V E   D A T A 
%--------------------------------------------------------------------------
dtime = 0.02;  % Time step
tt = 2;        % Total time
t = 0.2;       % Pulse duration
sw = seis_wave('gen', dtime, t, tt); 
% Uncomment to import earthquake acceleration data
% sw = seis_wave('read', 'elcentro.txt');

%--------------------------------------------------------------------------
%             O U T P U T   E A R T H Q U A K E   W A V E   D A T A 
%--------------------------------------------------------------------------
% Output matrix of earthquake waves
filename = 'seiswave.dat';
outmatrix = sw.time;
outmatrix = [outmatrix, sw.acc];
output_matrix(outmatrix, filename);

% Define output files and variables for nodal forces
nleft = 'nleft.dat';
nright = 'nright.dat';
nbottom = 'nbottom.dat';


%--------------------------------------------------------------------------
%             I N I T I A L I Z E   S P R I N G   M A T R I C E S 
%--------------------------------------------------------------------------
% Initialize spring and damping matrices
% node_spring = zeros(2, 2);
% node_damp = zeros(2, 2);
uucs = zeros(length(sw.time), 2); % Displacement, velocity, stress (time)
vvcs = zeros(length(sw.time), 2);
sscs = zeros(length(sw.time), 2);
nleftforce = []; 
nrightforce = []; 
nbottomforce = [];

%--------------------------------------------------------------------------
%             L O A D   A N S Y S   M O D E L 
%--------------------------------------------------------------------------
% clear the ANSYS files before running the model
filepath = fullfile(pwd, 'temp');
clear_log(filepath);

% Run the ANSYS model.inp file to generate the model parameters
filepath = fullfile(pwd, 'test', 'model.inp');
call_ansys(filepath);


%--------------------------------------------------------------------------
%             M A T E R I A L   P A R A   A N D   T R A N S   M A T R I X 
%--------------------------------------------------------------------------
% Define physical model and material parameters
para = model_para();

% Define transformation matrix for different incident waves
matrix = transfer_matrix(para);


%--------------------------------------------------------------------------
%             C A L C U L A T E   N O D A L   F O R C E S 
%--------------------------------------------------------------------------
%% Loop through boundary faces and calculate nodal displacements, velocities, and stresses
for info = 1:3
    filename = sprintf('nodeinf%d.dat', info);

    try
        % try to load the nodes informations from file
        node_info = load(filename);
    catch exception
        % if the file is not found, display an error message
        disp(exception.message);
        ansys_error();
        write_log('nodeinf.dat has not been found.');
        return;
    end

    % Extract node data
    node_num = node_info(:, 1);
    node_x = node_info(:, 2);
    node_y = node_info(:, 3);
    node_area = node_info(:, 4);

    % Loop through each node
    for i = 1:length(node_num)
        x = node_x(i);
        y = node_y(i);
        
        % Calculate time lag
        lag = calc_lagtime(para, x, y); 

        % Calculate spring and damping matrices
        [node_spring, node_damp] = calc_spring(para, info);

        % Time loop for calculating forces
        for j = 1:length(sw.time)
            time = sw.time(j);

            % Calculate local coordinates
            laguv = calc_laguv(para, lag, time, sw, info);

            % Compute global coordinates based on local displacements
            [uu, vv, sigma1, sigma2] = calc_glouv(para, matrix,laguv, info);
            
            uucs(j, :) = uu;
            vvcs(j, :) = vv;
            sscs(j, 1) = sigma1;
            sscs(j, 2) = sigma2;

            % Define force matrix based on boundary information
            switch info
                case 1
                    nnleft(:, 1) = repmat(node_num(i), size(sw.time,1), 1);
                    nnleft(:, 2:3) = (node_area(i) * (node_spring * uucs' + node_damp * vvcs' + sscs'))';
                case 2
                    nnright(:, 1) = repmat(node_num(i), size(sw.time,1), 1);
                    nnright(:, 2:3) = (node_area(i) * (node_spring * uucs' + node_damp * vvcs' + sscs'))';
                case 3
                    nnbottom(:, 1) = repmat(node_num(i), size(sw.time,1), 1);
                    nnbottom(:, 2:3) = (node_area(i) * (node_spring * uucs' + node_damp * vvcs' + sscs'))';
            end
        end % endloop through time

        % Collect forces for output
        switch info
            case 1
                nleftforce = [nleftforce; nnleft]; %#ok
            case 2
                nrightforce = [nrightforce; nnright]; %#ok
            case 3
                nbottomforce = [nbottomforce; nnbottom]; %#ok
        end
    end % endloop through nodes
end % endloop through boundary faces


%--------------------------------------------------------------------------
%             O U T P U T   N O D A L   F O R C E S 
%--------------------------------------------------------------------------
% Output forces to respective files
output_matrix(nleftforce, nleft);
output_matrix(nrightforce, nright);
output_matrix(nbottomforce, nbottom);

% Run the ANSYS solve.inp file to generate the model parameters
filepath = fullfile(pwd, 'test', 'solve.inp');
call_ansys(filepath);

% check the ansys running status
workingDir = fullfile(pwd, 'temp');
monitor_ansys(workingDir);
% Write a message to the file
write_log('The solve.inp has been executed......openSwim.');


%--------------------------------------------------------------------------
%             P O S T P R O C E S S I N G   A N S Y S   M O D E L 
%--------------------------------------------------------------------------
% Run the ANSYS post.inp file to generate the model parameters
filepath = fullfile(pwd, 'test', 'post.inp');
call_ansys(filepath);
monitor_ansys(workingDir);

% Write a message to the file
write_log('The post.inp has been executed......openSwim.');

%--------------------------------------------------------------------------
%             E N D   O F   P R O G R A M 
%--------------------------------------------------------------------------