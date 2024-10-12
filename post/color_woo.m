function cmap = color_woo(varargin)
    % color_woo - Custom colormap generation function
    %
    % Usage:
    % cmap = color_woo();
    % cmap = color_woo(N);
    % cmap = color_woo(N, options);
    %
    % Description:
    % Generates a custom colormap for visualization purposes.
    %
    % Inputs:
    % - N (optional): Number of colors in the colormap. Default is 256.
    % - options (optional): Additional options for colormap generation.
    %
    % Outputs:
    % - cmap: A colormap matrix suitable for use with MATLAB's colormap function.
    %
    % Examples:
    % cmap = color_woo(); % Generate a default colormap with 256 colors
    % cmap = color_woo(128); % Generate a colormap with 128 colors
    % cmap = color_woo(256, 'option'); % Generate a colormap with 256 colors and additional options
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2023-2024 Chongqing Three Gorges University
    

    %% Parse input arguments
    options = struct();
    if nargin == 1
        if isnumeric(varargin{1})
            N = varargin{1};
        else
            options = varargin{1};
            N = 256; % Default number of colors
        end
    elseif nargin == 2
        N = varargin{1};
        options = varargin{2};
    else
        error('Invalid number of input arguments.');
    end
    
    %% Generate the custom colormap
    % Example: Generate a colormap using a predefined scheme
    % You can replace this with your own logic for generating the colormap
    % For demonstration purposes, we'll use a simple linear interpolation
    if isfield(options, 'scheme')
        switch options.scheme
            case 'linear'
                cmap = parula(N); % Using parula colormap as an example
            case 'custom'
                % Custom colormap generation logic
                % Example: Generate a custom colormap with linear interpolation
                cmap = [linspace(0, 1, N); linspace(0, 1, N); linspace(0, 1, N)]';
            otherwise
                error('Unknown colormap scheme specified.');
        end
    else
        cmap = parula(N); % Default colormap
    end
    
    %% Return the colormap
    if ~ismatrix(cmap) || size(cmap, 2) ~= 3
        error('Colormap must be a matrix with three columns.');
    end

end % function color_woo