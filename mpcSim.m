function simOutput = mpcSim(nx, ny, nu, Nsim, e0, umin, umax, H, G, Lineq, Mineq, Leq, Meq, phi, gamma, lambda, chkInputBoundFlag, sivdMode, Xref)
% mpcSim Simulate the system with MPC Controller
%       
% Author : Ajinkya Khade, askhade@ncsu.edu

[J, sivd,exitflag] = deal(zeros(1, Nsim));

% Initializing matrices to log simulation data
empc = zeros(nx, Nsim);         % stores error vectors at all time steps
ympc = zeros(ny, Nsim);         % stores output vectors at all time steps
umpc = zeros(nu, Nsim);         % stores calculated input vectors 
uact = umpc;                    % stores applied input vectors 

% Assigning values at the beginning of simulation
empc(:,1) = e0;
umpc(:,1) = 0;
sivd(1)   = Xref(2);

% Options structure for the QP Solver
options = optimoptions('quadprog','Algorithm','active-set','Display','off','TolFun',0.001);

% Simulating over N time steps
for k = 1:Nsim
    
    F = (2*G(empc(:,k)))';
    
    % Solving the QP at current time step
    [U, J(k),exitflag(k)] = quadprog(H, F, Lineq, Mineq(empc(:,k),sivd(k),Xref(2,k)), ...
                                           Leq,   Meq(empc(:,k)), ...
                                           [], [], [], options);
    
	% Extracting and storing calculated input at current time step
    umpc(:,k)   = U(1:nu);
    % Checking for saturation and storing applied input at current time step
    uact(:,k)   = getActualU(umpc(:,k), umin, umax, chkInputBoundFlag);
	% Calculating and storing error vector at current time step
    empc(:,k+1) = phi*empc(:,k) + gamma*uact(:,k);
	% Calculating and storing ouput at current time step
    ympc(:,k)   = lambda*empc(:,k);
    
    % Calculating SIVD
    if sivdMode == 0
        % SIVD varies linearly with reference trajectory
        sivd(k+1) = Xref(2,k);
    elseif sivdMode == 1
        % SIVD varies dynamically with range rate
        sivd(k+1) = getsivd(empc(2,k), umin);
    end
    
    % Update range and range rate to make it relative to SIVD
    empc(1,k+1) = empc(1,k+1) + (sivd(k+1) - sivd(k));
    empc(2,k+1) = empc(2,k+1) - (Xref(2,k+1) - Xref(2,k));
end

empc = empc(:,1:end-1);
sivd = sivd(:,1:end-1);

% Storing all simulation information in a structure for returning
simOutput.empc = empc;
simOutput.ympc = ympc;
simOutput.umpc = umpc;
simOutput.uact = uact;
simOutput.sivd = sivd;
simOutput.exitflag = exitflag;
simOutput.J = J;

end

function uact = getActualU(umpc, umin, umax, uConstraintFlag)
%getActualU  Calculate actual input applied.
%   This function checks if input violates bounds and calculates the actual 
%   input to be applied.

uact = umpc;

if uConstraintFlag
    if umpc > umax
        uact = umax;
    elseif umpc < umin
        uact = umin;
    end
end

end