%% about
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           setup.m                                       
% This file contains all the simulation parameters that can be tuned by the 
% user for different test cases. The code in any of the other files
% shouldn't be varied for trying differennt test cases.
%
% Author : Ajinkya Khade, askhade@ncsu.edu
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if ~license('test','optimization_toolbox')
    error('Optimization Toolbox License is needed for running this program.')
end
%% Time parameters

tau  = 0.5;                 % in s, time-lag of lower-level controller
ts   = 0.1;                 % in s, sampling time of system
tsim = 10;                  % in s, simulation time

%% Constraints

% Input 
g = 9.81; 

umin = -0.5*g;              % in m/s^2, maximum deceleration
umax = 0.25*g;              % in m/s^2, maximum acceleration

% Constraint Modes
% 0 = no constraints; 1 = all; 
ineqMode = 1;               % 2 = input constraint only
eqMode   = 1;

chkInputBoundFlag = true;	% input saturation
%% MPC Parameters

% Horizons 
Np = 100;                    % Prediction Horizon
Nc = 100;                    % Control Horizon

% Weighting Matrices
Q = eye(3);                  % state weighting matrix
R = eye(1);                  % input weighting matrix
S = eye(3);                  % terminal state weights

%% Initial Conditions
% Legend - 
% e0 - initial error vector
%
% sivdMode - 
%       0 - SIVD varies linearly with reference trajectory
%       1 - SIVD varies dynamically with range rate
%
% sivdPlotMode - 
%       0 - Position is plotted with respect to origin of refrence frame only
%       1 - Position is plotted with respect to tracking vehicle also

e0 = [-110; 30; 0];
sivdMode = 0;
sivdPlotMode = false;

% For Stalled Target Vehicle
a = 0;         % m/s^2
v0 = 0;        % m/s
vdes = 0;      % m/s
Xref = getXref(a, v0, vdes, ts, tsim);      % generate reference trajectory for tracking vehicle

%% Sweep Parameters & Plot Specific Parameters
%
% Legend - 
% sweepParamName - names of parameters over which a sweep is being
%                  performed for the required analysis
% sweepParamVals - sets of values to sweep over for the sweepParams
% sweepParamDisp - names to display for the different cases in the sweep
% legendMode     -
%       1 - concatenates name of sweep parameter to display name
%       2 - uses display name as is
% e0             - initial error vector


% Fig 2
sweepParamName = {'ineqMode','chkInputBoundFlag'};
sweepParamVals = {0,false;...
                  0,true;...
                  2,false};
sweepParamDisp = {'unlimited deceleration', ...
                  'saturated deceleration', ...
                  'constrained deceleration'};
legendMode = 2;
e0 = [-110; 30; 0];

% % Fig 3
% sweepParamName = {'sivdMode'};
% sweepParamVals = {0;1};
% sweepParamDisp = {'constant sivd','dynamic sivd'};
% legendMode = 2;
% sivdPlotMode = true;

% % Fig 4
% sweepParamName = {'tau'};
% sweepParamVals = {0.5;0.4;0.6};
% sweepParamDisp = {'0.5','0.4','0.6'};
% legendMode = 1;

% % Fig 5
% e0 = [-110; 10; 0];
% sweepParamName = {'Nc'};
% sweepParamVals = {25;50;75;100};
% sweepParamDisp = {'25','50','75','100'};
% legendMode = 1;

% % Fig 6
% e0 = [-50; 5; 0];
% sweepParamName = {'Q'};
% sweepParamVals = {diag([1  100 1]); ...
%                   eye(3); ...
%                   diag([100 1  1])};
% sweepParamDisp = {'Q_{Vel} = 100*Q_{Pos}'; ...
%                   'Q_{Vel} = Q_{Pos}'; ...
%                   'Q_{Pos} = 100*Q_{Vel}'};
% legendMode = 2;

% % Fig 7
% a = 2;          %m/s^2
% v0 = 10;        % m/s
% vdes = 29;      % m/s
% Xref = getXref(a, v0, vdes, ts, tsim);
% 
% e0 = [-50; 20; 0];
% sweepParamName = {'tau'};
% sweepParamVals = {0.25;0.5;0.75};
% sweepParamDisp = {'0.25';'0.5';'0.75'};
% % sweepParamVals = {0.5};
% % sweepParamDisp = {'0.5'};
% legendMode = 1;

