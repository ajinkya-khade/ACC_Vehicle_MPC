function X = getXref(a, v0, vdes, ts, tsim)
% getXref Generate reference trajectory for tracking vehicle
%       This function generates the reference trajectory for tracking
%       vehicle to follow for a given acceleration and desired steady-state
%       velocity
%
% Author : Ajinkya Khade, askhade@ncsu.edu

% Initializing arrays to store simulation time and tracking vehicle
% position
t = 0:ts:tsim;
X = zeros(3,length(t));

% Setting velocity and acceleration value at beginning of simulation
X(2,1) = v0;
X(3,1) = a;

Nsim = floor(tsim/ts) + 1;

for i = 1:Nsim
    X(1,i+1) = X(1,i) + X(2,i)*ts;
    X(2,i+1) = X(2,i) + X(3,i)*ts;
    
    % Setting acceleration value for next time step
    if sign(a)*X(2,i+1) >= sign(a)*vdes
        X(3,i+1) = 0;           %acceleration = 0, if desired velocity reached
    else
        X(3,i+1) = a;           %acceleration = a, if desired velocity not reached
    end
end

end