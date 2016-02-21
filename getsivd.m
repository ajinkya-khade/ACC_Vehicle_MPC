function sivd = getsivd(dr0, umin)
% getsivd Calculate SIVD for given range rate
%
% Author : Ajinkya Khade, askhade@ncsu.edu

syms t xf

% System of Equations to determine SIVD
x  = (dr0*t + (0.25 - 0.5*t + 0.5*t^2 - 0.25*exp(-2*t))*umin - xf);
dr = (dr0 + (-0.5 + t + 0.5*exp(-2*t))*umin);

% Solving Sytem of Equations
soln = solve([x;dr] == [0;0], t, xf);

% Return calculated SIVD
sivd = eval(soln.xf);

end
