% checkInputs
%   This script checks all input parameters to make sure they satisfy all
%   implicit constraints and are diensionally accurate.
%
% Author : Ajinkya Khade, askhade@ncsu.edu

%% Constraint Size Check
% This check has been built in to ensure the code is scalable for different
% input sizes. Currently it doesn't have much utility since input size is 1
if (size(umin) ~= [nu, 1]) | (size(umax) ~= [nu, 1])
    error('checkInputs:InputConstraintSizeChk', 'Umax and Umin must have same size as input vector.');
end

%% Horizon Values Check

% Control Horizon must be shorter than or equal to Prediction Horizon
if Nc > Np
    error('checkInputs:HorizonValChk', 'Nc can not be smaller than Np');
end

% Total duration of prediction horizon should not be greater than the total
% simulation duration.
if Np*ts > tsim
    error('checkInputs:HorizonValChk', 'Prediction horizon must be shorter than simulation duration.');
end

%% Weights Size Check
if (size(Q) ~= size(phi)) | (size(S) ~= size(phi))
    error('checkInputs:WeightSizeChk', 'Q and S matrices must have same size as state matrix phi');
end

if (size(R) ~= [nu, nu])
    error('checkInputs:WeightSizeChk', 'R matrix must have same size as number of inputs.');
end

%% Parameter Value Check

if ~ismember(sivdMode, [0,1])
    error('checkInputs:sivdModeValChk', 'sivdMode value must be 0 or 1.');
end

if ~ismember(ineqMode, [0,1,2])
    error('checkInputs:ineqModeValChk', 'ineqMode value must be 0, 1 or 2.');
end

if ~ismember(eqMode, [0,1])
    error('checkInputs:eqModeValChk', 'eqMode value must be 0 or 1.');
end