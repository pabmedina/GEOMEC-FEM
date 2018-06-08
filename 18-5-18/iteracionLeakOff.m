for k = 1:MAXi   

    p2 = p1 - f1 .* (p1 - p0) ./ ( f1  - f0);
    
    err = abs(p2-p1);
    relErr = 2*err ./(abs(p2) + DELTA);
    
    % Cambios para la siguiente iteracion
    f0 = f1;
    p0 = p1;
    p1 = p2;
    
    for iFisura = 1 : nFisuras
        nDofTot = size(nodeDofscell{iFisura},1);
        qLK0 = ones(nDofTot,nDofNod) * - polyval(qLOPoly,p1(iFisura));
        dofsX = dofsBCcell{iFisura}{2};
        dofsC = dofsBCcell{iFisura}{1};
        [Q, p] = solverFisuras(p1(iFisura),qLK0,Hcell{iFisura},dofsX,dofsC);
        [a,b] = ismember(nodeDofsT(:,1),nodeDofscell{iFisura}(:,1));
        pElementsBarra(a) = p(b(a));
        qElementsBarra(a) = Q(b(a));
    end
    
    MAXi = 40;
    for j = 1:MAXi
        
        for iFisura = 1 : nFisuras
            nDofTot = size(nodeDofscell{iFisura},1);
            qLK = funcionPablo(pElementsBarra,elements);
            qLK = qLK(1:iFisura*(12+1));
            dofsX = dofsBCcell{iFisura}{2};
            dofsC = dofsBCcell{iFisura}{1};
            [Q, p] = solverFisuras(p1(iFisura),qLK,Hcell{iFisura},dofsX,dofsC);
            [a,b] = ismember(nodeDofsT(:,1),nodeDofscell{iFisura}(:,1));
            pElementsBarra(a) = p(b(a));
            qElementsBarra(a) = Q(b(a));
        end
        error = abs(qLK-qLK0);
        qLK0 = qLK;
        
        if error<3e-10
            break
        end
        
        
    end
    
    Qsys = qElementsBarra(ismember(elementsBarraT(:,1),nodosBombas));
    Qbomba = polyval(QbPoly,p1);
    f1 = Qsys - Qbomba;
    errores = (err < DELTA) || (relErr < DELTA) || (abs(f1) < EPSILON);
    
    % Check convergencia
    if any(errores)
        if (p1 > pMax) || (p1 < pMin)
            disp('El equilibrio no existe para la curva de bomba cargada' );
            break
        end
        disp('********Convergencia finalizada********' )
        disp(' ')
        disp('Presion final en el nodo de la bomba: ' )
        display(p1);
        disp('Caudal final en el nodo de la bomba: ' )
        display(Qsys);
        disp('Cantidad de iteraciones: ' )
        display(k);
        break
    else
    end
end
