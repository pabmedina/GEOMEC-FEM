function [elements,nodeDofs,nodesEleLocal,b,nodosUnicos] = meshGenerator(elem8Nod,nod,elementsBarra)


%% Funciones Ignacio Torrusio - H8 to Q4

f = 1;                                                                      % Factores que corrigen la apertura de la fisura (debido al reynolds)
f_0 = 1;                                                                    % Lo mismo de arriba.
aperturaMinima=0.0000;                                                      % La apertura minima es definida por el usuario e indica lo minimo para que la apertura se considere una fisura.

elemNew = generadorElementosQ4(elem8Nod);                                     % Genera elemNew que tiene los elementos Q4 generados en la caras de los H8 adyacentes a la fisura.

[nodFisura] = posicionFisura(nod,elementsBarra);                              % Esto indica que nodos pertenecen al dominio de la fisura. Cuenta tambien la cantidad de nodos, nNods.

[bCorr,b] = aperturaDeGrietaConCorreccion(nod,elementsBarra,f,f_0);           % Toma la altura que le pertenece a cada nodo de la fisura.

selectorLogico = seleccionDeElementosDeFisura(elementsBarra,elemNew,aperturaMinima,b);    % Este selector logico tiene la dimension de elemNew e indica quienes de ellos son efectivamente caras de la fisura. Siendo true cuando lo es, y falso cuando no.


%% Conversioón a malla reducida

elements = elemNew(selectorLogico,:);
nodosUnicos = unique(elements);
nNod = size(nodosUnicos,1);
nodeDofs = [nodosUnicos,(1:nNod)'];

% Tomo los nodesEles locales de cada elemento a ensamblar.
nodesEleLocal = cell(size(elements,1),1);

for iEle = 1:size(elements,1)
   
    elementNodes=elements(iEle,:);
    coord = zeros(4,3);
    for j=1:4
        coord(j,:) = nodFisura(elementNodes(j),:);
    end
    
    % Aplastamiento de las superficies de la fisura hasta llevarlas a 2d.
    
    vector1 = coord(2,:)-coord(1,:);
    vector2 = coord(3,:)-coord(1,:);
    vector3 = coord(4,:)-coord(1,:);
    
    angulo2 = atan2(norm(cross(vector1,vector2)), dot(vector1,vector2));
    angulo3 = atan2(norm(cross(vector1,vector3)), dot(vector1,vector3));
    
    v1loc = norm(vector1);
    v2loc = norm(vector2);
    v3loc = norm(vector3);
    
    coordLocal = [0 0
                  v1loc 0
                  v2loc*cos(angulo2) v2loc*sin(angulo2)
                  v3loc*cos(angulo3) v3loc*sin(angulo3)]; 
 
    nodesEleLocal{iEle} = coordLocal;
    
end






end





