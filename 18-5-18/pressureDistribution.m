function pElementsBarra = pressureDistribution(vars4solve)

%% Información sobre la Malla
tic
%% HOLA SOY EL MANi
nFisuras = vars4solve.ifis;
elem8Nod = vars4solve.elements;
nodes = vars4solve.nodes;
elementsBarraT = vars4solve.elements_Barra;
nodosBombas = vars4solve.nod_in;
nNodFisura = size(elementsBarraT,1)/nFisuras;


%% Geometria de la malla

Hcell = cell(nFisuras,1);
dofsBCcell =  cell(nFisuras,2);
nodeDofscell = cell(nFisuras,1);
fisura = struct;

for iFisura = 1:nFisuras

    iFisuraElementsBarra = elementsBarraT(1 + (iFisura - 1)*nNodFisura:(iFisura - 1)*nNodFisura + nNodFisura,:);
    [elements,nodeDofs,nodesEleLocal,hh,nodosUnicos] = meshGenerator(elem8Nod,nodes,iFisuraElementsBarra);
    
    fisura(iFisura).nodeDofs = nodeDofs;
    nodeDofscell{iFisura} = nodeDofs;
    
    
    %% Variables fisicas
    
    MU = 8.95e-4;                                                               % [Pa· s] Viscocidad dinamica del agua @ 25 C   
    
    %% Discretizacion
    
    nDofNod = 1;                    % Nï¿½mero de grados de libertad por nodo
    nNodEle = 4;                    % Nï¿½mero de nodos por elemento
    nel = size(elements,1);         % Nï¿½mero de elementos
    nNod = size(nodosUnicos,1);           % Nï¿½mero de nodos
    nDofTot = nDofNod*nNod;         % Nï¿½mero de grados de libertad
    
    
    %% Gauss
    
    a   = 1/sqrt(3);
    % Ubicaciones puntos de Gauss
    upg = [ -a  -a
             a  -a
             a   a
            -a   a ];
    % Nï¿½mero de puntos de Gauss
    npg = size(upg,1);
    wpg = ones(npg,1);
    
    %% Funciones de forma
    
    Ni = zeros(1,4,npg);
    for ipg = 1:npg
        
        ksi = upg(ipg,1);
        eta = upg(ipg,2);
        
        N4 = 0.25*(1 - ksi)*(1 + eta);
        N3 = 0.25*(1 + ksi)*(1 + eta);
        N2 = 0.25*(1 + ksi)*(1 - eta);
        N1 = 0.25*(1 - ksi)*(1 - eta);
        
        Ni(1,:,ipg) = [N1 N2 N3 N4];
    end
    
    
    %% Matriz [H] global
    
    A = cell(3,1);
    for iele = 1:nel
        He = zeros(nDofNod*nNodEle);
        nodesEle = nodesEleLocal{iele};
        hhEle = hh(elements(iele,:));
        for ipg = 1:npg
            % Punto de Gauss
            ksi = upg(ipg,1);
            eta = upg(ipg,2);
            % Derivadas de las funciones de forma respecto de ksi, eta
            dN = 1/4*[-(1-eta)   1-eta    1+eta  -(1+eta)
                -(1-ksi) -(1+ksi)   1+ksi    1-ksi ];
            % Derivadas de x,y, respecto de ksi, eta
            jac = dN*nodesEle;
            % Derivadas de las funciones de forma respecto de x,y.
            dNxy = jac\dN;          % dNxy = inv(jac)*dN
            
            B = zeros(2,nDofNod*nNodEle);
            B(1,:) = dNxy(1,:);
            B(2,:) = dNxy(2,:);
            
            % Interpolacion de los valores nodales de h a los ipg
            h = Ni(1,:,ipg)*hhEle;
            % Matriz H local del elemento en el ipg
            HL = h^2 / (12 * MU) * [ 1   0
                0   1];
            
            He = He + B'*HL*B*wpg(ipg)*det(jac)*h;
        end
        
        eleDofs = nodeDofs(ismember(nodeDofs(:,1),elements(iele,:)),2);
        I = repmat(eleDofs,1,size(eleDofs,1));
        J = repmat(eleDofs',size(eleDofs,1),1);
        A{1}{iele}=I;
        A{2}{iele}=J;
        A{3}{iele}=He;
        
    end
    
    % Ensamble
    
    I = vertcat(A{1,1}{:});
    J = vertcat(A{2,1}{:});
    S = vertcat(A{3,1}{:});
    H = sparse(I,J,S);
    
    Hcell{iFisura} =  H;
    
    
    
    %% Preparación de la resolución
    
    % Condiciones de borde
    
    % Definicion de DOFs conocidos (C) y desconocidos (X)
    
    dofBomba = nodeDofs(ismember(nodeDofs(:,1),nodosBombas(iFisura)),2);                           % DOF bomba
    dofsCi = [dofBomba];                      %#ok<NBRAK>
    dofsCe = [];
    dofsC = [dofsCe;
        dofsCi ];
    dofsX = setdiff(nodeDofs(:,2),dofsC);
    
    dofsBCcell{iFisura}{1} = dofsC;
    dofsBCcell{iFisura}{2} = dofsX;

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

% plot(linspace(pMin,pMax,10),polyval(QbPoly,linspace(pMin,pMax,10)));
% hold on



%% Visualizacion grafica de la curva del sistema y de la bomba
% 
% nSamples = 10;
% pSamples = linspace(pMin,pMax,nSamples);
% QSamples = zeros(nSamples,1);
% 
% for iSamples = 1:nSamples
%     Q = ones(nDofTot,nDofNod) * - polyval(qLOPoly,pSamples(iSamples));
%     Qc = Q(dofsX);
%     QSamples(iSamples) = Hcx*(Hxx \ ( Qc - Hxc* pSamples(iSamples)) ) + Hcc * pSamples(iSamples);
% end
% figure(2)
% plot(pSamples,QSamples)
% 
% Qbomba =  polyval(QbPoly,pSamples);
% hold on
% plot(pSamples,Qbomba)
% 
% % Plot de f(p)
% plot(pSamples,Qbomba'-QSamples)
% xlabel('Presion en el nodo de la bomba' )
% ylabel('Caudal en le nodo de la bomba' )
% legend('Qsys', 'Qbomba', 'f(p)')
% grid on
% 
%     
%     

%% Variablse necesarias para el Metodo numerico ( Resolver f(p) = Qbomba - Qsystema = 0 en los nodos de bomba) y resolvemos para la una raiz p.

p0 = ones(nFisuras,1)*pMin;                      % Valor semilla p0 
p1 = ones(nFisuras,1)*pMax;                      % Valor semilla p1

% Todas las bombas se resuelven al mismo timepo, por esa razon tanto p0, p1
% Qsys y Qbombas son de 3 


% Valores semilla de f(p0) y f(p1)
% f(p0) %

for iFisura = 1:nFisuras
    vars4solve.pBC(1 + (iFisura - 1)*nNodFisura:(iFisura - 1)*nNodFisura + nNodFisura,:) = p0(iFisura)*ones(nNodFisura,2);   %%% Arreglar
end

qLK = pressure4LeakOff(vars4solve);
qLK=qLK(:,1)+qLK(:,2);
qLK = -qLK;
%%% pablo

[pElementsBarra, qElementsBarra, Qbomba] = solverNFisuras(qLK, nFisuras, dofsBCcell, QbPoly, p0,elementsBarraT,nodeDofscell,Hcell,nNodFisura);

Qsys = qElementsBarra(ismember(elementsBarraT(:,1),nodosBombas));
f0 = Qsys - Qbomba;






% f(p1) %


for iFisura = 1:nFisuras
    vars4solve.pBC(1 + (iFisura - 1)*nNodFisura:(iFisura - 1)*nNodFisura + nNodFisura,:) = p1(iFisura)*ones(nNodFisura,2);   %%% Arreglar
end

qLK = pressure4LeakOff(vars4solve);
qLK=qLK(:,1)+qLK(:,2);
qLK = -qLK;

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
        vars4solve.pBC(1 + (iFisura - 1)*nNodFisura:(iFisura - 1)*nNodFisura + nNodFisura,:) = p1(iFisura)*ones(nNodFisura,2);   %%% Arreglar
    end
    qLK0 = pressure4LeakOff(vars4solve);
    qLK0 = qLK0(:,1)+qLK0(:,2);
    qLK0 = -qLK0;
    for j = 1:MAXi
        [pElementsBarra, qElementsBarra, Qbomba] = solverNFisuras(qLK0, nFisuras, dofsBCcell, QbPoly, p1,elementsBarraT,nodeDofscell,Hcell,nNodFisura);
        vars4solve.pBC = [pElementsBarra pElementsBarra];
        qLK = pressure4LeakOff(vars4solve);
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
