%genConstraints
%	This script generates all equality and inequality constrints for QP.
%
% Author : Ajinkya Khade, askhade@ncsu.edu

% Initializing matrices to store input constraints
Umaxbar = kron(ones(Nc*nu,1),umax);
Uminbar = kron(ones(Nc*nu,1),umin);

% Anonymous function to calculate state and constraints
Scbar = @(sivd, v0) kron(ones(Np,1),[sivd;v0]);

% Initialize equality and inequlity contraint matrices
[Lineq, Mineq, Leq, Meq] = deal(cell(2,1));

%% Inequality Constraints

if ineqMode == 0
    % No Constraints
    Lineq = [];
    Mineq = @(e,sivd,v0) [];           % when inequality constraints have to be removed
elseif ineqMode == 1
    % All Constraints
    Lineq = [Cbar*Bbar; ...
             eye(Nc*nu); ...
            -eye(Nc*nu)];

    Mineq = @(e,sivd,v0) [Scbar(sivd,v0) - Cbar*Abar*e; ...
                          Umaxbar; ...
                         -Uminbar];
elseif ineqMode == 2
    % Only Control Constraints
    Lineq = [eye(Nc*nu); ...
            -eye(Nc*nu)];

    Mineq = @(e,sivd,v0) [Umaxbar; ...
                         -Uminbar];
end

%% Equality Constraints
psi = zeros(nx,1);           % terminal state constraint

if eqMode == 0
    Leq = [];
    Meq = @(e) [];           % when equality constraints have to be removed
elseif eqMode == 1
    Leq = Bbar(end-nx+1:end,:);
    Meq = @(e) (psi - Abar(end-nx+1:end,:)*e);
end
