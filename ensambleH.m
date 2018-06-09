function fisurasInfo = ensambleH(meshInfo,fisurasInfo,iFisura)

elements = fisurasInfo(iFisura).elements;
nodeDofs = fisurasInfo(iFisura).nodeDofs;
nodesEleLocal = fisurasInfo(iFisura).nodesEleLocal;
hh = fisurasInfo(iFisura).hh;
nodosUnicos = fisurasInfo(iFisura).nodosUnicos;
nodosBombas = meshInfo.nodosBombas;


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
    fisurasInfo(iFisura).H = H;
   
    
    
    
    %% Preparación de la resolución
    
    % Condiciones de borde
    
    % Definicion de DOFs conocidos (C) y desconocidos (X)
    
    dofBomba = nodeDofs(ismember(nodeDofs(:,1),nodosBombas(iFisura)),2);                           % DOF bomba
    dofsCi = [dofBomba];                      %#ok<NBRAK>
    dofsCe = [];
    dofsC = [dofsCe;
        dofsCi ];
    dofsX = setdiff(nodeDofs(:,2),dofsC);
    
    fisurasInfo(iFisura).dofs.C = dofsC;
    fisurasInfo(iFisura).dofs.X = dofsX;
    
    
end
