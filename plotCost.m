function plotCost(simOutputArray)
% plotCost Plot optimiztion cost
%       This function plots the optimization cost for all the
%       time steps in a simulation
%
% Author : Ajinkya Khade, askhade@ncsu.edu

% List of line colors to be used for plotting different simulation cases
lineColorArray = {'k', 'b', 'r', 'm'};

% initializing array to store plot handles
h = zeros(1,length(simOutputArray));

% initializing array to store points of collision for all simulation cases
tcIndLog = zeros(1,length(simOutputArray));

figure('units','normalized','outerposition',[0 0 1 1])

for i = 1:length(simOutputArray)
    
    Nsim = floor(simOutputArray(i).tsim/simOutputArray(i).ts) + 1;      % Number of time steps in simulation

    tplot = 0:simOutputArray(i).ts:simOutputArray(i).tsim;              % array of simulation time steps
    yplot = simOutputArray(i).J;                                        % aray of costs for all simulation cases
    
    % Searching for point where relative distance becomes
    % positive, indicating a collision
    tcInd = find((simOutputArray(i).empc(1,:) - simOutputArray(i).sivd) > 0.0001, 1);

    % Setting point of collision to end point - this is just to prevent
    % errors because of the way the code works
    if isempty(tcInd)
        tcInd = Nsim;
    end
    
    hold on; grid on;
    
    h(i) = plot(tplot(1:tcInd-1),yplot(1:tcInd-1),'LineStyle', '-', 'Color', lineColorArray{i});
    plot(tplot(tcInd), yplot(tcInd), 'xk','MarkerSize', 12);
    
    hold off;
    
    tcIndLog(i) = tcInd;            % storing point of collision
end

xlabel('Time (s)', 'FontSize', 12);
ylabel('Cost', 'FontSize', 12);
title ('Cost Variation with Control Horizon', 'FontSize', 14);

% Only display plot till point of first collision
xlim([0 tplot(min(tcIndLog))]);
legend(h, {simOutputArray.displayname});

end