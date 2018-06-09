function pElementsBarra = pressureDistribution(solidsInfo)

%% Estructuras de datos

fisurasInfo = struct;   % Posee la informacion de cada una de las fisuras.
meshInfo = struct; % Posee la informacion de la malla entregada por el codigo de solidos.
soluciones = struct; % Posee los vectores entregados por la funcion.
boundaryConditions = struct; % Posee la informacion sobre las condiciones de borde



%% Información sobre la Malla
tic
nFisuras = solidsInfo.ifis;
elem8Nod = solidsInfo.elements;
nodes = solidsInfo.nodes;
elementsBarraT = solidsInfo.elements_Barra;
nodosBombas = solidsInfo.nod_in; 
nNodFisura = size(elementsBarraT,1)/nFisuras;

meshInfo.nFisuras = solidsInfo.ifis;
meshInfo.elem8Nod = solidsInfo.elements;
meshInfo.nodes = solidsInfo.nodes;
meshInfo.elementsBarraT = solidsInfo.elements_Barra;
meshInfo.nodosBombas = solidsInfo.nod_in; 
meshInfo.nNodFisura = size(elementsBarraT,1)/nFisuras;




%% Geometria de la malla

Hcell = cell(nFisuras,1);
dofsBCcell =  cell(nFisuras,2);
nodeDofscell = cell(nFisuras,1);

for iFisura = 1:nFisuras

    fisurasInfo(iFisura).elementsBarra = elementsBarraT(1 + (iFisura - 1)*nNodFisura:(iFisura - 1)*nNodFisura + nNodFisura,:);
    fisurasInfo = meshGenerator(meshInfo,fisurasInfo,iFisura);
    fisurasInfo = ensambleH(meshInfo,fisurasInfo,iFisura);    
end


%% Iteracion de bomba - Metodo de la secante para hallar el equilibrio
% Ecuacion a resolver Qbomba -  Qsystema = 0, equilibrio entre la bomba y
% mi sistema.

% Curva de Bomba

QbMax = 0.08 / 3600;                % [m^3 / s] Entrada en [m^3 / h]
QbMin = 0 / 3600;                 % [m^3 / s] Entrada en [m^3 / h]
pMin = 400*9800;                   % [Pa] Entrada en metros de columna de agua
pMax =  700*9800;                 % [Pa] Entrada en metros de columna de agua

QbPoly = polyfit([pMin,(pMin+pMax)/2, pMax], [QbMax, QbMax/1.2  , QbMin],2);        % Aproximación de la curva de bomba con un polynomio
boundaryConditions.bomba.qBomba = QbPoly;

% plot(linspace(pMin,pMax,10),polyval(QbPoly,linspace(pMin,pMax,10)));
% hold on



%% Variablse necesarias para el Metodo numerico ( Resolver f(p) = Qbomba - Qsystema = 0 en los nodos de bomba) y resolvemos para la una raiz p.

p0 = ones(nFisuras,1)*pMin;                      % Valor semilla p0 
p1 = ones(nFisuras,1)*pMax;                      % Valor semilla p1

% Todas las bombas se resuelven al mismo timepo, por esa razon tanto p0, p1
% Qsys y Qbombas son de 3 


% Valores semilla de f(p0) y f(p1)
% f(p0) %

for iFisura = 1:nFisuras
    solidsInfo.pBC(1 + (iFisura - 1)*nNodFisura:(iFisura - 1)*nNodFisura + nNodFisura,:) = p0(iFisura)*ones(nNodFisura,2);   %%% Arreglar
end

qLK = pressure4LeakOff(solidsInfo);
qLK= -1*(qLK(:,1)+qLK(:,2));
boundaryConditions.qLK = qLK;
%%% pablo

[pElementsBarra, qElementsBarra, Qbomba] = solverNFisuras(qLK, nFisuras, dofsBCcell, QbPoly, p0,elementsBarraT,nodeDofscell,Hcell,nNodFisura);

Qsys = qElementsBarra(ismember(elementsBarraT(:,1),nodosBombas));
f0 = Qsys - Qbomba;






% f(p1) %


for iFisura = 1:nFisuras
    solidsInfo.pBC(1 + (iFisura - 1)*nNodFisura:(iFisura - 1)*nNodFisura + nNodFisura,:) = p1(iFisura)*ones(nNodFisura,2);   %%% Arreglar
end

