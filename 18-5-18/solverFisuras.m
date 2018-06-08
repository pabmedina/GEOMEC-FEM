function [Q,p] = solverFisuras(pBomba,qLK,H,dofsX,dofsC)

%% Matrices necesarias
Hxx = H(dofsX,dofsX);
Hcc = H(dofsC,dofsC);
Hxc = H(dofsX,dofsC);
Hcx = H(dofsC,dofsX);
p = zeros(size(H,1),1);

%% Resolucion
Q = qLK;
Qc = Q(dofsX);
p(dofsC) = pBomba;
p(dofsX) = Hxx\(Qc - Hxc*pBomba);
Q(dofsC) = Hcx*p(dofsX) + Hcc*pBomba;

end

