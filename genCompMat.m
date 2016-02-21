function [Abar, Bbar, Cbar] = genCompMat(phi, gamma, lambda, Np, Nc)
% genCompMat Generate composite matrices for FTCOCP
%
% Author : Ajinkya Khade, askhade@ncsu.edu

Abar = cell(Np, 1);
Bbar = cell(Np, Nc);

b0 = zeros(size(gamma));

for i = 1:Np
    Abar{i} = phi^i;
    
    for j = 1:Nc
        if i >= j
            Bbar{i,j} = (phi^(i-j))*gamma;
        else
            Bbar{i,j} = b0;
        end
    end
end

Abar = cell2mat(Abar);
Bbar = cell2mat(Bbar);
Cbar = kron(eye(Np),lambda);

end