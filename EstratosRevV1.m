clc
clearvars
close all
tic
 %% Malla

 
malla = 'M2';%'M22';%'M2';%'M333P';%'M333P';%'M3';%'M4';%'M3test';%%;%

switch malla
    case 'M333'
        nodesload = load('nodes_M333.txt');
        nodes = nodesload(:,[2,3,4]);
        elementsload = load('elements_M333.txt');
        elements = elementsload(:,2:9);    
    case 'M3test'
        nodesload = load('nodes_M3test.txt');
        nodes = nodesload(:,[2,3,4]);
        elementsload = load('elements_M3test.txt');
        elements = elementsload(:,2:9);    
    case 'M333P'
        nodesload = load('nodes_M333P.txt');
        nodes = nodesload(:,[2,3,4]);
        elementsload = load('elements_M333P.txt');
        elements = elementsload(:,2:9);    
    case 'M3'
        nodesload = load('nodes_M3.txt');
        nodes = nodesload(:,[2,3,4]);
        elementsload = load('elements_M3.txt');
        elements = elementsload(:,2:9);    
    case 'M22'
        nodesload = load('nodes_M22.txt');
        nodes = nodesload(:,[2,3,4]);
        elementsload = load('elements_M22.txt');
        elements = elementsload(:,2:9);  
    case 'M4'
        nodesload = load('nodes_M4.txt');
        nodes = nodesload(:,[2,3,4]);
        elementsload = load('elements_M4.txt');
        elements = elementsload(:,2:9);    
    case 'M2'
        nodesload = load('nodes_M2.txt');
        nodes = nodesload(:,[2,3,4]);
        elementsload = load('elements_M2.txt');
        elements = elementsload(:,2:9);    
end
 
% meshplot3D(elements,nodes,'b','w')

% nNod = size(nodes,1);    % numero de nodos sin considerar los resortes
% nel = size(elements,1);

ndof = 3;
% nDofTot = nNod*ndof;     % Sin considerar los dof de los resortes que se tienen que adicionar para armar el "flan"
nnodel = 8;
ifis = 3;
ndofel = 24;

% 
% % % % % % % % % % [eleFisura1_ymenos, sizefis1_menos, eleFisura1_ymas,sizefis1_mas,eleFisura2_ymenos,sizefis2_menos,eleFisura2_ymas,sizefis2_mas,eleFisura3_ymenos,sizefis3_menos,eleFisura3_ymas,sizefis3_mas] = forNacho(nel,nnodel,nodes,elements); 
% % % % % % % % % % % secciones: Función que me devuelve un corte transversal de los estratos
% % % % % % % % % % [nodes, elements,tipo]=unAdina(eleFisura1_ymenos, ...
% % % % % % % % % %     eleFisura1_ymas,eleFisura2_ymenos, ...
% % % % % % % % % %     eleFisura2_ymas,eleFisura3_ymenos, ...
% % % % % % % % % %     eleFisura3_ymas,nodes,elements);
% % 
% [tipo1_f1, tipo3_f1, tipo2_f1, tipo4_f1,tipo1_f2,tipo3_f2,tipo2_f2,tipo4_f2,tipo1_f3,tipo3_f3,tipo2_f3,tipo4_f3] = forNacho2(nel,nnodel,nodes,elements);  
% % [tipo1_f1, tipo3_f1, tipo2_f1, tipo4_f1,tipo1_f2,tipo3_f2,tipo2_f2,tipo4_f2,tipo1_f3,tipo3_f3,tipo2_f3,tipo4_f3] = forNacho3(nel,nnodel,nodes,elements);  
% 
% [nodes,elements,tipo]=unAdinaPiola(tipo1_f1, tipo3_f1, tipo2_f1, tipo4_f1 ...
%                                          ,tipo1_f2, tipo3_f2, tipo2_f2, tipo4_f2 ...
%                                          ,tipo1_f3, tipo3_f3, tipo2_f3, tipo4_f3 ...
%                                          ,nodes,elements); 

nNod = size(nodes,1);    % numero de nodos sin considerar los resortes
nel = size(elements,1);
nDofTot = nNod*ndof;     % Sin considerar los dof de los resortes que se tienen que adicionar para armar el "flan"

BiotH = 0.74;
BiotV = 0.84;
Biot = [ BiotH BiotH BiotV 0 0 0]'; 
Presion_Poral = 60e6;%60e6;

%%%% ------------- Valores tentativos

poro = 0.3;                  % porosidad    
biot = (BiotH + BiotV)/2;    % biot
C_fluid = 2.2e9;             % Bulk modulus del fluido
C_solid = 60e9;              % Bulk modulus de la parte solida

%%%% -------------

ycoord_fisu1 = 100;
ycoord_fisu2 = 200;
ycoord_fisu3 = 300;
                      
PMAX=60e6;
NDIV=30;


p_West = 0;%35e6;%0;%35e6;%60;
p_East = 0;%35e6;%;%0;%60
p_South = 0;%35e6; % 0;%0;%60
p_North = 0;%35e6; %0;%0;%60
p_Top = 0;%60e6; %0;%60

%% -------------------------------------- Ubicación de resortes para armar el flan --------------------------------------

[numNodBase,numNodWest,numNodEast,numNodSouth,numNodNorth,numNodTop,nodes_resortes,elements_resortes,nNodResortes,nDofResortes] = nodos_flan(nNod,nodes,ndof);

ndoftot = nDofTot+nDofResortes;            % Dof totales de toda la malla (resortes de las caras incluidos)                           
nnod = nNodResortes + nNod;                % nº de nodos totales de la malla (resortes incluidos)

%% Malla total

[ nodes2_Base, nodes2_West, nodes2_East, nodes2_South, nodes2_North, nodes2_Top,nNodBase,nNodWest,nNodEast,nNodNorth,nNodSouth,nNodTop] = nodos_extras(nNod,nodes);
[ v1, v2, v3, v4, v5, v6] = dof_resortes(nNod,nodes);

nodes_tot = [ nodes
              nodes2_Base
              nodes2_West
              nodes2_East
              nodes2_South
              nodes2_North
              nodes2_Top  ];     % Conectividades de la matriz global

%% Resumen matriz K
for RESUMIRK =1
%% Separamos los elementos que están en contacto con las distintas fisuras

% % areaFractura: Me devuelve los elementos que estan en contacto con la fisura predefinida
[ele_fisu1_y1_1, ~, ele_fisu1_y1_2, ~, ele_fisu2_y2_1, ~, ele_fisu2_y2_2, ~, ele_fisu3_y3_1, ~, ele_fisu3_y3_2, ~] = areaFractura(nel,nnodel,nodes,elements); 

% % secciones: Función que me devuelve un corte transversal de los estratos
[seccion125, seccion150, seccion175, seccion200] = secciones(nel,nnodel,elements,nodes);
%% Dividir por estratos

% Input de la profundidad de los 10 estratos

d_estrato_10 = 15;                
d_estrato_9 = 24.98;
d_estrato_8 = 30.78;
d_estrato_7 = 34.89;
d_estrato_6 = 44.64;
d_estrato_5 = 54.55;
d_estrato_4 = 56.78;
d_estrato_3 = 61.56;
d_estrato_2 = 64.15;
d_estrato_1 = 80;

% Estos valores se sacan de ADINA

switch malla
    case 'M333P'
        div9 = 1;%5;
        div8 = 1;%3;
        div7 = 1;%2;
    case 'M333'
        div9 = 5;
        div8 = 2;
        div7 = 2;
    case 'M3'
        div9 = 1;
        div8 = 1;
        div7 = 1;
    case 'M22'
        div9 = 1;
        div8 = 1;
        div7 = 1;
    case 'M3test'
        div9 = 1;
        div8 = 2;
        div7 = 1;   
    case 'M4'
        div9 = 2;
        div8 = 2;
        div7 = 2; 
    case 'M2'
        div9 = 1;
        div8 = 1;
        div7 = 1;
end

estrato10.div = 1;
estrato9.div = 1*div9;
estrato8.div = 1*div8;
estrato7.div = 1*div7;    
estrato6.div = 1*div9;
estrato5.div = 1*div9;
estrato4.div = 1;
estrato3.div = 1;
estrato2.div = 1;
estrato1.div = 1;

estrato10.size = (d_estrato_10)/estrato10.div;
estrato9.size = (d_estrato_9 - d_estrato_10)/estrato9.div;
estrato8.size = (d_estrato_8 - d_estrato_9)/estrato8.div;
estrato7.size = (d_estrato_7 - d_estrato_8)/estrato7.div;
estrato6.size = (d_estrato_6 - d_estrato_7)/estrato6.div;
estrato5.size = (d_estrato_5 - d_estrato_6)/estrato5.div;
estrato4.size = (d_estrato_4 - d_estrato_5)/estrato4.div;
estrato3.size = (d_estrato_3 - d_estrato_4)/estrato3.div;
estrato2.size = (d_estrato_2 - d_estrato_3)/estrato2.div;
estrato1.size = (d_estrato_1 - d_estrato_2)/estrato1.div;

% elementsEstratos: funcion que devuelve los elementos que hay en cada
% estrato
setting = '2';
[ele_strat10,ele_strat9,ele_strat8,ele_strat7,ele_strat6,ele_strat5,ele_strat4,ele_strat3,ele_strat2,ele_strat1] = elementsEstratos(nel,nodes,elements,nnodel,d_estrato_10,d_estrato_9,d_estrato_8,d_estrato_7,d_estrato_6,d_estrato_5,d_estrato_4,d_estrato_3,d_estrato_2,d_estrato_1,setting);


%% Propiedades constitutivas del estrato 10

[ C_1, C_2, C_3, C_4, C_5, C_6, C_7, C_8, C_9, C_10] = propiedades_constitutivas;

%% Armamos las matrices de rigidez de cada estrato [K_10, K_9, K_8,....., K_1]

% Gauss

GP   = 1/sqrt(3);
% % GP = 1;
% % Ubicaciones puntos de Gauss

upg = [  GP   GP   GP
        -GP   GP   GP
        -GP  -GP   GP 
         GP  -GP   GP  
         GP   GP  -GP
        -GP   GP  -GP
        -GP  -GP  -GP 
         GP  -GP  -GP ]; 

npg = size(upg,1);
wpg = ones(npg,1);

%% [K_10] Estrato 10

nodeDofs  = reshape(1:ndoftot,ndof,nnod)';
K         = sparse(ndoftot,ndoftot);
nel_10    = size(ele_strat10,1);
ndofel_10 = nnodel*ndof;

[ aux1, aux2, aux3, aux4, aux5, aux6, aux7, aux8, aux9, aux10] = auxiliares(nnod,d_estrato_10,d_estrato_9,d_estrato_8,d_estrato_7, d_estrato_6, d_estrato_5, d_estrato_4, d_estrato_3, d_estrato_2,d_estrato_1, nodes);

nodes_strat10                          =  nodes(aux10,:);
ndoftot_10                             =  sum(aux10)*ndof;
% nnod_10 = size(nodes_strat10,1);

[row_10, col_10, nodesEle_10] = get_mapping_strat(nel_10,nodeDofs,ele_strat10,nodes,ndofel,nnodel,ndof);

fcn = @plus;

for iele = 1:nel_10
    Ke_10       =   element_stiffness(npg,upg,nodesEle_10(:,:,iele),C_10,ndofel,wpg,ndof);
    [ROW, COL]  =   get_map(row_10(:,:,iele),col_10(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_10,ndoftot,ndoftot));
end

%% [K_9] Estrato 9

nel_9                                  =  size(ele_strat9,1);
ndofel_9                               =  nnodel*ndof;
ndoftot_9                              =  sum(aux9)*ndof;

nodes_strat9 = nodes(aux9,:);

[row_9, col_9, nodesEle_9] = get_mapping_strat(nel_9,nodeDofs,ele_strat9,nodes,ndofel,nnodel,ndof);

for iele = 1:nel_9
    Ke_9        =   element_stiffness(npg,upg,nodesEle_9(:,:,iele),C_9,ndofel,wpg,ndof);
    [ROW, COL]  =   get_map(row_9(:,:,iele),col_9(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_9,ndoftot,ndoftot));
end
    

%% [K_8] Estrato 8


ndoftot_8 = sum(aux8)*ndof;

nel_8 = size(ele_strat8,1);
ndofel_8 = nnodel*ndof;

nodes_strat8 = nodes(aux8,:);
nnod_8 = size(nodes_strat8,1);

[row_8, col_8, nodesEle_8] = get_mapping_strat(nel_8,nodeDofs,ele_strat8,nodes,ndofel,nnodel,ndof);

for iele = 1:nel_8
    Ke_8        =   element_stiffness(npg,upg,nodesEle_8(:,:,iele),C_8,ndofel,wpg,ndof);
    [ROW, COL]  =   get_map(row_8(:,:,iele),col_8(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_8,ndoftot,ndoftot));
end


%% [K_7] Estrato 7

ndoftot_7 = sum(aux7)*ndof;

nel_7 = size(ele_strat7,1);
ndofel_7 = nnodel*ndof;

nodes_strat7 = nodes(aux7,:);
nnod_7 = size(nodes_strat7,1);

[row_7, col_7, nodesEle_7] = get_mapping_strat(nel_7,nodeDofs,ele_strat7,nodes,ndofel,nnodel,ndof);

for iele = 1:nel_7
    Ke_7        =   element_stiffness(npg,upg,nodesEle_7(:,:,iele),C_7,ndofel,wpg,ndof);
    [ROW, COL]  =   get_map(row_7(:,:,iele),col_7(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_7,ndoftot,ndoftot));
end

%% [K_6] Estrato 6

ndoftot_6 = sum(aux6)*ndof;

nel_6 = size(ele_strat6,1);
ndofel_6 = nnodel*ndof;

nodes_strat6 = nodes(aux6,:);
nnod_6 = size(nodes_strat6,1);

[row_6, col_6, nodesEle_6] = get_mapping_strat(nel_6,nodeDofs,ele_strat6,nodes,ndofel,nnodel,ndof);

