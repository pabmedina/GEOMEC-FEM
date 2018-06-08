clc
clearvars
close all
tic
 %% Malla

 
malla = 'M3';%'M3';%'M3';%'M1';%

switch malla
    case 'M1'
        nodesload = load('nodes8000.txt');
        nodes = nodesload(:,[2,3,4]);
        elementsload = load('elements8000.txt');
        elements = elementsload(:,2:9);   
    case 'M2'
        nodesload = load('nodes15625.txt');
        nodes = nodesload(:,[2,3,4]);
        elementsload = load('elements15625.txt');
        elements = elementsload(:,2:9);    
    case 'M3'
        nodesload = load('nodes27000.txt');
        nodes = nodesload(:,[2,3,4]);
        elementsload = load('elements27000.txt');
        elements = elementsload(:,2:9);    
end
 
% meshplot3D(elements,nodes,'b','w')

nNod = size(nodes,1);    % numero de nodos sin considerar los resortes
nel = size(elements,1);

ndof = 3;
ndoftot = nNod*ndof;     % Sin considerar los dof de los resortes que se tienen que adicionar para armar el "flan"
nnodel = 8;
ndofel = 24;
nnod=nNod;



%% Propiedades constitutivas del estrato 10

[C_10] = propiedades_constitutivas;

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
nel_10    = nel;
ndofel_10 = ndofel;

% [ aux1, aux2, aux3, aux4, aux5, aux6, aux7, aux8, aux9, aux10] = auxiliares(nnod,d_estrato_10,d_estrato_9,d_estrato_8,d_estrato_7, d_estrato_6, d_estrato_5, d_estrato_4, d_estrato_3, d_estrato_2,d_estrato_1, nodes);

% nnod_10 = size(nodes_strat10,1);

[row_10, col_10, nodesEle_10] = get_mapping_strat(nel,nodeDofs,elements,nodes,ndofel,nnodel,ndof);

fcn = @plus;

for iele = 1:nel_10
    Ke_10       =   element_stiffness(npg,upg,nodesEle_10(:,:,iele),C_10,ndofel,wpg,ndof);
    [ROW, COL]  =   get_map(row_10(:,:,iele),col_10(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_10,ndoftot,ndoftot));
end


