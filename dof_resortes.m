function [ v1,v2,v3,v4,v5,v6] = dof_resortes(nNod,nodes)

% base z=0
v1 = false(nNod,1);
v1(nodes(:,3)==0,1) = true;                          % v1 es un vector lógico auxiliar



% Para los resortes de la cara West (x=0)
v2 = false(nNod,1);
v2(nodes(:,1)==0,1) = true;                          % v2 es un vector lógico auxiliar



   % Numeración de los nuevos nodos agragados. Son a los que se conectan los resortes
% Para los resortes de la cara West (x=400)

v3 = false(nNod,1);
v3(nodes(:,1)==400,1) = true;                          % v3 es un vector lógico auxiliar



           
% Para los resortes en la cara South (y=0)

v4 = false(nNod,1);
v4(nodes(:,2)==0,1) = true;


% Para los resortes de la cara North (y=400)

v5 = false(nNod,1);
v5(nodes(:,2)==400,1) = true;



% Para los resortes de la cara Top (z=80)

v6 = false(nNod,1);
v6(nodes(:,3)==80,1) = true;


                  

end