for iele = 1:nel_6
    Ke_6        =   element_stiffness(npg,upg,nodesEle_6(:,:,iele),C_6,ndofel,wpg,ndof);
    [ROW, COL]  =   get_map(row_6(:,:,iele),col_6(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_6,ndoftot,ndoftot));
end

%% [K_5] Estrato 5

ndoftot_5 = sum(aux5)*ndof;

nel_5 = size(ele_strat5,1);
ndofel_5 = nnodel*ndof;

nodes_strat5 = nodes(aux5,:);
nnod_5 = size(nodes_strat5,1);

[row_5, col_5, nodesEle_5] = get_mapping_strat(nel_5,nodeDofs,ele_strat5,nodes,ndofel,nnodel,ndof);

for iele = 1:nel_5
    Ke_5        =   element_stiffness(npg,upg,nodesEle_5(:,:,iele),C_5,ndofel,wpg,ndof);
    [ROW, COL]  =   get_map(row_5(:,:,iele),col_5(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_5,ndoftot,ndoftot));
end

%% [K_4] Estrato 4

ndoftot_4 = sum(aux4)*ndof;

nel_4 = size(ele_strat4,1);
ndofel_4 = nnodel*ndof;

nodes_strat4 = nodes(aux4,:);
nnod_4 = size(nodes_strat4,1);

[row_4, col_4, nodesEle_4] = get_mapping_strat(nel_4,nodeDofs,ele_strat4,nodes,ndofel,nnodel,ndof);

for iele = 1:nel_4
    Ke_4        =   element_stiffness(npg,upg,nodesEle_4(:,:,iele),C_4,ndofel,wpg,ndof);
    [ROW, COL]  =   get_map(row_4(:,:,iele),col_4(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_4,ndoftot,ndoftot));
end

%% [K_3] Estrato 3

ndoftot_3 = sum(aux3)*ndof;

nel_3 = size(ele_strat3,1);
ndofel_3 = nnodel*ndof;

nodes_strat3 = nodes(aux3,:);
nnod_3 = size(nodes_strat3,1);

[row_3, col_3, nodesEle_3] = get_mapping_strat(nel_3,nodeDofs,ele_strat3,nodes,ndofel,nnodel,ndof);

for iele = 1:nel_3
    Ke_3        =   element_stiffness(npg,upg,nodesEle_3(:,:,iele),C_3,ndofel,wpg,ndof);
    [ROW, COL]  =   get_map(row_3(:,:,iele),col_3(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_3,ndoftot,ndoftot));
end


%% [K_2] Estrato 2

ndoftot_2 = sum(aux2)*ndof;

nel_2 = size(ele_strat2,1);
ndofel_2 = nnodel*ndof;

nodes_strat2 = nodes(aux2,:);
nnod_2 = size(nodes_strat2,1);

[row_2, col_2, nodesEle_2] = get_mapping_strat(nel_2,nodeDofs,ele_strat2,nodes,ndofel,nnodel,ndof);

for iele = 1:nel_2
    Ke_2        =   element_stiffness(npg,upg,nodesEle_2(:,:,iele),C_2,ndofel,wpg,ndof);
    [ROW, COL]  =   get_map(row_2(:,:,iele),col_2(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_2,ndoftot,ndoftot));
end


%% [K_1] Estrato 1

ndoftot_1 = sum(aux1)*ndof;

nel_1 = size(ele_strat1,1);
ndofel_1 = nnodel*ndof;

nodes_strat1 = nodes(aux1,:);
nnod_1 = size(nodes_strat1,1);

[row_1, col_1, nodesEle_1] = get_mapping_strat(nel_1,nodeDofs,ele_strat1,nodes,ndofel,nnodel,ndof);

for iele = 1:nel_1
    Ke_1        =   element_stiffness(npg,upg,nodesEle_1(:,:,iele),C_1,ndofel,wpg,ndof);
    [ROW, COL]  =   get_map(row_1(:,:,iele),col_1(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_1,ndoftot,ndoftot));
end

%% -------------------------------------- Hay que ensamblar los resortes que arman al flan -----------------------------------
disp('Ver rigidez del suelo....')
disp('Ver rigidez para las caras...')

% nodes_tot = [ nodes
%               nodes2_Base
%               nodes2_West
%               nodes2_East
%               nodes2_South
%               nodes2_North
%               nodes2_Top  ];     % incluye los nodos agregados para armar el "flan"
          
E_resorteB = 1e9; 
E_resorteEW = 1e7;
E_resorteSN = 1e7;
E_resorteTop = 1e7;%1e4;

A_resorte = 1e3;
% % figure (1)
% % spy(K)

% ---------------------------------------- Como las rigideces de los
% resortes son distintas, primero ensamblamos los resortes que estan dentro
% de la base, luego los de los bordes y por último los 4 de las esquinas

h1 = nodes_tot(elements_resortes(1:nNodBase,2),1)>0;
h2 = nodes_tot(elements_resortes(1:nNodBase,2),2)>0;
h3 = nodes_tot(elements_resortes(1:nNodBase,2),2)<400;
h4 = nodes_tot(elements_resortes(1:nNodBase,2),1)<400;

DD1 = false(nNodBase,1);

for i=1:nNodBase
    if h1(i)==true && h2(i)==true && h3(i)==true && h4(i)==true
        DD1(i)=true;  % vector logico para encontrar los nodos internos de la base
    end
end

vectorAyuda = 1:nNodBase;
iNOD = vectorAyuda(DD1)';
nNOD_INT = size(iNOD,1);

h5 = nodes_tot(elements_resortes(1:nNodBase,2),1)==0;
h6 = nodes_tot(elements_resortes(1:nNodBase,2),2)==0;
h7 = nodes_tot(elements_resortes(1:nNodBase,2),2)==400;
h8 = nodes_tot(elements_resortes(1:nNodBase,2),1)==400;

DD2 = false(nNodBase,1); % Nodos de las esquinas

for i=1:nNodBase
    if h5(i)==true && h6(i)==true 
        DD2(i)=true; 
    end
    if h8(i)==true && h6(i)==true 
        DD2(i)=true;
    end
    if h5(i)==true && h7(i)==true 
        DD2(i)=true;
    end
    if h7(i)==true && h8(i)==true 
        DD2(i)=true;  
    end
end

iNOD2 = vectorAyuda(DD2)';
nNOD_esq = size(iNOD2,1);

DD3 = false(nNodBase,1); % Nodos de los bordes exceptuando las esquinas

for i=1:nNodBase
    if DD1(i)==false && DD2(i)==false
        DD3(i)=true;
    end
end

iNOD3 = vectorAyuda(DD3)';
nNOD_bordes = size(iNOD3,1);

% Primero ensamblamos los resortes de la base... Nodos internos

nnodel_s = 2;
ndofel_s = nnodel_s*ndof;
[row,col] = get_mapping_spring(nNOD_INT, iNOD, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_INT
    iele                        =  iNOD(i);
    [ke_resorteBase, ke_s]      =  k_spring(iele,nodes_tot,elements_resortes,E_resorteB,A_resorte);
    ke_resorteBase([1 4],[1 4]) =  0.01*ke_s;      % Le doy ua rigidez porcentual en x e y respecto de la dirección z, que es el eje de acción del resorte
    ke_resorteBase([2 5],[2 5]) =  0.01*ke_s;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteBase,ndoftot,ndoftot));    
end

% ----------------------------------------- Resortes en las esquinas

[row,col] = get_mapping_spring(nNOD_esq, iNOD2, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_esq
    iele = iNOD2(i);  
    [ke_resorteBase, ke_s]      =  k_spring(iele,nodes_tot,elements_resortes,E_resorteB,A_resorte);    
    ke_resorteBase([1 4],[1 4]) =  0.01*ke_s;   % Le doy ua rigidez porcentual en x e y respecto de la dirección z, que es el eje de acción del resorte
    ke_resorteBase([2 5],[2 5]) =  0.01*ke_s;
    ke_resorteBase              =  0.25*ke_resorteBase;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteBase,ndoftot,ndoftot));  
end
% ----------------------------------------- Resortes en los bordes

[row,col] = get_mapping_spring(nNOD_bordes, iNOD3, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_bordes
    iele = iNOD3(i);
    [ke_resorteBase, ke_s]      =  k_spring(iele,nodes_tot,elements_resortes,E_resorteB,A_resorte);    
    ke_resorteBase([1 4],[1 4]) =  0.01*ke_s;   
    ke_resorteBase([2 5],[2 5]) =  0.01*ke_s;
    ke_resorteBase              =  0.5*ke_resorteBase;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteBase,ndoftot,ndoftot));  
end


% Ensamblamos los resortes de la cara West e East
% Nodos internos

cont1_elementosWE = 1+nNodBase;
cont2_elementosWE = (nNodBase+nNodWest+nNodEast);

Cont_elementosWE = cont1_elementosWE:cont2_elementosWE;


h9 = nodes_tot(elements_resortes(Cont_elementosWE,2),3)>0;
h10 = nodes_tot(elements_resortes(Cont_elementosWE,2),2)>0;
h11 = nodes_tot(elements_resortes(Cont_elementosWE,2),2)<400;
h12 = nodes_tot(elements_resortes(Cont_elementosWE,2),3)<80;

DD4 = false(size(Cont_elementosWE,2),1);

for i=1:size(Cont_elementosWE,2)
    if h9(i)==true && h10(i)==true && h11(i)==true && h12(i)==true
        DD4(i)=true;  % vector logico para encontrar los nodos internos de las caras west east
    end
end

vectorAyuda2 = Cont_elementosWE;
iNODWE = vectorAyuda2(DD4)';
nNOD_INTWE = size(iNODWE,1);

h13 = nodes_tot(elements_resortes(Cont_elementosWE,2),3)==0;
h14 = nodes_tot(elements_resortes(Cont_elementosWE,2),2)==0;
h15 = nodes_tot(elements_resortes(Cont_elementosWE,2),2)==400;
h16 = nodes_tot(elements_resortes(Cont_elementosWE,2),3)==80;

DD5 = false(size(Cont_elementosWE,2),1); % Nodos de las esquinas

for i=1:size(Cont_elementosWE,2)
    if h13(i)==true && h14(i)==true 
        DD5(i)=true;  
    end
    if h15(i)==true && h13(i)==true 
        DD5(i)=true;  
    end
    if h14(i)==true && h16(i)==true 
        DD5(i)=true; 
    end
    if h15(i)==true && h16(i)==true 
        DD5(i)=true;  
    end
end

iNODWE2 = vectorAyuda2(DD5)';
nNOD_esqWE = size(iNODWE2,1);

DD6 = false(size(Cont_elementosWE,2),1); % Nodos de los bordes exceptuando las esquinas

for i=1:size(Cont_elementosWE,2)
    if DD4(i)==false && DD5(i)==false
        DD6(i)=true;
    end
end

iNODWE3 = vectorAyuda2(DD6)';
nNOD_bordesWE = size(iNODWE3,1);


[row,col] = get_mapping_spring(nNOD_INTWE, iNODWE, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_INTWE
    iele = iNODWE(i);
    [ke_resorteEW, ke_s]        =  k_spring(iele,nodes_tot,elements_resortes,E_resorteEW,A_resorte);    
    ke_resorteEW([3 6],[3 6])   =  0.01*ke_s;   
    ke_resorteEW([2 5],[2 5])   =  0.01*ke_s;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteEW,ndoftot,ndoftot));   
end

[row,col] = get_mapping_spring(nNOD_esqWE, iNODWE2, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_esqWE
    iele = iNODWE2(i);
    [ke_resorteEW, ke_s]        =  k_spring(iele,nodes_tot,elements_resortes,E_resorteEW,A_resorte);    
    ke_resorteEW([3 6],[3 6])   =  0.01*ke_s;   
    ke_resorteEW([2 5],[2 5])   =  0.01*ke_s;
    ke_resorteEW                =  0.25*ke_resorteEW;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteEW,ndoftot,ndoftot)); 
end

[row,col] = get_mapping_spring(nNOD_bordesWE, iNODWE3, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_bordesWE
    iele = iNODWE3(i);
    [ke_resorteEW, ke_s]        =  k_spring(iele,nodes_tot,elements_resortes,E_resorteEW,A_resorte);    
    ke_resorteEW([3 6],[3 6])   =  0.01*ke_s;   
    ke_resorteEW([2 5],[2 5])   =  0.01*ke_s;
    ke_resorteEW                =  0.5*ke_resorteEW;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteEW,ndoftot,ndoftot)); 
end

% Ensamblamos los resortes de la cara North y South

% Nodos internos

cont1_elementosNS = 1+(nNodBase+nNodWest+nNodEast);
cont2_elementosNS = (nNodBase+nNodWest+nNodEast+nNodSouth+nNodNorth);

Cont_elementosNS = cont1_elementosNS:cont2_elementosNS;


h17 = nodes_tot(elements_resortes(Cont_elementosNS,2),3)>0;
h18 = nodes_tot(elements_resortes(Cont_elementosNS,2),1)>0;
h19 = nodes_tot(elements_resortes(Cont_elementosNS,2),1)<400;
h20 = nodes_tot(elements_resortes(Cont_elementosNS,2),3)<80;

DD7 = false(size(Cont_elementosNS,2),1);

for i=1:size(Cont_elementosNS,2)
    if h17(i)==true && h18(i)==true && h19(i)==true && h20(i)==true
        DD7(i)=true;  % vector logico para encontrar los nodos internos de las caras North-South
    end
end

vectorAyuda3 = Cont_elementosNS;
iNODNS = vectorAyuda3(DD7)';
nNOD_INTNS = size(iNODNS,1);

h21 = nodes_tot(elements_resortes(Cont_elementosNS,2),3)==0;
h22 = nodes_tot(elements_resortes(Cont_elementosNS,2),1)==0;
h23 = nodes_tot(elements_resortes(Cont_elementosNS,2),1)==400;
h24 = nodes_tot(elements_resortes(Cont_elementosNS,2),3)==80;

DD8 = false(size(Cont_elementosNS,2),1); % Nodos de las esquinas

