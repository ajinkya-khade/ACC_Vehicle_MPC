clear all;
close all;
setup           % Load all input parameters

% All possible input variables over which the code might perform a sweep
inputNames = {'tau', 'ts', 'tsim', 'umin', 'umax', 'Np', 'Nc', 'Q', 'R', 'S', 'e0','sivdMode','ineqMode','eqMode','chkInputBoundFlag','Xref'};
inputArray = {tau, ts, tsim, umin, umax, Np, Nc, Q, R, S, e0, sivdMode, ineqMode,eqMode,chkInputBoundFlag,Xref};

% Find the parameters the code needs to sweep over for given input settings
sweepParamLoc = find(ismember(inputNames, sweepParamName));

fprintf('Starting simulation...\n');

for i = 1:size(sweepParamVals,1)
    
    fprintf('Simulation Case #%i\n', i);
    
    % local variable to store the input values for current case
    inputArrayLocal = inputArray;           
    
    % assigning values specific to current case for all sweep parameters
    for j = 1:length(sweepParamLoc)
        inputArrayLocal{sweepParamLoc(j)} = sweepParamVals{i,j};
    end
    
    % storing simulation output structure in an array for processing later
    simOutputArray(i) = main(inputArrayLocal{:});
    
    if legendMode == 1
        simOutputArray(i).displayname = [sweepParamName{:}, ' = ', sweepParamDisp{i}];
    elseif legendMode == 2
        simOutputArray(i).displayname = sweepParamDisp{i};
    end
end

fprintf('Simulation Complete!\n');
fprintf('Generating Plots...\n');

genPlots(simOutputArray,sivdPlotMode);

% Uncomment to plot absolute position and velocity of ACC and target
% vehicle
% plotAbsolute(simOutputArray, Xref);       

% Uncomment to plot optimiztion cost at all time steps
% plotCost(simOutputArray);

fprintf('End of program!\n')
beep