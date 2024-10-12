classdef plot_setting < handle
    %% plot_setting - Class for plot formatting settings
    % This class handles various plotting settings and allows customization
    % for figure, axis, legend, lines, and more.
    %
    % Example usage:
    %   clc; clear;
    %   x = linspace(0, 10, 100)';
    %   y1 = sin(x) + randn(size(x)) * 0.1;
    %   y2 = cos(x) + randn(size(x)) * 0.1;
    %   data = [x, y1, y2];
    %   g = plot_setting();
    %   g.xlim = [0, 10];
    %   g.ylim = [-2, 2];
    %   g.xtick = 0:2:10;
    %   g.ytick = -2:0.8:2;
    %   figure;
    %   g.plotlines(data);
    %   xlabel('x-axis');
    %   ylabel('y-axis');
    %   g.output();
    %
    % Author: Hubery H.B. Woo (hbw8456@163.com)
    % Copyright 2023-2024 Chongqing Three Gorges University
    
    %% Public properties for plot settings
    properties
        % Figure properties
        units = 'centimeters';  % Unit of measurement for figures
        width = 8;              % Figure width
        height = 6;             % Figure height
        title = '(a) multi-lines plot'; % Figure title
        titlefontsize = 12;      % Title font size
        titlepos = [4, -3, 0];   % Title position
        
        % Axis properties
        xlabel = 'xaxis';        % X-axis label
        ylabel = 'yaxis';        % Y-axis label
        xlim = [-10, 10];        % X-axis limit
        ylim = [-10, 10];        % Y-axis limit
        fontname = 'Arial';      % Font name for text
        axfontsize = 10;         % Axis font size
        axcolor = [0.1, 0.1, 0.1]; % Axis color
        axposition = [0.15, 0.2, 0.7, 0.7]; % Axis position
        
        % Legend properties
        legendfontsize = 10;     % Legend font size
        legendlabels = {};       % Legend labels
        legendpos = [0.75, 0.85, 0.15, 0.1]; % Legend position
        legendbox = 'on';        % Display legend box
        
        % Line properties
        linecolors = colorscheme(6, 5); % Line colors
        linestyles = {'--', '--', '--', '--', '-.', '-', ':'}; % Line styles
        linewidths = 1;          % Line width
        markers = {'o', 'd', '^', 'v', 'd', 'o', '^'}; % Line markers
        markersizes = 6;         % Marker size
        facecolor = 'none';      % Marker face color
        
        % Grid properties
        xgrid = 'on';            % X-axis grid
        ygrid = 'on';            % Y-axis grid
        
        % Tick properties
        tickdir = 'out';         % Tick direction
        ticklength = [0.01, 0.01]; % Tick length
        xtick = [];              % X-tick interval
        ytick = [];              % Y-tick interval
        xminortick = 'off';      % Minor X-ticks
        yminortick = 'off';      % Minor Y-ticks
    end
    
    %% Methods for plot setting and output
    methods
        %% Constructor to set default values
        function obj = plot_setting()
            % No specific logic here, default values are initialized in properties
        end
        
        %% Plot multiple lines with the defined settings
        function plotlines(obj, data)
            % Inputs:
            % - data: A matrix where the first column is X, and the rest are Y values
            x = data(:, 1);
            y = data(:, 2:end);
            numlines = size(y, 2);  % Number of Y columns (lines to plot)
            
            figure('Position', [100, 100, obj.width*30, obj.height*30]);
            hold on;
            lines = gobjects(numlines, 1);
            
            % Plot each line with custom styles
            for i = 1:numlines
                lines(i) = plot(x, y(:, i), ...
                    'LineWidth', obj.linewidths, ...
                    'Color', obj.linecolors(mod(i-1, size(obj.linecolors, 1)) + 1, :), ...
                    'LineStyle', obj.linestyles{mod(i-1, length(obj.linestyles)) + 1}, ...
                    'Marker', obj.markers{mod(i-1, length(obj.markers)) + 1}, ...
                    'MarkerSize', obj.markersizes, ...
                    'MarkerEdgeColor', obj.linecolors(mod(i-1, size(obj.linecolors, 1)) + 1, :), ...
                    'MarkerFaceColor', obj.facecolor);
            end
            
            % Set axis properties
            ax = gca;
            set(ax, 'FontName', obj.fontname, 'FontSize', obj.axfontsize, ...
                'Position', obj.axposition, 'XColor', obj.axcolor, 'YColor', obj.axcolor, ...
                'XGrid', obj.xgrid, 'YGrid', obj.ygrid, ...
                'TickDir', obj.tickdir, 'TickLength', obj.ticklength, ...
                'XMinorTick', obj.xminortick, 'YMinorTick', obj.yminortick, ...
                'XLim', obj.xlim, 'YLim', obj.ylim, ...
                'XTick', obj.xtick, 'YTick', obj.ytick);
            
            % Set labels and title
            xlabel(obj.xlabel, 'FontSize', obj.axfontsize, 'FontName', obj.fontname); %#ok
            ylabel(obj.ylabel, 'FontSize', obj.axfontsize, 'FontName', obj.fontname); %#ok
            title(obj.title, 'FontSize', obj.titlefontsize, 'FontName', obj.fontname, ... 
                'FontWeight', 'bold', 'Position', obj.titlepos); %#ok
            
            % Set legend
            obj.legendlabels = arrayfun(@(i) ['Line ', num2str(i)], 1:numlines, 'UniformOutput', false);
            legend(lines, obj.legendlabels{:}, 'FontSize', obj.legendfontsize, ...
                'Position', obj.legendpos, 'Box', obj.legendbox);
            
            hold off;
        end
        
        %% Output the figure as an image file
        function output(obj)
            hfig = gcf;
            set(hfig, 'PaperUnits', obj.units);
            set(hfig, 'PaperPosition', [0, 0, obj.width, obj.height]);
            print(hfig, 'multilines.tif', '-r300', '-dtiff');
        end
    end
end