for i=1:size(Cont_elementosNS,2)
    if h21(i)==true && h22(i)==true 
        DD8(i)=true;  
    end
    if h22(i)==true && h24(i)==true 
        DD8(i)=true;  
    end
    if h23(i)==true && h21(i)==true 
        DD8(i)=true; 
    end
    if h23(i)==true && h24(i)==true 
        DD8(i)=true;  
    end
end

iNODNS2 = vectorAyuda3(DD8)';
nNOD_esqNS = size(iNODNS2,1);

DD9 = false(size(Cont_elementosNS,2),1); % Nodos de los bordes exceptuando las esquinas

for i=1:size(Cont_elementosNS,2)
    if DD7(i)==false && DD8(i)==false
        DD9(i)=true;
    end
end

iNODNS3 = vectorAyuda3(DD9)';
nNOD_bordesNS = size(iNODNS3,1);

[row,col] = get_mapping_spring(nNOD_INTNS, iNODNS, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_INTNS
    iele = iNODNS(i);
    [ke_resorteSN, ke_s]        =  k_spring(iele,nodes_tot,elements_resortes,E_resorteSN,A_resorte);    
    ke_resorteSN([3 6],[3 6])   =  0.01*ke_s;   
    ke_resorteSN([1 4],[1 4])   =  0.01*ke_s;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteSN,ndoftot,ndoftot)); 
end

[row,col] = get_mapping_spring(nNOD_esqNS, iNODNS2, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_esqNS
    iele = iNODNS2(i);
    [ke_resorteSN, ke_s]        =  k_spring(iele,nodes_tot,elements_resortes,E_resorteSN,A_resorte);        
    ke_resorteSN([3 6],[3 6])   =  0.01*ke_s;   
    ke_resorteSN([1 4],[1 4])   =  0.01*ke_s;
    ke_resorteSN                =  0.25*ke_resorteSN;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteSN,ndoftot,ndoftot)); 
end

[row,col] = get_mapping_spring(nNOD_bordesNS, iNODNS3, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_bordesNS
    iele = iNODNS3(i);
    [ke_resorteSN, ke_s]        =  k_spring(iele,nodes_tot,elements_resortes,E_resorteSN,A_resorte);         
    ke_resorteSN([3 6],[3 6])   =  0.01*ke_s;   
    ke_resorteSN([1 4],[1 4])   =  0.01*ke_s;
    ke_resorteSN                =  0.5*ke_resorteSN;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteSN,ndoftot,ndoftot)); 
end

% Ensamblamos la cara Top.. (z=80)

cont1_elementosT = 1+(nNodBase+nNodWest+nNodEast+nNodSouth+nNodNorth);
cont2_elementosT = size(elements_resortes,1);

Cont_elementosT = cont1_elementosT:cont2_elementosT;

vectorAyuda4 = Cont_elementosT;
iNODT = vectorAyuda4(DD1)';
nNOD_INTtop = size(iNODT,1);  % resortes internos

iNODT2 = vectorAyuda4(DD2)';
nNOD_esqTop = size(iNODT2,1);  % resortes en las esquinas

iNODT3 = vectorAyuda4(DD3)';
nNOD_bordesTop = size(iNODT3,1);  % resortes en los bordes

[row,col] = get_mapping_spring(nNOD_INTtop, iNODT, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_INTtop
    iele = iNODT(i);
    [ke_resorteTop, ke_s]       =  k_spring(iele,nodes_tot,elements_resortes,E_resorteTop,A_resorte);         
    ke_resorteTop([1 4],[1 4])  =  0.01*ke_s;  
    ke_resorteTop([2 5],[2 5])  =  0.01*ke_s;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteTop,ndoftot,ndoftot));    
end

[row,col] = get_mapping_spring(nNOD_esqTop, iNODT2, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_esqTop
    iele = iNODT2(i);
    [ke_resorteTop, ke_s]       =  k_spring(iele,nodes_tot,elements_resortes,E_resorteTop,A_resorte);         
    ke_resorteTop([1 4],[1 4])  =  0.01*ke_s;  
    ke_resorteTop([2 5],[2 5])  =  0.01*ke_s;
    ke_resorteTop               =  0.25*ke_resorteTop;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteTop,ndoftot,ndoftot)); 
end

[row,col] = get_mapping_spring(nNOD_bordesTop, iNODT3, nodeDofs,elements_resortes,ndofel_s);

for i = 1:nNOD_bordesTop
    iele = iNODT3(i);
    [ke_resorteTop, ke_s]       =  k_spring(iele,nodes_tot,elements_resortes,E_resorteTop,A_resorte);         
    ke_resorteTop([1 4],[1 4])  =  0.01*ke_s;  
    ke_resorteTop([2 5],[2 5])  =  0.01*ke_s;
    ke_resorteTop               =  0.5*ke_resorteTop;
    [ROW, COL]                  =  get_map(row(:,:,i),col(:,:,i));
    K                           =  fcn(K,sparse(ROW,COL,ke_resorteTop,ndoftot,ndoftot));     
end

% % figure(2)
end
toc
%% --------------------------------  Elements Barra

for Resumir = 1
stirr1 = nodes(ele_fisu1_y1_1(:,1),2)<100;
eles1 = ele_fisu1_y1_1(stirr1,:);
nodos1_fisu1 = eles1(:,1);    %% Me daría los nodos 1 de todas las barras que van en la fisura 1 del lado negativo (y-)
norma1_1 = zeros(length(nodos1_fisu1),1);  
for i=1:length(nodos1_fisu1)
    norma1_1(i,1) = norm([nodes(nodos1_fisu1(i),1) nodes(nodos1_fisu1(i),3)]);
end
[~,orden1_1]=sort(norma1_1);
nodos1_fisu1 = nodos1_fisu1(orden1_1);

stirr2 = nodes(ele_fisu1_y1_2(:,4),2)>100;
eles2 = ele_fisu1_y1_2(stirr2,:);
nodos2_fisu1 = eles2(:,4);                                  %% Idem aa, pero este me devuelve el nodo 2 de las barras, estaría ubicado en la fisura 1 del lado positivo (y+)
norma1_2 = zeros(length(nodos2_fisu1),1);
for i=1:length(nodos2_fisu1)
    norma1_2(i,1)=norm([nodes(nodos2_fisu1(i),1) nodes(nodos2_fisu1(i),3)]);
end
[~,orden1_2]=sort(norma1_2);
nodos2_fisu1=nodos2_fisu1(orden1_2);

stirr3 = nodes(ele_fisu2_y2_1(:,1),2)<200;
eles3 = ele_fisu2_y2_1(stirr3,:);
nodos1_fisu2 = eles3(:,1);                                  %% Me daría los nodos 1 de todas las barras que van en la fisura 2 del lado negativo (y-)
norma2_1 = zeros(length(nodos1_fisu2),1);
for i=1:length(nodos1_fisu2)
    norma2_1(i,1)=norm([nodes(nodos1_fisu2(i),1) nodes(nodos1_fisu2(i),3)]);
end
[~,orden2_1]=sort(norma2_1);
nodos1_fisu2=nodos1_fisu2(orden2_1);

stirr4 = nodes(ele_fisu2_y2_2(:,4),2)>200;
eles4 = ele_fisu2_y2_2(stirr4,:);
nodos2_fisu2 = eles4(:,4);                                  %% Idem cc, pero este me devuelve el nodo 2 de las barras, estaría ubicado en la fisura 2 del lado positivo (y+)
norma2_2 = zeros(length(nodos2_fisu2),1);
for i=1:length(nodos2_fisu2)
    norma2_2(i,1)=norm([nodes(nodos2_fisu2(i),1) nodes(nodos2_fisu2(i),3)]);
end
[~,orden2_2]=sort(norma2_2);
nodos2_fisu2=nodos2_fisu2(orden2_2);

stirr5 = nodes(ele_fisu3_y3_1(:,1),2)<300;
eles5 = ele_fisu3_y3_1(stirr5,:);
nodos1_fisu3 = eles5(:,1);                                  %% Me daría los nodos 1 de todas las barras que van en la fisura 3 del lado negativo (y-)
norma3_1 = zeros(length(nodos1_fisu3),1);
for i=1:length(nodos1_fisu3)
    norma3_1(i,1)=norm([nodes(nodos1_fisu3(i),1) nodes(nodos1_fisu3(i),3)]);
end
[~,orden3_1]=sort(norma3_1);
nodos1_fisu3=nodos1_fisu3(orden3_1);

stirr6 = nodes(ele_fisu3_y3_2(:,4),2)>300;
eles6 = ele_fisu3_y3_2(stirr6,:);
nodos2_fisu3 = eles6(:,4);                                  %% Idem ff, pero este me devuelve el nodo 2 de las barras, estaría ubicado en la fisura 3 del lado positivo (y+)
norma3_2 = zeros(length(nodos2_fisu3),1);
for i=1:length(nodos2_fisu3)
    norma3_2(i,1)=norm([nodes(nodos2_fisu3(i),1) nodes(nodos2_fisu3(i),3)]);
end
[~,orden3_2]=sort(norma3_2);
nodos2_fisu3=nodos2_fisu3(orden3_2);
end
clear basura

disp('Hay un problema con los elements barra, el tema es que estan desordenados, ')
disp('entonces el elements barra no agarra el nodo enfrentado, sino que agarra')
disp('cualquiera, eso pasa porque mi refinador (unAdinaPiola) no tira todos los')
disp('nodos ordenados lindos, sino que los tira de cualquier forma, comente lo que')
disp('propuse para ordenarlos pero eso no se porque hace que no habra ninguna fisura,')
disp('en cambio si lo dejo como esta el problema es que se caga el gap1 (no entiendo')
disp('bien por que se caga), la cosa es, si arreglamos esto va como piña (cuando se')
disp('arregle el elements barra descomentar la linea del programa posicionFisura)')
disp(' ')
disp('En la carpeta Malla1-> MAPA casi termine mi refinador, ahi podes ver los')
disp('elementos tipo 5 a 8, le falta agregar los tipo 3 y 4 pero eso es rapido')
disp('...')
disp('...')
disp('Ya lo arregle gil!')

%% Opcion Pablote

elements_Barra = [ nodos1_fisu1  nodos2_fisu1
                   nodos1_fisu2  nodos2_fisu2
                   nodos1_fisu3  nodos2_fisu3];             %% Falta ordenar correctamente para obtener el nodo enfrentado
               
elements_Barra_fisu1 = [ nodos1_fisu1  nodos2_fisu1];
elements_Barra_fisu2 = [ nodos1_fisu2  nodos2_fisu2];
elements_Barra_fisu3 = [ nodos1_fisu3  nodos2_fisu3];   

nelSpringFisura1 = size(elements_Barra_fisu1,1);
nelSpringFisura2 = size(elements_Barra_fisu2,1);
nelSpringFisura3 = size(elements_Barra_fisu3,1);
ndofel_b = 4;

% E_Barra = [-1e15 3e7 -2e4 0];
% [row, col] = get_mapping_barra(nelSpringFisura1,nodeDofs,elements_Barra_fisu1,ndofel_b);
% 
% for iele = 1:nelSpringFisura1
%      ke_Barra       =  k_barra(iele,nodes,elements_Barra_fisu1,E_B,A_Barra);
%      [ROW, COL]     =  get_map(row(:,:,iele),col(:,:,iele));
%      Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
% end
% % 
% %  K_NEW = [   Kb        -C_g
% %              C_g'      (S + (tita*deltaT)*KC)  ];

nelB = size(elements_Barra,1);    

clear ele_fisu1_1 ele_fisu1_y1_1 sizeFisu1_1 ele_fisu1_2 ele_fisu1_y1_2 sizeFisu1_2
clear ele_fisu2_1 ele_fisu2_y2_1 sizeFisu2_1 ele_fisu2_2 ele_fisu2_y2_2 sizeFisu2_2
clear ele_fisu3_1 ele_fisu3_y3_1 sizeFisu3_1 ele_fisu3_2 ele_fisu3_y3_2 sizeFisu3_2


%% Nuevas areas de fractura
for RESUMIR = 1
ele_fisu1_1 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),1);
    j = nodes(elements(iele,:),2);
    k = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if j(inod) < 99.99 && j(inod)> 98 && i(inod)==200 && k(inod) == d_estrato_7
            ele_fisu1_1(iele) = true;
        end
    end
end

ele_fisu1_y1_1 = elements(ele_fisu1_1,:);
sizeFisu1_1 = size(ele_fisu1_y1_1,1);

ele_fisu1_2 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),1);
    j = nodes(elements(iele,:),2);
    k = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if j(inod) > 100 && j(inod)<102 && i(inod)==200 && k(inod) == d_estrato_7
            ele_fisu1_2(iele) = true;        
        end
    end
end

ele_fisu1_y1_2 = elements(ele_fisu1_2,:);
sizeFisu1_2 = size(ele_fisu1_y1_2,1);

ele_fisu2_1 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),1);
    j = nodes(elements(iele,:),2);
    k = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if j(inod) < 199.99 && j(inod)>198 && i(inod)==200 && k(inod)==d_estrato_7
            ele_fisu2_1(iele) = true;
        end
    end
end

ele_fisu2_y2_1 = elements(ele_fisu2_1,:);
sizeFisu2_1 = size(ele_fisu2_y2_1,1);

ele_fisu2_2 = false(nel,1);

for iele = 1:nel    
    i = nodes(elements(iele,:),1);
    j = nodes(elements(iele,:),2);
    k = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if j(inod) > 200 && j(inod)<202 && i(inod)==200 && k(inod) == d_estrato_7
            ele_fisu2_2(iele) = true;
        end
    end
end

ele_fisu2_y2_2 = elements(ele_fisu2_2,:);
sizeFisu2_2 = size(ele_fisu2_y2_2,1);

% Nos devuelve los elementos que estan en la coordenada y = 300-

ele_fisu3_1 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),1);
    j = nodes(elements(iele,:),2);
    k = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if j(inod) < 299.99 && j(inod)>298 && i(inod)==200 && k(inod) == d_estrato_7
            ele_fisu3_1(iele) = true;
        end
    end
end

ele_fisu3_y3_1 = elements(ele_fisu3_1,:);
sizeFisu3_1 = size(ele_fisu3_y3_1,1);

% Nos devuelve los elementos que estan en la coordenada y = 300+

