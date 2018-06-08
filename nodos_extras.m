function [ nodes2_Base, nodes2_West, nodes2_East, nodes2_South, nodes2_North, nodes2_Top,nNodBase,nNodWest,nNodEast,nNodNorth,nNodSouth,nNodTop] = nodos_extras(nNod,nodes)

% base z=0
v1 = false(nNod,1);
v1(nodes(:,3)==0,1) = true;                          % v1 es un vector lógico auxiliar
nodes1_Base = nodes(v1,:);
nodes2_Base = nodes(v1,:);
nodes2_Base(:,3) = -0.1;

nNodBase = size(nodes2_Base,1);


% Para los resortes de la cara West (x=0)
v2 = false(nNod,1);
v2(nodes(:,1)==0,1) = true;                          % v2 es un vector lógico auxiliar
nodes1_West = nodes(v2,:);
nodes2_West = nodes(v2,:);
nodes2_West(:,1) = -0.1;

nNodWest = size(nodes2_West,1);
   % Numeración de los nuevos nodos agragados. Son a los que se conectan los resortes
% Para los resortes de la cara West (x=400)

v3 = false(nNod,1);
v3(nodes(:,1)==400,1) = true;                          % v3 es un vector lógico auxiliar
nodes1_East = nodes(v3,:);
nodes2_East = nodes(v3,:);
nodes2_East(:,1) = 400.1;

nNodEast = size(nodes2_East,1);
           
% Para los resortes en la cara South (y=0)

v4 = false(nNod,1);
v4(nodes(:,2)==0,1) = true;
nodes1_South = nodes(v4,:);
nodes2_South = nodes(v4,:);
nodes2_South(:,2) = -0.1;

nNodSouth = size(nodes2_South,1);

% Para los resortes de la cara North (y=400)

v5 = false(nNod,1);
v5(nodes(:,2)==400,1) = true;
nodes1_North = nodes(v5,:);
nodes2_North = nodes(v5,:);
nodes2_North(:,2) = 400.1;

nNodNorth = size(nodes2_North,1);

% Para los resortes de la cara Top (z=80)

v6 = false(nNod,1);
v6(nodes(:,3)>79.999,1) = true;
nodes1_Top = nodes(v6,:);
nodes2_Top = nodes(v6,:);
nodes2_Top(:,3) = 80.1;

nNodTop = size(nodes2_Top,1);
                 
end