qLK = pressure4LeakOff(solidsInfo);
qLK= -1*(qLK(:,1)+qLK(:,2));
boundaryConditions.qLK = qLK;

[pElementsBarra, qElementsBarra, Qbomba] = solverNFisuras(qLK, nFisuras, dofsBCcell, QbPoly, p1,elementsBarraT,nodeDofscell,Hcell,nNodFisura);
Qsys = qElementsBarra(ismember(elementsBarraT(:,1),nodosBombas));
f1 = Qsys - Qbomba;


% Parametros de convergencia 
DELTA = ones(nFisuras,1)*1e-5;                   % Tolerancia de error para la raiz
DELTAqLK = 0.1;
EPSILON = ones(nFisuras,1)*1e-10;                 % Tolerancia al residuo
MAXi = 40;                      % Cantidad maxima de iteraciones

% ITERACIONES



for k = 1:MAXi    

    p2 = p1 - f1 .* (p1 - p0) ./ ( f1  - f0);

    err = abs(p2-p1);
    relErr = 2*err ./(abs(p2) + DELTA);
    
    % Cambios para la siguiente iteracion
    f0 = f1;
    p0 = p1;
    p1 = p2;

    % Calculo la f1 del siguiente step, f0 sera el f1 anterior, no hay
    % necesidad de recalcular.
    for iFisura = 1:nFisuras
        solidsInfo.pBC(1 + (iFisura - 1)*nNodFisura:(iFisura - 1)*nNodFisura + nNodFisura,:) = p1(iFisura)*ones(nNodFisura,2);   %%% Arreglar
    end
    qLK0 = pressure4LeakOff(solidsInfo);
    qLK0 = qLK0(:,1)+qLK0(:,2);
    qLK0 = -qLK0;
    for j = 1:MAXi
        [pElementsBarra, qElementsBarra, Qbomba] = solverNFisuras(qLK0, nFisuras, dofsBCcell, QbPoly, p1,elementsBarraT,nodeDofscell,Hcell,nNodFisura);
        solidsInfo.pBC = [pElementsBarra pElementsBarra];
        qLK = pressure4LeakOff(solidsInfo);
        qLK=qLK(:,1)+qLK(:,2);
        qLK = -qLK;
        
        errorPorcentualPromedio = sum(abs((qLK0 - qLK) ./ norm(qLK0))) / size(qLK0,1);
        
        
        
        if (errorPorcentualPromedio < DELTAqLK)
            break
        else
            qLK0 = qLK;
        end
    end
    
        
        
% 
%         
%     for iFisura = 1 : nFisuras
%         [a,b] = ismember(elementsBarraT(:,1),nodeDofscell{iFisura}(:,1));
%         nDofTot = size(nodeDofscell{iFisura},1);
%         qLK = ones(nDofTot,nDofNod) * - polyval(qLOPoly,p1(iFisura));
%         % qLK = A = qElementsBarra(a)
%         % B = b(a)
%         % qLK = A(B)
%         dofsX = dofsBCcell{iFisura}{2};
%         dofsC = dofsBCcell{iFisura}{1};
%         [Q, p] = solverFisuras(p1(iFisura),qLK,Hcell{iFisura},dofsX,dofsC);
%         pElementsBarra(a) = p(b(a));
%         qElementsBarra(a) = Q(b(a));
%         Qbomba(iFisura) = polyval(QbPoly,p1(iFisura));
%     end
%     
    
    Qsys = qElementsBarra(ismember(elementsBarraT(:,1),nodosBombas));
%     plot(p1(1),Qsys(1),'*')
    f1 = Qsys - Qbomba;
    errores = [sum(err < DELTA) sum(relErr < DELTA) sum(abs(f1) < EPSILON)];

    % Check convergencia
    if any( (errores(1) == nFisuras) || (errores(2) == nFisuras) || (errores(3) == nFisuras))
        if any(sum(p1 > pMax*ones(nFisuras,1)) || sum(p1 < pMin*ones(nFisuras,1)))
            disp('El equilibrio no existe para la curva de bomba cargada' );
            break
        end
    disp('********Convergencia finalizada********' )
    disp(' ')
    disp('Presion final los nodos de las bombas: ' )
    display(p1);
    disp('Caudales final en el nodo de la bomba: ' )    
    display(Qsys);
    disp('Cantidad de iteraciones: ' )    
    display(k); 
    break
    else       
    end
end
pElementsBarra = [pElementsBarra pElementsBarra];
toc
end
