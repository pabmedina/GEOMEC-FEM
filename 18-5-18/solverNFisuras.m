function [pElementsBarra, qElementsBarra, Qbomba] = solverNFisuras(qLK, nFisuras, dofsBCcell, QbPoly, pBombas,elementsBarraT,nodeDofscell,Hcell,nodosPorFisura)

pElementsBarra = zeros(size(elementsBarraT,1),1);
qElementsBarra =  zeros(size(elementsBarraT,1),1);
Qbomba = zeros(nFisuras,1);

for iFisura = 1 : nFisuras
    qLKf = qLK(1 + (iFisura - 1)*nodosPorFisura:(iFisura - 1)*nodosPorFisura + nodosPorFisura,:);   %%% ver de donde sale el 11
    dofsX = dofsBCcell{iFisura}{2};
    dofsC = dofsBCcell{iFisura}{1};
    [Q, p] = solverFisuras(pBombas(iFisura),qLKf,Hcell{iFisura},dofsX,dofsC);
    [a,b] = ismember(elementsBarraT(:,1),nodeDofscell{iFisura}(:,1));
    pElementsBarra(a) = p(b(a));
    qElementsBarra(a) = Q(b(a));
    Qbomba(iFisura) = polyval(QbPoly,pBombas(iFisura));
end

end