ele_fisu3_2 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),1);
    j = nodes(elements(iele,:),2);
    k = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if j(inod) > 300 && j(inod)<302 && i(inod)==200 && k(inod) == d_estrato_7
            ele_fisu3_2(iele) = true;
        end
    end
end

ele_fisu3_y3_2 = elements(ele_fisu3_2,:);
sizeFisu3_2 = size(ele_fisu3_y3_2,1);

end

%% Ordenamos los nodos del Elements Barra pero ahora solo las correspondientes a la nueva area de fractura
for Resumir=1
fisura1.auxiliar1 = reshape(ele_fisu1_y1_1,1,[])';
fisura1.nodoPosicion1 = fisura1.auxiliar1(nodes(fisura1.auxiliar1,2)>99.95);
nodos1_fisu1 = unique(fisura1.nodoPosicion1);             %% Me daría los nodos 1 de todas las barras que van en la fisura 1 del lado negativo (y-) %%INTERVENCION NACHO!!!!!!!! Comentar/Descomentar
norma1_1 = zeros(length(nodos1_fisu1),1);  
for i=1:length(nodos1_fisu1)
    norma1_1(i,1) = norm([nodes(nodos1_fisu1(i),1) nodes(nodos1_fisu1(i),3)]);
end
[~,orden1_1]=sort(norma1_1);
nodos1_fisu1=nodos1_fisu1(orden1_1);

fisura1.auxiliar2 = reshape(ele_fisu1_y1_2,1,[])';        
fisura1.nodoPosicion2 = fisura1.auxiliar2(nodes(fisura1.auxiliar2,2)<100.05);
nodos2_fisu1 = unique(fisura1.nodoPosicion2);             %% Idem aa, pero este me devuelve el nodo 2 de las barras, estaría ubicado en la fisura 1 del lado positivo (y+)  %%INTERVENCION NACHO!!!!!!!! Comentar/Descomentar
norma1_2 = zeros(length(nodos2_fisu1),1);
for i=1:length(nodos2_fisu1)
    norma1_2(i,1)=norm([nodes(nodos2_fisu1(i),1) nodes(nodos2_fisu1(i),3)]);
end
[~,orden1_2]=sort(norma1_2);
nodos2_fisu1=nodos2_fisu1(orden1_2);


fisura2.auxiliar1 = reshape(ele_fisu2_y2_1,1,[])';
fisura2.nodoPosicion1 = fisura2.auxiliar1(nodes(fisura2.auxiliar1,2)>199.95);
nodos1_fisu2 = unique(fisura2.nodoPosicion1);             %% Me daría los nodos 1 de todas las barras que van en la fisura 2 del lado negativo (y-) %%INTERVENCION NACHO!!!!!!!! Comentar/Descomentar
norma2_1 = zeros(length(nodos1_fisu2),1);
for i=1:length(nodos1_fisu2)
    norma2_1(i,1)=norm([nodes(nodos1_fisu2(i),1) nodes(nodos1_fisu2(i),3)]);
end
[~,orden2_1]=sort(norma2_1);
nodos1_fisu2=nodos1_fisu2(orden2_1);

fisura2.auxiliar2 = reshape(ele_fisu2_y2_2,1,[])';   
fisura2.nodoPosicion2 = fisura2.auxiliar2(nodes(fisura2.auxiliar2,2)<200.05);
nodos2_fisu2 = unique(fisura2.nodoPosicion2);             %% Idem cc, pero este me devuelve el nodo 2 de las barras, estaría ubicado en la fisura 2 del lado positivo (y+) %%INTERVENCION NACHO!!!!!!!! Comentar/Descomentar
norma2_2 = zeros(length(nodos2_fisu2),1);
for i=1:length(nodos2_fisu2)
    norma2_2(i,1)=norm([nodes(nodos2_fisu2(i),1) nodes(nodos2_fisu2(i),3)]);
end
[~,orden2_2]=sort(norma2_2);
nodos2_fisu2=nodos2_fisu2(orden2_2);

fisura3.auxiliar1 = reshape(ele_fisu3_y3_1,1,[])';   
fisura3.nodoPosicion1 = fisura3.auxiliar1(nodes(fisura3.auxiliar1,2)>299.95);
nodos1_fisu3 = unique(fisura3.nodoPosicion1);             %% Me daría los nodos 1 de todas las barras que van en la fisura 3 del lado negativo (y-) %%INTERVENCION NACHO!!!!!!!! Comentar/Descomentar
norma3_1 = zeros(length(nodos1_fisu3),1);
for i=1:length(nodos1_fisu3)
    norma3_1(i,1)=norm([nodes(nodos1_fisu3(i),1) nodes(nodos1_fisu3(i),3)]);
end
[~,orden3_1]=sort(norma3_1);
nodos1_fisu3=nodos1_fisu3(orden3_1);

fisura3.auxiliar2 = reshape(ele_fisu3_y3_2,1,[])';   
fisura3.nodoPosicion2 = fisura3.auxiliar2(nodes(fisura3.auxiliar2,2)<300.05);
nodos2_fisu3 = unique(fisura3.nodoPosicion2);             %% Idem ff, pero este me devuelve el nodo 2 de las barras, estaría ubicado en la fisura 3 del lado positivo (y+) %%INTERVENCION NACHO!!!!!!!! Comentar/Descomentar
norma3_2 = zeros(length(nodos2_fisu3),1);
for i=1:length(nodos2_fisu3)
    norma3_2(i,1)=norm([nodes(nodos2_fisu3(i),1) nodes(nodos2_fisu3(i),3)]);
end
[~,orden3_2]=sort(norma3_2);
nodos2_fisu3=nodos2_fisu3(orden3_2);
end

%% -------------------------------------- Input de tiempo --------------------------------------
tita    = 1;                              % Factor de Crank Nicolson
deltaT  = 3600*24*100;%3600*24*300;%      % Salto temporal, Decia 3600*24*300 MOD NACHO 
nTiempo = deltaT*18*3;%  deltaT*18;%      %Decia deltaT*10 MOD NACHO!
Time    = 0:deltaT:nTiempo;

%% -------------------------------------- Vector de cargas  --------------------------------------

% R = zeros(ndoftot,length(Time));
R = spalloc(ndoftot,1,ndoftot);    % Cargas correspondientes a las insitu stress

%% Resumir vector de cargas (in situ stress)

