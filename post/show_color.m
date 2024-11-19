function show_color(colors)
    % This function displays a color palette using a bar chart.
    %
    % Usage:
    %   show_color(colors)
    %
    % Parameters:
    %   colors: An array of colors in the form of an n x 3 matrix representing RGB values.
    %
    % Example:
    %   colors = [1 0 0; 0 1 0; 0 0 1];  % Red, Green, Blue
    %   show_color(colors);
    %
    %   OpenSwim: An Open Source Library for Seismic Wave Input and simulation Methods
    %   Author(s): Hubery H.B. Woo (hbw8456@163.com)
    %   Copyright 2009-2024 Chongqing Three Gorges University

    % Check the validity of the input color array
    if isempty(colors) || size(colors, 2) ~= 3
        error('Input color array must be an n x 3 matrix representing RGB colors');
    end

    % Get the number of colors
    numColors = size(colors, 1);

    % Create a new figure window
    figure;
    hold on;

    % Display each color as a rectangle in the bar chart
    for i = 1:numColors
        % Create a rectangular patch to represent the color
        patch([i-1 i-1 i i], [0 1 1 0], colors(i, :), 'EdgeColor', 'none');
    end

    % Set axis properties
    xlim([0 numColors]);
    ylim([0 1]);
    set(gca, 'YTick', [], 'XTick', []);  % Remove axis ticks
    title('Color Palette');
    
    hold off;
    
end % function show_color