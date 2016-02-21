function plotAbsolute(simOutputArray, Xref)
% plotAbsolute Plot absolute position and velocity from simulation output
%       This function plots the absolute position and velocity of the ACC
%       vehicle as well as the tracking vehicle for all the simulation
%       cases.
%
% Author : Ajinkya Khade, askhade@ncsu.edu

% List of y-axis labels for the 2 subplots
ylabelArray = {'Absolute Position (m)', 'Absolute Velocity (m/s)'};

% List of titles for the 2 subplots
titleArray  = {'(a)', '(b)', '(c)', '(d)'};

% List of line colors to be used for the different simulation cases
lineColorArray = {'k', 'b', 'r', 'm'};

% initializing array to store plot handles
h = zeros(2, length(simOutputArray));

% empty cell array to store legend entries
legendLog = {};

figure('units','normalized','outerposition',[0 0 1 1])

% plotting data for each simulation object stored in array
for i = 1:length(simOutputArray)
    
    tplot = 0:simOutputArray(i).ts:simOutputArray(i).tsim;              % Array containing simulation time steps
    Nsim = floor(simOutputArray(i).tsim/simOutputArray(i).ts) + 1;      % Number of time steps in simulation

    % calculating absolute position and velocity
    yplot = simOutputArray(i).empc(1:2,:) + Xref(1:2,1:end-1);          
    yplot(1,:) = yplot(1,:) - simOutputArray(i).sivd;

    % Searching for point where relative distance becomes
    % positive, indicating a collision
    tcInd = find((simOutputArray(i).empc(1,:) - simOutputArray(i).sivd) > 0.0001, 1);
    
    % Setting point of collision to end point - this is just to prevent
    % errors because of the way the code works
    if isempty(tcInd)
        tcInd = Nsim;
    end
    
    % plotting position and velocity on different subplots
    for subplotNum = 1:2
        subplot(2,1,subplotNum)

        hold on; grid on;

        h(subplotNum,2*i-1) = plot(tplot(1:tcInd-1), yplot(subplotNum,1:tcInd-1),'LineStyle', '-', 'Color', lineColorArray{i});
        h(subplotNum,2*i)   = plot(tplot(1:tcInd-1), Xref(subplotNum,1:tcInd-1),'LineStyle', '--', 'Color', lineColorArray{i});
        
        % if collision is detected, use different line styles before and
        % after collision
        if tcInd < Nsim
            plot(tplot(tcInd), yplot(subplotNum,tcInd), 'xk','MarkerSize', 12);
            plot(tplot(tcInd), Xref(subplotNum,tcInd),  'xk','MarkerSize', 12);
            plot(tplot(tcInd+1:end), yplot(subplotNum,tcInd+1:end), 'LineStyle', '-.', 'Color', lineColorArray{i});
            plot(tplot(tcInd+1:end), Xref(subplotNum,tcInd+1:end-1),'LineStyle', ':',  'Color', lineColorArray{i});
        end

        hold off

        xlabel('Time (s)', 'FontSize', 12);
        ylabel(ylabelArray{subplotNum}, 'FontSize', 12);
        title ( titleArray{subplotNum}, 'FontSize', 14);
        
    end
    
    legendLog = [legendLog, ['ACC vehicle - ', simOutputArray(i).displayname], ['Target vehicle - ', simOutputArray(i).displayname]];
    
end

% Adding legend entries
for subPlotNum = 1:2
    legend(h(subPlotNum,:), legendLog);
end

end