for RESUMIR=1
    % ---------------------------- Elementos en las CARAS
    %% West Side

    ele_West = false(nel,1);

    for iele = 1:nel
        i = nodes(elements(iele,:),1);
        for inod = 1:nnodel
            if i(inod)==0
               ele_West(iele) = true;
            end
        end
    end

    eleWest = elements(ele_West,:);
    % size(eleWest)

    %% East Side

    ele_East = false(nel,1);

    for iele = 1:nel
        i = nodes(elements(iele,:),1);
        for inod = 1:nnodel
            if i(inod)==400
               ele_East(iele) = true;
            end
        end
    end

    eleEast = elements(ele_East,:);
    % size(eleEast)

    %% South Side

    ele_South = false(nel,1);

    for iele = 1:nel
        i = nodes(elements(iele,:),2);
        for inod = 1:nnodel
            if i(inod)==0
               ele_South(iele) = true;
            end
        end
    end

    eleSouth = elements(ele_South,:);
    % size(eleSouth)

    %% North Side

    ele_North = false(nel,1);

    for iele = 1:nel
        i = nodes(elements(iele,:),2);
        for inod = 1:nnodel
            if i(inod)==400
               ele_North(iele) = true;
            end
        end
    end

    eleNorth = elements(ele_North,:);
    % size(eleNorth)

    %% Bottom Side

    ele_Bottom = false(nel,1);

    for iele = 1:nel
        i = nodes(elements(iele,:),3);
        for inod = 1:nnodel
            if i(inod)==0
               ele_Bottom(iele) = true;
            end
        end
    end

    eleBottom = elements(ele_Bottom,:);
    % size(eleBottom)

    %% Top Side

    ele_Top = false(nel,1);

    for iele = 1:nel
        i = nodes(elements(iele,:),3);
        for inod = 1:nnodel
            if i(inod)==d_estrato_1
               ele_Top(iele) = true;
            end
        end
    end

    eleTop = elements(ele_Top,:);
    % size(eleNorth)


    %% Vector de cargas en la cara West

    % % Ubicaciones puntos de Gauss
    GPw   = 1/sqrt(3);

    upgw = [ -1   GPw    GPw
             -1  -GPw    GPw
             -1   GPw   -GPw
             -1  -GPw   -GPw];

    npgw = size(upgw,1);
    wpgw = ones(npgw,1);

    nelEleWest   = size(eleWest,1);
    nelEleEast   = size(eleEast,1);
    nelEleNorth  = size(eleNorth,1);
    nelEleSouth  = size(eleSouth,1);
    nelEleTop    = size(eleTop,1);
    nelEleBottom = size(eleBottom,1);

    [Row, Col, nodesEle] = get_mapping_el(nelEleWest,nodeDofs,eleWest,nodes,ndofel,nnodel,ndof);
    % [Row, Col, nodesEle] = prueba(nelEleWest,nodeDofs,eleWest,nodes,ndofel,nnodel,ndof,numNodWest,v2);

        for iele = 1:nelEleWest
            re_w = cargas_por_elementoWE(npgw,upgw,wpgw,nodesEle(:,:,iele),ndof,nnodel,p_West,ndofel_1);
            R = fcn(R,sparse(Col(:,1,iele),Row(:,1,iele)',re_w,ndoftot,1));     
        end

        eleDofs_West = nodeDofs(numNodWest',:);
        eleDofs_West = reshape(eleDofs_West',[],1);

        eleDofsH8W = nodeDofs(v2,:);
        eleDofsH8W = reshape(eleDofsH8W',[],1);
    
        R(eleDofs_West) = R(eleDofsH8W); %#ok<SPRIX>
        R(eleDofsH8W) = 0; %#ok<SPRIX>

        %% Vector de cargas en la cara East

        % % Ubicaciones puntos de Gauss
        GPe   = 1/sqrt(3);

        upge = [ 1   GPe    GPe
                 1  -GPe    GPe
                 1   GPe   -GPe
                 1  -GPe   -GPe];

        npge = size(upge,1);
        wpge = ones(npge,1);

        [Row, Col, nodesEle] = get_mapping_el(nelEleEast,nodeDofs,eleEast,nodes,ndofel,nnodel,ndof);

        for iele = 1:nelEleEast
            re_e = cargas_por_elementoWE(npge,upge,wpge,nodesEle(:,:,iele),ndof,nnodel,-p_East,ndofel_1);
            R = fcn(R,sparse(Col(:,1,iele),Row(:,1,iele)',re_e,ndoftot,1)); 
        end

        eleDofs_East = nodeDofs(numNodEast',:);
        eleDofs_East = reshape(eleDofs_East',[],1);
        eleDofsH8E = nodeDofs(v3,:);
        eleDofsH8E = reshape(eleDofsH8E',[],1);

        R(eleDofs_East) = R(eleDofsH8E);    %#ok<SPRIX>
        R(eleDofsH8E)   = 0;                %#ok<SPRIX>

        %% Vector de cargas en la cara South

        % % Ubicaciones puntos de Gauss
        GPs   = 1/sqrt(3);

        upgs = [ GPs    -1    GPs
                -GPs    -1    GPs
                 GPs    -1   -GPs
                -GPs    -1   -GPs];

        npgs = size(upgs,1);
        wpgs = ones(npgs,1);

        [Row, Col, nodesEle] = get_mapping_el(nelEleSouth,nodeDofs,eleSouth,nodes,ndofel,nnodel,ndof);

        for iele = 1:nelEleSouth
            re_s = cargas_por_elementoSN(npgs,upgs,wpgs,nodesEle(:,:,iele),ndof,nnodel,-p_South,ndofel_1);
            R = fcn(R,sparse(Col(:,1,iele),Row(:,1,iele)',re_s,ndoftot,1));    
        end

        eleDofs_South = nodeDofs(numNodSouth',:);
        eleDofs_South = reshape(eleDofs_South',[],1);
        eleDofsH8S = nodeDofs(v4,:);
        eleDofsH8S = reshape(eleDofsH8S',[],1);
% 
        R(eleDofs_South) = R(eleDofsH8S); %#ok<SPRIX>
        R(eleDofsH8S) = 0;                %#ok<SPRIX>

        %% Vector de cargas en la cara North

        % % Ubicaciones puntos de Gauss
        GPn   = 1/sqrt(3);

        upgn = [ GPn    1    GPn
                -GPn    1    GPn
                 GPn    1   -GPn
                -GPn    1   -GPn];

        npgn = size(upgn,1);
        wpgn = ones(npgn,1);

        [Row, Col, nodesEle] = get_mapping_el(nelEleNorth,nodeDofs,eleNorth,nodes,ndofel,nnodel,ndof);

        for iele = 1:nelEleNorth
            re_n = cargas_por_elementoSN(npgn,upgn,wpgn,nodesEle(:,:,iele),ndof,nnodel,p_North,ndofel_1);
            R = fcn(R,sparse(Col(:,1,iele),Row(:,1,iele)',re_n,ndoftot,1));   
        end

        eleDofs_North = nodeDofs(numNodNorth',:);
        eleDofs_North = reshape(eleDofs_North',[],1);
        eleDofsH8N = nodeDofs(v5,:);
        eleDofsH8N = reshape(eleDofsH8N',[],1);

        R(eleDofs_North) = R(eleDofsH8N);  %#ok<SPRIX>
        R(eleDofsH8N) = 0;                 %#ok<SPRIX>
    
    %% Vector de cargas en la cara Top

    % % Ubicaciones puntos de Gauss
    GPt   = 1/sqrt(3);

    upgt = [ GPt    GPt    1 
            -GPt    GPt    1
             GPt   -GPt    1 
            -GPt   -GPt    1];

    npgt = size(upgt,1);
    wpgt = ones(npgt,1);

    [Row, Col, nodesEle] = get_mapping_el(nelEleTop,nodeDofs,eleTop,nodes,ndofel,nnodel,ndof);
        for iele = 1:nelEleTop
            re_t = cargas_por_elementoTB(npgt,upgt,wpgt,nodesEle(:,:,iele),ndof,nnodel,-p_Top,ndofel_1);
            R = fcn(R,sparse(Col(:,1,iele),Row(:,1,iele)',re_t,ndoftot,1));  
        end

        eleDofs_Top = nodeDofs(numNodTop',:);
        eleDofs_Top = reshape(eleDofs_Top',[],1);
        eleDofsH8t = nodeDofs(v6,:);
        eleDofsH8t = reshape(eleDofsH8t',[],1);

        R(eleDofs_Top) = R(eleDofsH8t);   %#ok<SPRIX>
        R(eleDofsH8t) = 0;                %#ok<SPRIX>
end


RTOT = zeros(ndoftot,length(Time));

for itime=1:length(Time)
    RTOT(:,itime) = R;
end


%% --------------------------------------------- Tensor [C] que considera la parte poral
% Vamos a usar las mismas funciones de forma que para el desplazamiento. Es
% decir, Np = [ N1 N2 N3 N4 N5 N6 N7 N8 ]

[Row, Col, nodesEle] = get_mapping_poral(nel,nodeDofs,elements,nodes,ndofel,nnodel,ndof);
C_g = sparse(ndoftot,nNod);

for iele = 1:nel
    C_elemento  =   presionPoral(npg,upg,wpg,nodesEle(:,:,iele),ndof,nnodel,ndofel,Biot);
    [ROW, COL]   =  get_map(Row(:,:,iele),Col(:,:,iele));
    C_g(ROW(1,:),COL(:,1)) = C_g(ROW(1,:),COL(:,1)) + C_elemento;
%     C_g    =   fcn(C_g,sparse(ROW,COL,C_elemento,ndoftot,nNod));
end


%% --------------------------------------------- Tensor [KC] contiene el gradiente de las funciones de forma de la parte poral
% Tensor de permeabilidad

kappa_int = 1e-3*5*9.8669e-13;
mu_dinamico = 2e-4;

kappa = kappa_int/mu_dinamico;
% kappa = 10;
Kperm = [ kappa    0      0
          0        kappa  0
          0        0      kappa ];
  
[Row, Col, nodesEle] = map_poral(nel,nodeDofs,elements,nodes,ndofel,nnodel,ndof);
KC = sparse(nNod,nNod);   

for iele = 1:nel
    KC_elemento  =   gradiente_poral(npg,upg,wpg,nodesEle(:,:,iele),nnodel,Kperm);
    [ROW, COL]   =   get_map(Row(:,:,iele),Col(:,:,iele));
    KC           =   fcn(KC,sparse(ROW,COL,KC_elemento,nNod,nNod));
end

%% --------------------------------------------- Tensor [S] Funciones de forma de la parte poral

Stora = poro*C_fluid + (biot - poro)*C_solid;
% M = 1/Stora;
M = 0.1;%1000;%0.00001;% 

S = sparse(nNod,nNod);
[Row, Col, nodesEle] = map_poral(nel,nodeDofs,elements,nodes,ndofel,nnodel,ndof);

for iele = 1:nel
    S_elemento   =   poral_temporal(npg,upg,wpg,nodesEle(:,:,iele),nnodel,M);
    [ROW, COL]   =   get_map(Row(:,:,iele),Col(:,:,iele));
    S            =   fcn(S,sparse(ROW,COL,S_elemento,nNod,nNod));
end


K_GLOBAL = [   K          -C_g
               C_g'      (S + (tita*deltaT)*KC)  ];
           

           
%% Condiciones de borde BC

bc = false(nnod,ndof);               
bc(nodes_tot(:,3)==-0.1,[1 2 3]) = true;

Q = zeros(nNod,1);   % Creo que es el caudal

%% Algunos inputs

D_P = zeros(ndoftot+nNod,length(Time));  
RQ_hist = zeros(ndoftot+nNod,length(Time)); 
Desplazamientos = zeros(ndoftot,length(Time));
PorePressure = zeros(nNod,length(Time));
Reaccion = zeros(ndoftot,length(Time));
Qq = zeros(nNod,length(Time));

%% Solver
Pressure = zeros(nNod,length(Time));
nodePosition = zeros(nnod,ndof,length(Time));
tInicial    = 0;
contador = 0;
close all
aaa = zeros(ndoftot,length(Time));
Rr = zeros(ndoftot,length(Time));

RNACHO = zeros(ndoftot,length(Time));

factor = 200;
PresioPoralInicial = 0e6;

RelajacionQ=1;% RelajacionQ=1 es sin relajar
RelajacionP=0.95;% RelajacionP=1 es sin relajar
relax = 0.2;
count = 0;

estrato6.contador_1 = 0;
estrato5.contador_1 = 0;
estrato7.contador_1 = 0;
estrato8.contador_1 = 0;
estrato9.contador_1 = 0;

estrato6.contador_2 = 0;
estrato5.contador_2= 0;
estrato7.contador_2 = 0;
estrato8.contador_2 = 0;
estrato9.contador_2 = 0;

estrato6.contador_3 = 0;
estrato5.contador_3= 0;
estrato7.contador_3 = 0;
estrato8.contador_3 = 0;
estrato9.contador_3 = 0;

accion = '0';
accion2 = '0';
accion3 = '0';

n = 0;   % contadores para romper resortes fisu1
m = 0;   % contadores para romper resortes fisu2
p = 0;   % contadores para romper resortes fisu3

desplaza = zeros(nnod,ndof,length(Time));

coordBombas=[200.0000   99.9750   34.8900
             200.0000  199.9750   34.8900
             200.0000  299.9750   34.8900];
         
nod_in=detectorDeCoordDeBombas(round(coordBombas,2),round(nodes,2));
vector_auxiliar = false(ndoftot,1);



E_Barra = [-1e15 3e7 -2e4 0];
% [row, col] = get_mapping_barra(nelSpringFisura1,nodeDofs,elements_Barra_fisu1,ndofel_b);
% 
% for iele = 1:nelSpringFisura1
%      ke_Barra       =  k_barra(iele,nodes,elements_Barra_fisu1,E_B,A_Barra);
%      [ROW, COL]     =  get_map(row(:,:,iele),col(:,:,iele));
%      Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
% end
% 
%  K_NEW = [   Kb        -C_g
%              C_g'      (S + (tita*deltaT)*KC)  ];


for itime = 1:length(Time)
    
    disp(nodes(nodos1_fisu2,:))

    vector_auxiliar(nodos1_fisu1,1) = true;
    vector_auxiliar(nodos2_fisu1,1) = true;
    vector_auxiliar(nodos1_fisu2,1) = true;
    vector_auxiliar(nodos2_fisu2,1) = true;
    vector_auxiliar(nodos1_fisu3,1) = true;
    vector_auxiliar(nodos2_fisu3,1) = true;

    bc_poral = false(nNod,1);
    % ------------ Imponemos como condición de borde que conocemos la presion poral en las caras de la fisura
    bc_poral(nodos1_fisu1) = true;
    bc_poral(nodos2_fisu1) = true;
    bc_poral(nodos1_fisu2) = true;
    bc_poral(nodos2_fisu2) = true;
    bc_poral(nodos1_fisu3) = true;
    bc_poral(nodos2_fisu3) = true;
    
        %% Reducción de matriz

    fixed  = reshape(bc',[],1);
    fixed2 = reshape(bc_poral',[],1);

    free  = ~fixed;
    free2 = ~fixed2;

    isFixed = [ fixed
                fixed2 ];     

    % Armamos un vector lógico que tenga todos los dof, incluido los de la presión poral, pero que en desplazamientos sean todos false.

    ufixed = false(ndoftot,1);

    isFixedp = [ ufixed
                 fixed2 ];

    isFreep = [ufixed
               free2 ];

    free_g = ~isFixed;
    
    %% Algunos inputs
    
    iter = 0;
    CriterioCV = 10;
    ComparadorCaudales=10e1;
    CriterioCV_desplazamientos = 10;
    ComparadorDesplazamientos = 10e1;
    CriterioCV_Presion = 10;
    ComparadorPresiones = 10e1;
    Rompedor = 0;
    count = 0;
%     while CriterioCV_Presion > 1e-4 %CriterioCV > 1e-3 && CriterioCV_desplazamientos > 1e-3  
    while Rompedor < 1 
    desp_1 = 0.005; %   0.5; %   %% Definirlo según el módelo de resorte que se elija. Eso va a depender de la distancia al wellbore
    desp_2 = 0.02;  %   0.6; %   %% Definirlo según el módelo de resorte que se elija. Eso va a depender de la distancia al wellbore
    
    while desplaza<desp_1
        E_B=E_Barra(1);
        [row, col] = get_mapping_barra(nelSpringFisura1,nodeDofs,elements_Barra_fisu1,ndofel_b);
        for iele = 1:nelSpringFisura1
             ke_Barra       =  k_barra(iele,nodes,elements_Barra_fisu1,E_B,A_Barra);
             [ROW, COL]     =  get_map(row(:,:,iele),col(:,:,iele));
             Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
        end
    end
    iter = iter + 1;
    disp(['Time: ' num2str(itime)])
    
    ro          = 10^3;          %kg/(m^3)
    mu          = 1.3*10^-3;     %Pa*s
    transitorio = 1;
    gama        = (100/9810);
    if itime==1
        tInicial    = 0;
    else
        tInicial= t_final;
    end
% %     QExt   = QExt*(1-Relajacion)-Qneto*Relajacion;

    alfaTime    = 1/2;% cam
    t_final     = deltaT+tInicial;
    delta_t     = deltaT*alfaTime;
%     if iter <= 50
    if itime<=25
        Pin         = 5e6;%PresioPoralInicial + PresioPoralInicial*0; %40e6;%     % Nacho no mienta0;s : (1e5)*itime+30e6;
    else 
        Pin = 5e6;
    end
%     end
    if iter > 25
%         Pin = 12e5*(itime - 1) + relax*12e5*(itime-1);% 12e5*(itime-1) + 12e5*(itime-1)*relax;
        iter = 1;
        count = count + 1;

    end
    
    figure(300)
    plot(itime,Pin,'k*')
    title('Pin')
    hold on
    
    bomba       = 1;
    QMax        = 2*(10^5);  % con 2*1e4 funciona
    graficar    = false;%true; %false;% 

    if itime == 1
        if iter == 1
        nodNew          = nodes;
        P_old           = PresioPoralInicial*1.01*ones(length(nodNew),1);
        nodOld          = nodes;
        QExt            = zeros(length(nodNew),1);
        QHistoricoViejo = 0;
        else
            QExt = QExt*(1-(RelajacionQ))-Qneto*(RelajacionQ);
        end
    elseif itime == 2
        nodNew = nodePosition(1:nNod,:,itime-1);
        P_old  = Pressure(:,itime-1);% PresioPoralInicial*ones(length(nodNew),1);% 
        nodOld = nodes;   
        QExt   = -Qneto;%P_old*0;%
        
    else
        nodNew = nodePosition(1:nNod,:,itime-1);
        P_old  = Pressure(:,itime-1);
        nodOld = nodePosition(1:nNod,:,itime-2);   
        QExt   = QExt*(1-RelajacionQ)-Qneto*RelajacionQ;%P_old*0;%
    end
    
    elem8Nod=elements;
    
%     graficadorMalladorH8( nodNew, elem8Nod, nodNew(:,3))
    
    [TBombas]=activacionDeBombas(delta_t*12.1*3*3, 3);%(delta_t*9.1*3, 3);% % para secuenciar Decia activacionDeBombas(delta_t*9.1*3, 3) MOD NACHO!!!
    
    [Pressure(:,itime),QHistoricoViejo, aperturaGrietaNachote] =  MOTHERFUNCTION(ro, mu, transitorio, gama, tInicial, t_final, delta_t, Pin, bomba, QMax, graficar, nodNew, elem8Nod, elements_Barra, P_old,nodOld,QExt,QHistoricoViejo,TBombas,nod_in);
%     Pressure(elements_Barra(:,1),itime) = Pin;
    Pressure(elements_Barra(:,2),itime) = Pressure(elements_Barra(:,1),itime);

%     Pressure(find(Pressure),itime)
    % Vector de cargas en la fisura 1 en la cara negativa (y-)
    GPr   = 1/sqrt(3);
    RNACHO(:,itime) = VC_Nacho(GPr,sizeFisu1_1,nodeDofs,ele_fisu1_y1_1,nodes,ndofel,nnodel,ndof,Pressure(:,itime),ndofel_1,RNACHO(:,itime),ndoftot,fcn,sizeFisu1_2,ele_fisu1_y1_2,ndofel_2,sizeFisu2_1,ele_fisu2_y2_1,sizeFisu2_2,ele_fisu2_y2_2,sizeFisu3_1,sizeFisu3_2,ele_fisu3_y3_1,ele_fisu3_y3_2);
    
    R = RTOT(:,itime) + RNACHO(:,itime);

    
    if itime == 1
        D_P(1:nnod*ndof,itime)   = zeros(nnod*ndof,1);
        D_P(ndoftot+1:end,itime) = PresioPoralInicial;  
    else
        D_P(1:ndoftot,itime)     = Desplazamientos(:,itime-1);
        D_P(ndoftot+1:end,itime) = PorePressure(:,itime-1);
    end
    
    Def_Inicial = K*D_P(1:ndoftot,itime);
    
    D_P(isFixedp,itime) = PresioPoralInicial;
    
    Rr = reshape(R',[],1);

%     Rr = Rr + Def_Inicial;
    Rq = C_g'*D_P(1:nnod*ndof,itime) + (S - (1-tita)*deltaT*KC)*D_P((nnod*ndof+1):end,itime) + deltaT*Q;

    VC = [ Rr
           Rq ];
        
    Campos = K_GLOBAL(free_g,free_g)\(VC(free_g) - K_GLOBAL(free_g,isFixed)*(D_P(isFixed,itime))); 
    RQincog = K_GLOBAL(isFixed,free_g)*Campos + K_GLOBAL(isFixed,isFixed)*D_P(isFixed,itime);
    
    %%%% Reconstrucción del vector de cargas, lo llamo RQ
    RQ = zeros(ndoftot+nNod,1);    
    RQ(free_g) = RQ(free_g) + VC(free_g);
    RQ(isFixed) = RQ(isFixed) + RQincog;
    
    %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
    CamposDP = zeros(ndoftot+nNod,1); 
    CamposDP(free_g) = CamposDP(free_g) + Campos;
    CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);
    
    %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
%     CamposDP(ndoftot+1:end)
    D_P(:,itime+1) = CamposDP;
    RQ_hist(:,itime) = RQ;               
    
    %%%% Historia de los desplazamientos y la presión
    Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
    PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);
    
    %%%% Historia del vector de cargas y los caudales
    Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
    Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);

    
% %     Qmax(1,itime) = max(CAUDAL);
% %     Qmin(1,itime) = min(CAUDAL);
% %     
    Qneto= -(Qq(:,itime)-Rq)/deltaT;    % Ver el menos, edit nacho: el menos es para cambiar el signo para que se compatibilize con mi modelo ya que el fluido en el modelo de la fisura sale de la fisura cunado entra en la roca
%     min(Qneto)   
% %     QmaxNeto(1,itime) = max(Qneto);
% %     QminNeto(1,itime) = min(Qneto);
    
    
    % %% Configuracion deformada
    D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
    nodePosition(:,:,itime) = nodes_tot + D_1*factor;


    %% ------------------------------------- Ensamble de los elementos barra a la K global
    
    A_Barra = 1000;

    E_Barra = [-1e15 3e7 -2e4 0];
    E_Barra2 = [-1e15 3e7 -2e4 0];
    E_Barra3 = [-1e15 3e7 -2e4 0];
    
    
    gap_fisu1 = mean(D_1(nodos2_fisu1,2)-D_1(nodos1_fisu1,2));
    gap_fisu2 = mean(D_1(nodos2_fisu2,2)-D_1(nodos1_fisu2,2));
    gap_fisu3 = mean(D_1(nodos2_fisu3,2)-D_1(nodos1_fisu3,2));

%     nodes(nodos1_fisu1,:)
%     size(nodos1_fisu1)
    
    %% --------------------------------------- Resortes en la fisura 1

    nelSpringFisura1 = size(elements_Barra_fisu1,1);
    nelSpringFisura2 = size(elements_Barra_fisu2,1);
    nelSpringFisura3 = size(elements_Barra_fisu3,1);
    ndofel_b = 4;
    
    Kb = K;
    
    
    %% Resumir resortes

    for resumir=1
    if 1<2 %itime==1
         if gap_fisu1>=0 && gap_fisu1<desp_1  %%Edit NACHO!!!! LE AGREGUE EL IGUAL A CERO. EDIT PABLO! Nunca va a ser = 0
        
         E_B = E_Barra(2);  
         [row, col] = get_mapping_barra(nelSpringFisura1,nodeDofs,elements_Barra_fisu1,ndofel_b);

         for iele = 1:nelSpringFisura1
             ke_Barra       =  k_barra(iele,nodes,elements_Barra_fisu1,E_B,A_Barra);
             [ROW, COL]     =  get_map(row(:,:,iele),col(:,:,iele));
             Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
         end

         K_NEW = [   Kb        -C_g
                     C_g'      (S + (tita*deltaT)*KC)  ];

         % Solver
         Campos = K_NEW(free_g,free_g)\(VC(free_g)-K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
         Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);

         %%%% Reconstrucción del vector de cargas, lo llamo RQ
         RQ = zeros(ndoftot+nNod,1);    
         RQ(free_g) = RQ(free_g) + VC(free_g);
         RQ(isFixed) = RQ(isFixed) + RQincog;

         %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
         CamposDP = zeros(ndoftot+nNod,1); 
         CamposDP(free_g) = CamposDP(free_g) + Campos;
         CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

         %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
         D_P(:,itime+1) = CamposDP;
         RQ_hist(:,itime) = RQ;               

         %%%% Historia de los desplazamientos y la presión
         Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
         PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

         %%%% Historia del vector de cargas y los caudales
         Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
         Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
         Qneto= -(Qq(:,itime)-Rq)/deltaT; 
%          min(Qneto) 
%     
         D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   
         nodePosition(:,:,itime) = nodes_tot + D_1*factor;

         gap1 = mean(D_1(nodos2_fisu1,2)-D_1(nodos1_fisu1,2));
      
        end
        if gap_fisu1<0 
        
        E_B = E_Barra(1);
        [row, col] = get_mapping_barra(nelSpringFisura1,nodeDofs,elements_Barra_fisu1,ndofel_b);

            for iele = 1:nelSpringFisura1
                ke_Barra      =  k_barra(iele,nodes,elements_Barra_fisu1,E_B,A_Barra);
                [ROW, COL]    =  get_map(row(:,:,iele),col(:,:,iele));
                Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
            end
   
        K_NEW = [   Kb          -C_g
                    C_g'      (S + (tita*deltaT)*KC)  ];
                   
        % Solver
        Campos = K_NEW(free_g,free_g)\(VC(free_g) - K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
        Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);
    
         %%%% Reconstrucción del vector de cargas, lo llamo RQ
         RQ = zeros(ndoftot+nNod,1);    
         RQ(free_g) = RQ(free_g) + VC(free_g);
         RQ(isFixed) = RQ(isFixed) + RQincog;

         %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
         CamposDP = zeros(ndoftot+nNod,1); 
         CamposDP(free_g) = CamposDP(free_g) + Campos;
         CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

         %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
         D_P(:,itime+1) = CamposDP;
         RQ_hist(:,itime) = RQ;               

         %%%% Historia de los desplazamientos y la presión
         Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
         PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

         %%%% Historia del vector de cargas y los caudales
         Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
         Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
         Qneto= -(Qq(:,itime)-Rq)/deltaT; 
%          min(Qneto) 
         
        D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
        nodePosition(:,:,itime) = nodes_tot + D_1*factor;

        gap1 = mean(D_1(nodos2_fisu1,2)-D_1(nodos1_fisu1,2));

        end
        
        if gap_fisu1>desp_1 && gap_fisu1<desp_2
        
        E_B = E_Barra(3);
        [row, col] = get_mapping_barra(nelSpringFisura1,nodeDofs,elements_Barra_fisu1,ndofel_b);

            for iele = 1:nelSpringFisura1
                ke_Barra      =  k_barra(iele,nodes,elements_Barra_fisu1,E_B,A_Barra);
                [ROW, COL]    =  get_map(row(:,:,iele),col(:,:,iele));
                Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));           
            end
   
        K_NEW = [   Kb          -C_g
                    C_g'      (S + (tita*deltaT)*KC)  ];
              
        % Solver
        Campos = K_NEW(free_g,free_g)\(VC(free_g)-K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
        Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);
        
         %%%% Reconstrucción del vector de cargas, lo llamo RQ
         RQ = zeros(ndoftot+nNod,1);    
         RQ(free_g) = RQ(free_g) + VC(free_g);
         RQ(isFixed) = RQ(isFixed) + RQincog;

         %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
         CamposDP = zeros(ndoftot+nNod,1); 
         CamposDP(free_g) = CamposDP(free_g) + Campos;
         CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

         %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
         D_P(:,itime+1) = CamposDP;
         RQ_hist(:,itime) = RQ;               

         %%%% Historia de los desplazamientos y la presión
         Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
         PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

         %%%% Historia del vector de cargas y los caudales
         Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
         Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
         Qneto= -(Qq(:,itime)-Rq)/deltaT; 
%          min(Qneto) 
         
        D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
        nodePosition(:,:,itime) = nodes_tot + D_1*factor;
   
        gap1 = mean(D_1(nodos2_fisu1,2)-D_1(nodos1_fisu1,2));

        end
        if gap_fisu1>desp_2 
        
        E_B = E_Barra(4);
        [row, col] = get_mapping_barra(nelSpringFisura1,nodeDofs,elements_Barra_fisu1,ndofel_b);

            for iele = 1:nelSpringFisura1           
                ke_Barra      =  k_barra(iele,nodes,elements_Barra_fisu1,E_B,A_Barra);
                [ROW, COL]    =  get_map(row(:,:,iele),col(:,:,iele));
                Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));  
            end
   
            K_NEW = [   Kb          -C_g
                        C_g'      (S + (tita*deltaT)*KC)  ];
              
            % Solver
            Campos = K_NEW(free_g,free_g)\(VC(free_g)-K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
            Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);

             %%%% Reconstrucción del vector de cargas, lo llamo RQ
             RQ = zeros(ndoftot+nNod,1);    
             RQ(free_g) = RQ(free_g) + VC(free_g);
             RQ(isFixed) = RQ(isFixed) + RQincog;

             %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
             CamposDP = zeros(ndoftot+nNod,1); 
             CamposDP(free_g) = CamposDP(free_g) + Campos;
             CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

             %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
             D_P(:,itime+1) = CamposDP;
             RQ_hist(:,itime) = RQ;               

             %%%% Historia de los desplazamientos y la presión
             Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
             PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

             %%%% Historia del vector de cargas y los caudales
             Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
             Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
             Qneto= -(Qq(:,itime)-Rq)/deltaT; 
%              min(Qneto) 
   
            D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
            nodePosition(:,:,itime) = nodes_tot + D_1*factor;
   
            gap1 = mean(D_1(nodos2_fisu1,2)-D_1(nodos1_fisu1,2));

        end
        
        %% ------------------------------------Resortes en la fisura 2


        if gap_fisu2>=0 && gap_fisu2<desp_1  %%Edit NACHO!!!! LE AGREGUE EL IGUAL A CERO

           E_B = E_Barra2(2);   
           [row, col] = get_mapping_barra(nelSpringFisura2,nodeDofs,elements_Barra_fisu2,ndofel_b);

           for iele = 1:nelSpringFisura2       
                    ke_Barra      =  k_barra(iele,nodes,elements_Barra_fisu2,E_B,A_Barra);
                    [ROW, COL]    =  get_map(row(:,:,iele),col(:,:,iele));
                    Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));  
           end

           K_NEW = [   Kb          -C_g
                       C_g'      (S + (tita*deltaT)*KC)  ];

           % Solver
           Campos = K_NEW(free_g,free_g)\(VC(free_g) - K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
           Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);

             %%%% Reconstrucción del vector de cargas, lo llamo RQ
             RQ = zeros(ndoftot+nNod,1);    
             RQ(free_g) = RQ(free_g) + VC(free_g);
             RQ(isFixed) = RQ(isFixed) + RQincog;

             %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
             CamposDP = zeros(ndoftot+nNod,1); 
             CamposDP(free_g) = CamposDP(free_g) + Campos;
             CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

             %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
             D_P(:,itime+1) = CamposDP;
             RQ_hist(:,itime) = RQ;               

             %%%% Historia de los desplazamientos y la presión
             Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
             PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

             %%%% Historia del vector de cargas y los caudales
             Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
             Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
             Qneto= -(Qq(:,itime)-Rq)/deltaT; 
%              min(Qneto) 

           D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
           nodePosition(:,:,itime) = nodes_tot + D_1*factor;

           gap2 = mean(D_1(nodos2_fisu2,2)-D_1(nodos1_fisu2,2));

        end

        if gap_fisu2<0 

           E_B = E_Barra2(1);
           [row, col] = get_mapping_barra(nelSpringFisura2,nodeDofs,elements_Barra_fisu2,ndofel_b);   

           for iele = 1:nelSpringFisura2
                    ke_Barra      =  k_barra(iele,nodes,elements_Barra_fisu2,E_B,A_Barra);
                    [ROW, COL]    =  get_map(row(:,:,iele),col(:,:,iele));
                    Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));  
           end

           K_NEW = [   Kb          -C_g
                       C_g'      (S + (tita*deltaT)*KC)  ];

           % Solver
           Campos = K_NEW(free_g,free_g)\(VC(free_g)- K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
           Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);

             %%%% Reconstrucción del vector de cargas, lo llamo RQ
             RQ = zeros(ndoftot+nNod,1);    
             RQ(free_g) = RQ(free_g) + VC(free_g);
             RQ(isFixed) = RQ(isFixed) + RQincog;

             %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
             CamposDP = zeros(ndoftot+nNod,1); 
             CamposDP(free_g) = CamposDP(free_g) + Campos;
             CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

             %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
             D_P(:,itime+1) = CamposDP;
             RQ_hist(:,itime) = RQ;               

             %%%% Historia de los desplazamientos y la presión
             Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
             PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

             %%%% Historia del vector de cargas y los caudales
             Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
             Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
             Qneto= -(Qq(:,itime)-Rq)/deltaT;
%              min(Qneto) 

           D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
           nodePosition(:,:,itime) = nodes_tot + D_1*factor;

           gap2 = mean(D_1(nodos2_fisu2,2)-D_1(nodos1_fisu2,2));

        end


        if gap_fisu2>desp_1 && gap_fisu2<desp_2

           E_B = E_Barra2(3);   
           [row, col] = get_mapping_barra(nelSpringFisura2,nodeDofs,elements_Barra_fisu2,ndofel_b);   

           for iele = 1:nelSpringFisura2
                    ke_Barra      =  k_barra(iele,nodes,elements_Barra_fisu2,E_B,A_Barra);
                    [ROW, COL]    =  get_map(row(:,:,iele),col(:,:,iele));
                    Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));  
           end

           K_NEW = [   Kb          -C_g
                       C_g'      (S + (tita*deltaT)*KC)  ];

           % Solver
           Campos = K_NEW(free_g,free_g)\(VC(free_g) - K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
           Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);

             %%%% Reconstrucción del vector de cargas, lo llamo RQ
             RQ = zeros(ndoftot+nNod,1);    
             RQ(free_g) = RQ(free_g) + VC(free_g);
             RQ(isFixed) = RQ(isFixed) + RQincog;

             %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
             CamposDP = zeros(ndoftot+nNod,1); 
             CamposDP(free_g) = CamposDP(free_g) + Campos;
             CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

             %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
             D_P(:,itime+1) = CamposDP;
             RQ_hist(:,itime) = RQ;               

             %%%% Historia de los desplazamientos y la presión
             Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
             PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

             %%%% Historia del vector de cargas y los caudales
             Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
             Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
             Qneto= -(Qq(:,itime)-Rq)/deltaT; 
%              min(Qneto) 

           D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
           nodePosition(:,:,itime) = nodes_tot + D_1*factor;

           gap2 = mean(D_1(nodos2_fisu2,2)-D_1(nodos1_fisu2,2));

        end

        if gap_fisu2>desp_2 

           E_B = E_Barra2(4);
           [row, col] = get_mapping_barra(nelSpringFisura2,nodeDofs,elements_Barra_fisu2,ndofel_b);   

           for iele = 1:nelSpringFisura2
                    ke_Barra      =  k_barra(iele,nodes,elements_Barra_fisu2,E_B,A_Barra);
                    [ROW, COL]    =  get_map(row(:,:,iele),col(:,:,iele));
                    Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));  
           end

           K_NEW = [   Kb          -C_g
                       C_g'      (S + (tita*deltaT)*KC)  ];

           % Solver
           Campos = K_NEW(free_g,free_g)\(VC(free_g) - K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
           Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);

             %%%% Reconstrucción del vector de cargas, lo llamo RQ
             RQ = zeros(ndoftot+nNod,1);    
             RQ(free_g) = RQ(free_g) + VC(free_g);
             RQ(isFixed) = RQ(isFixed) + RQincog;

             %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
             CamposDP = zeros(ndoftot+nNod,1); 
             CamposDP(free_g) = CamposDP(free_g) + Campos;
             CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

             %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
             D_P(:,itime+1) = CamposDP;
             RQ_hist(:,itime) = RQ;               

             %%%% Historia de los desplazamientos y la presión
             Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
             PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

             %%%% Historia del vector de cargas y los caudales
             Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
             Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
             Qneto= -(Qq(:,itime)-Rq)/deltaT; 
%              min(Qneto) 

           D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
           nodePosition(:,:,itime) = nodes_tot + D_1*factor;

           gap2 = mean(D_1(nodos2_fisu2,2)-D_1(nodos1_fisu2,2));

        end
        
        %% ------------------------------- Resortes en la fisura 3

        if gap_fisu3>=0 && gap_fisu3<desp_1  %%Edit NACHO!!!! LE AGREGUE EL IGUAL A CERO

           E_B = E_Barra3(2);
           [row, col] = get_mapping_barra(nelSpringFisura3,nodeDofs,elements_Barra_fisu3,ndofel_b);   

           for iele = 1:nelSpringFisura3
                    ke_Barra      =  k_barra(iele,nodes,elements_Barra_fisu3,E_B,A_Barra);
                    [ROW, COL]    =  get_map(row(:,:,iele),col(:,:,iele));
                    Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));  
           end

           K_NEW = [   Kb          -C_g
                       C_g'      (S + (tita*deltaT)*KC)  ];

           % Solver
           Campos = K_NEW(free_g,free_g)\(VC(free_g) - K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
           Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);

             %%%% Reconstrucción del vector de cargas, lo llamo RQ
             RQ = zeros(ndoftot+nNod,1);    
             RQ(free_g) = RQ(free_g) + VC(free_g);
             RQ(isFixed) = RQ(isFixed) + RQincog;

             %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
             CamposDP = zeros(ndoftot+nNod,1); 
             CamposDP(free_g) = CamposDP(free_g) + Campos;
             CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

             %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
             D_P(:,itime+1) = CamposDP;
             RQ_hist(:,itime) = RQ;               

             %%%% Historia de los desplazamientos y la presión
             Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
             PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

             %%%% Historia del vector de cargas y los caudales
             Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
             Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
             Qneto= -(Qq(:,itime)-Rq)/deltaT; 
%              min(Qneto) 
         
           D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
           nodePosition(:,:,itime) = nodes_tot + D_1*factor;

           gap3 = mean(D_1(nodos2_fisu3,2)-D_1(nodos1_fisu3,2));

        end

        if gap_fisu3<0 

           E_B = E_Barra3(1);
           [row, col] = get_mapping_barra(nelSpringFisura3,nodeDofs,elements_Barra_fisu3,ndofel_b);   

           for iele = 1:nelSpringFisura3
                    ke_Barra      =  k_barra(iele,nodes,elements_Barra_fisu3,E_B,A_Barra);
                    [ROW, COL]    =  get_map(row(:,:,iele),col(:,:,iele));
                    Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot)); 
           end

           K_NEW = [   Kb          -C_g
                       C_g'      (S + (tita*deltaT)*KC)  ];

           % Solver
           Campos = K_NEW(free_g,free_g)\(VC(free_g)-K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
           Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);

             %%%% Reconstrucción del vector de cargas, lo llamo RQ
             RQ = zeros(ndoftot+nNod,1);    
             RQ(free_g) = RQ(free_g) + VC(free_g);
             RQ(isFixed) = RQ(isFixed) + RQincog;

             %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
             CamposDP = zeros(ndoftot+nNod,1); 
             CamposDP(free_g) = CamposDP(free_g) + Campos;
             CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

             %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
             D_P(:,itime+1) = CamposDP;
             RQ_hist(:,itime) = RQ;               

             %%%% Historia de los desplazamientos y la presión
             Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
             PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

             %%%% Historia del vector de cargas y los caudales
             Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
             Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
             Qneto= -(Qq(:,itime)-Rq)/deltaT; 
%              min(Qneto) 
             
           D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
           nodePosition(:,:,itime) = nodes_tot + D_1*factor;
                      
           gap3 = mean(D_1(nodos2_fisu3,2)-D_1(nodos1_fisu3,2));

        end

        if gap_fisu3>desp_1 && gap_fisu3<desp_2

           E_B = E_Barra3(3);
           [row, col] = get_mapping_barra(nelSpringFisura3,nodeDofs,elements_Barra_fisu3,ndofel_b);   

           for iele = 1:nelSpringFisura3
                    ke_Barra      =  k_barra(iele,nodes,elements_Barra_fisu3,E_B,A_Barra);
                    [ROW, COL]    =  get_map(row(:,:,iele),col(:,:,iele));
                    Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot)); 
           end

           K_NEW = [   Kb          -C_g
                       C_g'      (S + (tita*deltaT)*KC)  ];

           % Solver
           Campos = K_NEW(free_g,free_g)\(VC(free_g)-K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
           Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);

             %%%% Reconstrucción del vector de cargas, lo llamo RQ
             RQ = zeros(ndoftot+nNod,1);    
             RQ(free_g) = RQ(free_g) + VC(free_g);
             RQ(isFixed) = RQ(isFixed) + RQincog;

             %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
             CamposDP = zeros(ndoftot+nNod,1); 
             CamposDP(free_g) = CamposDP(free_g) + Campos;
             CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

             %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
             D_P(:,itime+1) = CamposDP;
             RQ_hist(:,itime) = RQ;               

             %%%% Historia de los desplazamientos y la presión
             Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
             PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

             %%%% Historia del vector de cargas y los caudales
             Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
             Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
             Qneto= -(Qq(:,itime)-Rq)/deltaT; 
%              min(Qneto) 

           D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
           nodePosition(:,:,itime) = nodes_tot + D_1*factor;

           gap3 = mean(D_1(nodos2_fisu3,2)-D_1(nodos1_fisu3,2));

        end

        if gap_fisu3>desp_2 

           E_B = E_Barra3(4);
           [row, col] = get_mapping_barra(nelSpringFisura3,nodeDofs,elements_Barra_fisu3,ndofel_b);   

           for iele = 1:nelSpringFisura3
                    ke_Barra      =  k_barra(iele,nodes,elements_Barra_fisu3,E_B,A_Barra);
                    [ROW, COL]    =  get_map(row(:,:,iele),col(:,:,iele));
                    Kb             =  fcn(Kb,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot)); 
           end

           K_NEW = [   Kb          -C_g
                       C_g'      (S + (tita*deltaT)*KC)  ];

           % Solver
           Campos = K_NEW(free_g,free_g)\(VC(free_g)-K_NEW(free_g,isFixed)*(D_P(isFixed,itime)));
           Caudales = K_NEW(isFixed,free_g)*Campos + K_NEW(isFixed,isFixed)*D_P(isFixed,itime);

             %%%% Reconstrucción del vector de cargas, lo llamo RQ
             RQ = zeros(ndoftot+nNod,1);    
             RQ(free_g) = RQ(free_g) + VC(free_g);
             RQ(isFixed) = RQ(isFixed) + RQincog;

             %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
             CamposDP = zeros(ndoftot+nNod,1); 
             CamposDP(free_g) = CamposDP(free_g) + Campos;
             CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

             %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
             D_P(:,itime+1) = CamposDP;
             RQ_hist(:,itime) = RQ;               

             %%%% Historia de los desplazamientos y la presión
             Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);
             PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);

             %%%% Historia del vector de cargas y los caudales
             Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);
             Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);
             Qneto= -(Qq(:,itime)-Rq)/deltaT; 
%              min(Qneto) 

           D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
           nodePosition(:,:,itime) = nodes_tot + D_1*factor;

           gap3 = mean(D_1(nodos2_fisu3,2)-D_1(nodos1_fisu3,2));

        end

    end
    end
    

%         disp(gap1)  
%     end
        DesplazamientosXYZ = D_1;
        aa = [nodes_tot D_1];
   
        Desplazamientos_fisura = zeros(nnod,ndof);
        Desplazamientos_fisura(vector_auxiliar,:) = DesplazamientosXYZ(vector_auxiliar,:);   
        Desplazamientos_fisura = reshape(Desplazamientos_fisura',[],1);

        Presiones = PorePressure(:,itime);
        Presion_fisura = zeros(nNod,1);
        Presion_fisura(vector_auxiliar) = Presiones(vector_auxiliar);

        disp(['Iteración: ' num2str(iter)])

        Presion_anterior = abs(Presion_fisura);
        CV_P = norm(Presion_anterior - ComparadorPresiones);
        ComparadorPresiones = Presion_anterior;

        Desplazamiento_anterior = abs(Desplazamientos_fisura);
        CV_D = norm(Desplazamiento_anterior - ComparadorDesplazamientos);
        ComparadorDesplazamientos = Desplazamiento_anterior;

        Caudal_anterior = abs(Qneto);
        CV_Q = norm(Caudal_anterior-ComparadorCaudales); %abs(((Caudal_anterior-ComparadorConvergencia)/Caudal_anterior)*100
        ComparadorCaudales = Caudal_anterior;
    
        if CV_Q < 1e-1 && CV_P < 1e-1 && CV_D < 1e-0
            Rompedor = Rompedor+1;
        else
            Rompedor = 0;
        end

        if iter > 2
            figure(itime)
    %         H=figure('units','normalized','outerposition',[0 0 1 1])
            grid on
            subplot(1,3,1)
            hold on
            title(itime)
            plot(iter-1:iter,[CriterioCV CV_Q],'r')
            plot(iter-1:iter,[0.1 0.1],'b')
            legend('CV Caudal')
            grid on

            subplot(1,3,2)
            hold on
            title(itime)
            plot(iter-1:iter,[CriterioCV_desplazamientos CV_D],'g')
            plot(iter-1:iter,[0.1 0.1],'b')
            legend('CV Desplazamientos')
            grid on

            subplot(1,3,3)
            hold on
            title(itime)
            plot(iter-1:iter,[CriterioCV_Presion CV_P],'k')
            legend('CV Presion')

            plot(iter-1:iter,[0.1 0.1],'b')
    %         ylim([0 CV_Q*1.5+1e-4])

            drawnow

            grid on

        end
    
        CriterioCV = CV_Q;
        CriterioCV_desplazamientos = CV_D;
        CriterioCV_Presion = CV_P;
   

    end
%     close all

    
%     K_GLOBAL = K_NEW;   %Descomentar cuando tenga una secuencia la carga
%     
    disp(gap_fisu1)
    disp(gap_fisu2)
    disp(gap_fisu3)
    disp(gap1)
    disp(gap2)
    disp(gap3)
    
    figure(200)
    guardador(itime,:)=[tInicial, gap1];
    plot(itime,gap1,'r*')
    hold on
    plot(itime,gap2,'b*')
    title('Apertura Fisura [m]')
    plot(itime,gap3,'g*')
%     
    drawnow
    
    
    if gap1 >= desp_1
        
        %%% En este espacio podría ir el cálculo de algún criterio de
        %%% propagación de fractura
        
        disp('Rompe')

        [estrato5, estrato6,estrato7, estrato8, estrato9,accion] = func1(accion,estrato5,estrato6,estrato7,estrato8,estrato9,d_estrato_10,d_estrato_9,d_estrato_8,d_estrato_7,d_estrato_6,d_estrato_5);

        n = n+1;
        tol_malla =  abs(nodes(ele_fisu1_y1_1(2,1),1) - nodes(ele_fisu1_y1_1(1,1),1));
        if tol_malla<= 0.1
            disp('Cuidado, la malla es muy chica')
        end
        
        tol_malla = tol_malla + 0.1;
        clear ele_fisu1_1 ele_fisu1_y1_1 sizeFisu1_1 ele_fisu1_2 ele_fisu1_y1_2 sizeFisu1_2
        
        z_cota1 = d_estrato_7 + estrato6.size*estrato6.contador_1  + estrato5.size*estrato5.contador_1 + 0.01;                                       % OJO! ver secuencia de carga
        z_cota2 = d_estrato_7 - estrato7.size*(estrato7.contador_1) - estrato8.size*estrato8.contador_1 - estrato9.size*estrato9.contador_1 - 0.01;
        
        [ele_fisu1_y1_1, sizeFisu1_1, nodos1_fisu1, ele_fisu1_y1_2 , sizeFisu1_2, nodos2_fisu1] = nuevasAreas1(nodes,elements,n,tol_malla,nel,nnodel,z_cota1,z_cota2);
               
    end
        
    if gap2 >= desp_1
        m = m +1;

        [estrato5,estrato6,estrato7, estrato8, estrato9,accion2] = func2(accion2,estrato5,estrato6,estrato7,estrato8,estrato9,d_estrato_10,d_estrato_9,d_estrato_8,d_estrato_7,d_estrato_6,d_estrato_5);

        tol_malla2 =  abs(nodes(ele_fisu2_y2_1(2,1),1) - nodes(ele_fisu2_y2_1(1,1),1));
        if tol_malla2<= 0.1
            disp('Cuidado, la malla es muy chica')
        end
        clear ele_fisu2_1 ele_fisu2_y2_2 sizeFisu2_1 ele_fisu2_2 ele_fisu2_y2_1 sizeFisu2_2
        
        z_cota1 = d_estrato_7 + estrato6.size*estrato6.contador_2 + estrato5.size*estrato5.contador_2 + 0.01;                                       % OJO! ver secuencia de carga
        z_cota2 = d_estrato_7 - estrato7.size*(estrato7.contador_2) - estrato8.size*estrato8.contador_2 - estrato9.size*estrato9.contador_2 - 0.01;
        
        [ele_fisu2_y2_1, sizeFisu2_1, nodos1_fisu2, ele_fisu2_y2_2 , sizeFisu2_2, nodos2_fisu2] = nuevasAreas2(nodes,elements,m,tol_malla2,nel,nnodel,z_cota1,z_cota2);
        
    end
    
    if gap3 >= desp_1
        p = p + 1;

        [estrato5, estrato6,estrato7, estrato8, estrato9,accion3] = func3(accion3,estrato5,estrato6,estrato7,estrato8,estrato9,d_estrato_10,d_estrato_9,d_estrato_8,d_estrato_7,d_estrato_6,d_estrato_5);

        tol_malla3 =  abs(nodes(ele_fisu3_y3_1(2,1),1) - nodes(ele_fisu3_y3_1(1,1),1));
        if tol_malla3<= 0.1
            disp('Cuidado, la malla es muy chica')
        end

        clear ele_fisu3_1 ele_fisu3_y3_1 sizeFisu3_1 ele_fisu3_2 ele_fisu3_y3_2 sizeFisu3_2
        
        z_cota1 = d_estrato_7 + estrato6.size*estrato6.contador_3  + estrato5.size*estrato5.contador_3 + 0.01;                                       % OJO! ver secuencia de carga
        z_cota2 = d_estrato_7 - estrato7.size*(estrato7.contador_3) - estrato8.size*estrato8.contador_3 - estrato9.size*estrato9.contador_3 - 0.01;
        
        [ele_fisu3_y3_1, sizeFisu3_1, nodos1_fisu3, ele_fisu3_y3_2 , sizeFisu3_2, nodos2_fisu3] = nuevasAreas3(nodes,elements,p,tol_malla3,nel,nnodel,z_cota1,z_cota2);
        
    end
    desplaza(:,:,itime) = nodePosition(:,:,itime) - nodes_tot;    
 
    
end

toc
save('PresionData','PorePressure')
save('AperturaFisura','guardador')


% % % % % Num = 1:nnod;                                                                  %%% AUXILIARES PARA VER BIEN LAS POSICIONES NODALES FINALES
% % % % % Num = Num';                                                                    %%% AUXILIARES PARA VER BIEN LAS POSICIONES NODALES FINALES
% % % % % ss = [ Num nodes(:,2) nodePosition(:,2) Num];                                  %%% AUXILIARES PARA VER BIEN LAS POSICIONES NODALES FINALES

% Meshplot de la configuración deformada de los estratos 6 7 8
% meshplot3D(ele_strat6,nodePosition_final,'b','w')
% meshplot3D2(ele_strat7,ele_strat8,ele_strat6,nodePosition,'b','w','r','w','c','w')
% min(D)

%% --------------------------------------------------------- Calculo de Tensiones

% ----Tensiones totales, solo estamos viendo lo que se deforma el sólido

% ----Puntos nodales

unod = [  1   1   1
         -1   1   1
         -1  -1   1
          1  -1   1
          1   1  -1
         -1   1  -1
         -1  -1  -1
          1  -1  -1 ];   
      
C.estrato_10 = C_10;
C.estrato_9 = C_9;
C.estrato_8 = C_8;
C.estrato_7 = C_7;
C.estrato_6 = C_6;
C.estrato_5 = C_5;
C.estrato_4 = C_4;
C.estrato_3 = C_3;
C.estrato_2 = C_2;
C.estrato_1 = C_1;

d.estrato_10 = d_estrato_10;
d.estrato_9 = d_estrato_9;
d.estrato_8 = d_estrato_8;
d.estrato_7 = d_estrato_7;
d.estrato_6 = d_estrato_6;
d.estrato_5 = d_estrato_5;
d.estrato_4 = d_estrato_4;
d.estrato_3 = d_estrato_3;
d.estrato_2 = d_estrato_2;
d.estrato_1 = d_estrato_1;

% ESTRATO 10
[S10,campoDef10]  =  tension_deformacion(nel_10,unod,ele_strat10,nodes,C,nodeDofs,Desplazamientos,ndofel_10,nnodel,ndof,Time,PorePressure,Biot,d);
% ESTRATO 9
[S9,campoDef9]    =  tension_deformacion(nel_9,unod,ele_strat9,nodes,C,nodeDofs,Desplazamientos,ndofel_9,nnodel,ndof,Time,PorePressure,Biot,d);
% ESTRATO 8
[S8,campoDef8]    =  tension_deformacion(nel_8,unod,ele_strat8,nodes,C,nodeDofs,Desplazamientos,ndofel_8,nnodel,ndof,Time,PorePressure,Biot,d);
% ESTRATO 7
[S7,campoDef7]    =  tension_deformacion(nel_7,unod,ele_strat7,nodes,C,nodeDofs,Desplazamientos,ndofel_7,nnodel,ndof,Time,PorePressure,Biot,d);
% ESTRATO 6
[S6,campoDef6]    =  tension_deformacion(nel_6,unod,ele_strat6,nodes,C,nodeDofs,Desplazamientos,ndofel_6,nnodel,ndof,Time,PorePressure,Biot,d);
% ESTRATO 5
[S5,campoDef5]    =  tension_deformacion(nel_5,unod,ele_strat5,nodes,C,nodeDofs,Desplazamientos,ndofel_5,nnodel,ndof,Time,PorePressure,Biot,d);
% ESTRATO 4
[S4,campoDef4]    =  tension_deformacion(nel_4,unod,ele_strat4,nodes,C,nodeDofs,Desplazamientos,ndofel_4,nnodel,ndof,Time,PorePressure,Biot,d);
% ESTRATO 3
[S3,campoDef3]    =  tension_deformacion(nel_3,unod,ele_strat3,nodes,C,nodeDofs,Desplazamientos,ndofel_3,nnodel,ndof,Time,PorePressure,Biot,d);
% ESTRATO 2
[S2,campoDef2]    =  tension_deformacion(nel_2,unod,ele_strat2,nodes,C,nodeDofs,Desplazamientos,ndofel_2,nnodel,ndof,Time,PorePressure,Biot,d);
% ESTRATO 1
[S1,campoDef1]    =  tension_deformacion(nel_1,unod,ele_strat1,nodes,C,nodeDofs,Desplazamientos,ndofel_1,nnodel,ndof,Time,PorePressure,Biot,d);    

% % SECCION 125 m
[S_125] = tension_deformacion(seccion125.size,unod,seccion125.elements,nodes,C,nodeDofs,Desplazamientos,ndofel,nnodel,ndof,Time,PorePressure,Biot,d);
[S_150] = tension_deformacion(seccion150.size,unod,seccion150.elements,nodes,C,nodeDofs,Desplazamientos,ndofel,nnodel,ndof,Time,PorePressure,Biot,d);
[S_175] = tension_deformacion(seccion175.size,unod,seccion175.elements,nodes,C,nodeDofs,Desplazamientos,ndofel,nnodel,ndof,Time,PorePressure,Biot,d);
[S_200] = tension_deformacion(seccion200.size,unod,seccion200.elements,nodes,C,nodeDofs,Desplazamientos,ndofel,nnodel,ndof,Time,PorePressure,Biot,d);


%% -------------------------------------------------------- Calcula caudales
% 
Qcaudal = zeros(nel,nnodel,ndof,length(Time));
for itime = 1:length(Time)
    for iele = 1:nel
        for npg = 1:size(unod,1)
            % Punto de Gauss
            ksi = unod(npg,1);
            eta = unod(npg,2);  
            zeta = unod(npg,3);

            % Derivadas de las funciones de forma respecto de ksi, eta, zeta         
            dN = [ ((eta - 1)*(zeta + 1))/8, -((eta - 1)*(zeta - 1))/8, ((eta + 1)*(zeta - 1))/8, -((eta + 1)*(zeta + 1))/8, -((eta - 1)*(zeta + 1))/8, ((eta - 1)*(zeta - 1))/8, -((eta + 1)*(zeta - 1))/8, ((eta + 1)*(zeta + 1))/8
                   ((ksi - 1)*(zeta + 1))/8, -((ksi - 1)*(zeta - 1))/8, ((ksi - 1)*(zeta - 1))/8, -((ksi - 1)*(zeta + 1))/8, -((ksi + 1)*(zeta + 1))/8, ((ksi + 1)*(zeta - 1))/8, -((ksi + 1)*(zeta - 1))/8, ((ksi + 1)*(zeta + 1))/8
                   ((eta - 1)*(ksi - 1))/8,  -((eta - 1)*(ksi - 1))/8,  ((eta + 1)*(ksi - 1))/8,  -((eta + 1)*(ksi - 1))/8,  -((eta - 1)*(ksi + 1))/8,  ((eta - 1)*(ksi + 1))/8,  -((eta + 1)*(ksi + 1))/8,  ((eta + 1)*(ksi + 1))/8 ];

            dN = dN(:,[8,4,1,5,7,3,2,6]);

            eleDofs = elements(iele,:);
            eleDofs = reshape(eleDofs',[],1);
            Qcaudal(iele,npg,:,itime) = Kperm*dN*PorePressure(eleDofs,itime);

        end
    end
end


% % GUARDAR DATOS
% toc
addpath('animacion3');
nombre2='Malla';
filename2=['F:\Corridas\GeoMec\ADINA_Mallas\Malla 1\FSI-V7 Nachote\animacion3\',nombre2,'.mat'];
save(filename2,'seccion125','seccion150','seccion175','seccion200','ele_strat6','ele_strat7','ele_strat8','nel_10','nodes_tot','nel_9','nel_8','nel_7','nel_6')

for itime = 1:length(Time)
    nombre=strcat('Iter',num2str(itime));
    filename=['F:\Corridas\GeoMec\ADINA_Mallas\Malla 1\FSI-V7 Nachote\animacion3\',nombre,'.mat'];
    save(filename,'seccion125','seccion150','seccion175','seccion200','S_125','S_150','S_175','S_200','S6','S7','S8','desplaza','ele_strat6','ele_strat7','ele_strat8','nel_10','nodes_tot','nodePosition')
end

% plot
caras = [1 2 3 4
         5 6 7 8
         2 6 7 3 
         1 4 8 5
         1 2 6 5
         3 4 8 7]; 
%      
% nodePosition = nodes_tot + D_1*500;
% % % 
% % % 
% for itime = 1:length(Time)
%     for j = 2%:3;%1:size(C_10(:,1),1)     % j es el contador de tensiones
%         for iele=1:nel_10
%             for icara=1:size(caras,1)
% 
%         %         view(2)
%                 figure(itime)
%         % %         figure(10)
% 
%     %             fill3(nodePosition(ele_strat1(iele,caras(icara,:)),1,itime),nodePosition(ele_strat1(iele,caras(icara,:)),2,itime),nodePosition(ele_strat1(iele,caras(icara,:)),3,itime),S1(iele,caras(icara,:),j,itime));
%                 hold on
% %                 fill3(nodePosition(ele_strat2(iele,caras(icara,:)),1,itime),nodePosition(ele_strat2(iele,caras(icara,:)),2,itime),nodePosition(ele_strat2(iele,caras(icara,:)),3,itime),S2(iele,caras(icara,:),j,itime));
% %                 fill3(nodePosition(ele_strat3(iele,caras(icara,:)),1,itime),nodePosition(ele_strat3(iele,caras(icara,:)),2,itime),nodePosition(ele_strat3(iele,caras(icara,:)),3,itime),S3(iele,caras(icara,:),j,itime));
% %                 fill3(nodePosition(ele_strat4(iele,caras(icara,:)),1,itime),nodePosition(ele_strat4(iele,caras(icara,:)),2,itime),nodePosition(ele_strat4(iele,caras(icara,:)),3,itime),S4(iele,caras(icara,:),j,itime));
% %                 fill3(nodePosition(ele_strat5(iele,caras(icara,:)),1,itime),nodePosition(ele_strat5(iele,caras(icara,:)),2,itime),nodePosition(ele_strat5(iele,caras(icara,:)),3,itime),S5(iele,caras(icara,:),j,itime));
%                 fill3(nodePosition(ele_strat6(iele,caras(icara,:)),1,itime),nodePosition(ele_strat6(iele,caras(icara,:)),2,itime),nodePosition(ele_strat6(iele,caras(icara,:)),3,itime),S6(iele,caras(icara,:),j,itime));
%                 fill3(nodePosition(ele_strat7(iele,caras(icara,:)),1,itime),nodePosition(ele_strat7(iele,caras(icara,:)),2,itime),nodePosition(ele_strat7(iele,caras(icara,:)),3,itime),S7(iele,caras(icara,:),j,itime));
%                 fill3(nodePosition(ele_strat8(iele,caras(icara,:)),1,itime),nodePosition(ele_strat8(iele,caras(icara,:)),2,itime),nodePosition(ele_strat8(iele,caras(icara,:)),3,itime),S8(iele,caras(icara,:),j,itime));
% %                 fill3(nodePosition(ele_strat9(iele,caras(icara,:)),1,itime),nodePosition(ele_strat9(iele,caras(icara,:)),2,itime),nodePosition(ele_strat9(iele,caras(icara,:)),3,itime),S9(iele,caras(icara,:),j,itime));
% %                 fill3(nodePosition(ele_strat10(iele,caras(icara,:)),1,itime),nodePosition(ele_strat10(iele,caras(icara,:)),2,itime),nodePosition(ele_strat10(iele,caras(icara,:)),3,itime),S10(iele,caras(icara,:),j,itime));
% 
%             end
%         end
%     end
% end


% colorbar

toc


