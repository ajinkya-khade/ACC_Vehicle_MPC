function genPlots(simOutputArray, sivdPlotMode)
% genPlots Generate plots for visualizing simulation output
%
% Author : Ajinkya Khade, askhade@ncsu.edu

% List of y-axis labels for the 4 subplots
ylabelArray = {'Relative Position (m)', 'Vehicle Velocity (m/s)', ...
               'Vehicle Acceleration (m/s^2)', ' Commanded Acceleration (m/s^2)'};

% List of titles for the 4 subplots           
titleArray  = {'(a)', '(b)', '(c)', '(d)'};

% List of line colors to be used for plotting different simulation cases
lineColorArray = {'k', 'b', 'r', 'm'};

% initializing array to store plot handles
h = zeros(4, length(simOutputArray));

% empty cell array to store legend entries
legendLog = {};

figure('units','normalized','outerposition',[0 0 1 1])

% plotting data for each simulation object stored in array
for i = 1:length(simOutputArray)
    
    tplot = 0:simOutputArray(i).ts:simOutputArray(i).tsim;              % Array containing simulation time steps
    Nsim = floor(simOutputArray(i).tsim/simOutputArray(i).ts) + 1;      % Number of time steps in simulation

    yplot = [simOutputArray(i).empc(:,:); simOutputArray(i).uact];      % All data to be plotted on y-axis
    
    % Searching for point where relative distance becomes
    % positive, indicating a collision
    tcInd = find((simOutputArray(i).empc(1,:) - simOutputArray(i).sivd) > 0.0001, 1);
    
    % Setting point of collision to end point - this is just to prevent
    % errors because of the way the code works
    if isempty(tcInd)
        tcInd = Nsim;
    end

    % plotting the different sets of data for current time step on
    % different subplots
    for subplotNum = 1:4
        subplot(2,2,subplotNum)

        hold on; grid on;

        h(subplotNum,i) = plot(tplot(1:tcInd-1),   yplot(subplotNum,1:tcInd-1),'LineStyle', '-', 'Color', lineColorArray{i});
        
        % if collision is detected, use different line styles before and
        % after collision
        if tcInd < Nsim
            plot(tplot(tcInd),       yplot(subplotNum,tcInd),       'xk','MarkerSize', 12);
            plot(tplot(tcInd+1:end), yplot(subplotNum,tcInd+1:end), 'LineStyle', '-.', 'Color', lineColorArray{i});
        end

        hold off

        xlabel('Time (s)', 'FontSize', 12);
        ylabel(ylabelArray{subplotNum}, 'FontSize', 12);
        title ( titleArray{subplotNum}, 'FontSize', 14);
        
    end
    
    % if position of ACC vehicle needs to beplotted with respect to
    % tracking vehicle also, not just origin of SIVD frame
    if sivdPlotMode 
        subplot(2,2,1)
        hold on;
        
        h(5,i) = plot(tplot(1:tcInd-1), yplot(1,1:tcInd-1) - simOutputArray(i).sivd(1,1:tcInd-1), 'LineStyle', '--', 'Color', lineColorArray{i});
        legendLog = [legendLog, [simOutputArray(i).displayname, ' - wrt tracking vehicle']];
        
        hold off
    end
end

% Adding legend entries
for subPlotNum = 1:4
    if (subPlotNum == 1) && sivdPlotMode
        legend([h(subPlotNum,:) h(5,:)], [{simOutputArray.displayname} legendLog]);
    else
        legend(h(subPlotNum,:), {simOutputArray.displayname});
    end
end

end