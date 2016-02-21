function simOutput = main(tau, ts, tsim, umin, umax, Np, Nc, Q, R, S, e0, sivdMode, ineqMode, eqMode,chkInputBoundFlag,Xref)

%% Discrete-time ACC vehicle model

% State Matrix
phi = [1 ts 0; ...
       0 1  ts; ...
       0 0  1 - (ts/tau)];
   
% Input Matrix
gamma = [0; 0; ts/tau];

% Output Matrix
lambda = [1  0 0; ...
          0 -1 0];
      
nx = size(phi,    1);           % Number of states
nu = size(gamma,  2);           % Number of inputs
ny = size(lambda, 1);           % Number of outputs

Nsim = floor(tsim/ts) + 1;      % Number of time steps in simulation

checkInputs                     % Check if input parameters satisfy all requirements

%% QP Formulation

% Generate composite matrices
[Abar, Bbar, Cbar] = genCompMat(phi, gamma, lambda, Np, Nc);

genConstraints                  % Generate all constraint matrices

% Weighting Matricies
Qbar = blkdiag(kron(eye(Np-1),Q),S);
Rbar = kron(eye(Nc),R);

% Hessian
H = Rbar + (Bbar')*Qbar*Bbar;
g = (Abar')*Qbar*Bbar;
G = @(e) ((e')*g);              % Anonymous function to calculate G for any given error vector

%% MPC Simulation

simOutput = mpcSim(nx, ny, nu, Nsim, e0, umin, umax, H, G, Lineq, Mineq, Leq, Meq, phi, gamma, lambda, chkInputBoundFlag, sivdMode, Xref);
simOutput.ts   = ts;
simOutput.tsim = tsim;
simOutput.sivdmode = sivdMode;
simOutput.displayname = '';

end