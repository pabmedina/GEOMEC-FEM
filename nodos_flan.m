function [numNodBase,numNodWest,numNodEast,numNodSouth,numNodNorth,numNodTop,nodes_resortes, elements_resortes,nNodResortes,nDofResortes] = nodos_flan(nNod,nodes,ndof)

% base z=0
v1 = false(nNod,1);
v1(nodes(:,3)==0,1) = true;                          % v1 es un vector lógico auxiliar
nodes1_Base = nodes(v1,:);
nodes2_Base = nodes(v1,:);
nodes2_Base(:,3) = -0.1;

nNodBase = size(nodes2_Base,1);
numNodBase = nNod+1:(nNod+nNodBase);   

% Para los resortes de la cara West (x=0)
v2 = false(nNod,1);
v2(nodes(:,1)==0,1) = true;                          % v2 es un vector lógico auxiliar
nodes1_West = nodes(v2,:);
nodes2_West = nodes(v2,:);
nodes2_West(:,1) = -0.1;

nNodWest = size(nodes2_West,1);
numNodWest = (nNod+nNodBase+1):(nNod+nNodBase+nNodWest);     % Numeración de los nuevos nodos agragados. Son a los que se conectan los resortes
% Para los resortes de la cara West (x=400)

v3 = false(nNod,1);
v3(nodes(:,1)==400,1) = true;                          % v3 es un vector lógico auxiliar
nodes1_East = nodes(v3,:);
nodes2_East = nodes(v3,:);
nodes2_East(:,1) = 400.1;

nNodEast = size(nodes2_East,1);
numNodEast = (nNod+nNodBase+nNodWest+1):(nNod+nNodBase+nNodWest+nNodEast);  

           
% Para los resortes en la cara South (y=0)

v4 = false(nNod,1);
v4(nodes(:,2)==0,1) = true;
nodes1_South = nodes(v4,:);
nodes2_South = nodes(v4,:);
nodes2_South(:,2) = -0.1;

nNodSouth = size(nodes2_South,1);
numNodSouth = (nNod+nNodBase+nNodWest+nNodEast+1):(nNod+nNodBase+nNodWest+nNodEast+nNodSouth);

% Para los resortes de la cara North (y=400)

v5 = false(nNod,1);
v5(nodes(:,2)==400,1) = true;
nodes1_North = nodes(v5,:);
nodes2_North = nodes(v5,:);
nodes2_North(:,2) = 400.1;

nNodNorth = size(nodes2_North,1);
numNodNorth = (nNod+nNodBase+nNodWest+nNodEast+nNodSouth+1):(nNod+nNodBase+nNodWest+nNodEast+nNodSouth+nNodNorth);

% Para los resortes de la cara Top (z=80)

v6 = false(nNod,1);
v6(nodes(:,3)==80,1) = true;
nodes1_Top = nodes(v6,:);
nodes2_Top = nodes(v6,:);
nodes2_Top(:,3) = 80.1;

nNodTop = size(nodes2_Top,1);
numNodTop = (nNod+nNodBase+nNodWest+nNodEast+nNodSouth+nNodNorth+1):(nNod+nNodBase+nNodWest+nNodEast+nNodSouth+nNodNorth+nNodTop);

nodes_resortes = [ nodes1_Base
                   nodes1_West
                   nodes1_East
                   nodes1_South
                   nodes1_North
                   nodes1_Top
                   nodes2_Base
                   nodes2_West
                   nodes2_East
                   nodes2_South
                   nodes2_North
                   nodes2_Top   ];
               
elements_resortes = [ find(v1) numNodBase'
                      find(v2) numNodWest'
                      find(v3) numNodEast'
                      find(v4) numNodSouth'
                      find(v5) numNodNorth'
                      find(v6) numNodTop'  ];  % Matriz de conectividades de los resortes del flan
                  
                  
nNodResortes = nNodBase + nNodWest + nNodEast + nNodSouth + nNodNorth + nNodTop;    % Es el nº de nodos agregados a la malla por los resortes adicionales
nDofResortes = nNodResortes*ndof;                                         % Es el nº de dof agregados por los nodos de la línea anterior. Se deben adicionar a los dof de la malla original

end

