clc
clearvars

nodes = [ 0 0
          1 0
          1 0
          2 0];
      
elements = [ 1 2
             3 4];
         
nDofNod = 1;                    % Número de grados de libertad por nodo
nel = size(elements,1);         % Número de elementos
nNod = size(nodes,1);           % Número de nodos
ndoftot = nDofNod*nNod;

%% condiciones de borde

bc = false(nNod,nDofNod);       % Matriz de condiciones de borde
bc(1) = true;
bc(4,1) = true;

%% Reduccion Matriz
fixed = reshape(bc',[],1);
free = ~fixed;


%% Vector de cargas

R = zeros(nNod,nDofNod);               % Vector de cargas                   
R(2) = -100;
R(3) = 100;
Rr = reshape(R',[],1);

%% Armado Matriz de Rigidez

A = 1;
E = [210E1 210E1 210E1];
K = zeros(nDofNod*nNod);


for iele = 1:nel;
    dir = nodes(elements(iele,2),:) - nodes(elements(iele,1),:);
    le = norm(dir);

    Ke =  A*E(iele)/le * [ 1 -1
                          -1  1 ];

    eleDofs = node2dof(elements(iele,:),nDofNod);     
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;
end

%% Multiplicadores de Lagrange
% 
% % %Debo agregar tantas ecuaciones e incógnitas como restricciones impongo (1).
% 
% %% Impongo restricciones
Con = zeros(2,ndoftot);
Con(1,2) = 1;  % u2 = -u3 pero opuestas
Con(2,3) = 1;

Q = zeros(2,1);
%     Q = 0';

isFreeLagrange = true(ndoftot+2,1);
isFreeLagrange(1:ndoftot) = free;
KLagrange = zeros(ndoftot+2,ndoftot+2);
KLagrange(1:ndoftot,1:ndoftot) = K; 
KLagrange(ndoftot+1:ndoftot+2 ,1:ndoftot) = Con;
KLagrange(1:ndoftot,ndoftot+1:ndoftot+2) = Con';
KLagrange(ndoftot+1:ndoftot+2,ndoftot+1:ndoftot+2) = 0;

RLagrange = zeros(ndoftot+2,1);
RLagrange(1:ndoftot) = Rr;
RLagrange(ndoftot+1:end) = Q;


%% Solver

DLagrange = KLagrange(isFreeLagrange,isFreeLagrange)\RLagrange(isFreeLagrange);

% Reconstrucción
D2 = zeros(ndoftot,1);
nLag = size(DLagrange,1);
D2(free) = D2(free) + DLagrange(1:nLag-2);
D_2 = (reshape(D2,nDofNod,[]))';
nodePosition = nodes(:,1) + D_2;

%% Zona cohesiva



% %% Multiplicadores de Lagrange
% % 
% % % %Debo agregar tantas ecuaciones e incógnitas como restricciones impongo (1).
% % 
% % %% Impongo restricciones
% Con = zeros(1,ndoftot);
% Con(1,[2 3]) = [1 -1];  % u2 = -u3 pero opuestas
% 
% 
% % Q = zeros(2,1);
% Q = 0';
% 
% isFreeLagrange = true(ndoftot+1,1);
% isFreeLagrange(1:ndoftot) = free;
% KLagrange = zeros(ndoftot+1,ndoftot+1);
% KLagrange(1:ndoftot,1:ndoftot) = K; 
% KLagrange(ndoftot+1 ,1:ndoftot) = Con;
% KLagrange(1:ndoftot,ndoftot+1) = Con';
% KLagrange(ndoftot+1,ndoftot+1) = 0;
% 
% RLagrange = zeros(ndoftot+1,1);
% RLagrange(1:ndoftot) = Rr;
% RLagrange(ndoftot+1:end) = Q;
% 
% 
% %% Solver
% 
% DLagrange = KLagrange(isFreeLagrange,isFreeLagrange)\RLagrange(isFreeLagrange);
% 
% % Reconstrucción
% D2 = zeros(ndoftot,1);
% nLag = size(DLagrange,1);
% D2(free) = D2(free) + DLagrange(1:nLag-1);
% D_2 = (reshape(D2,nDofNod,[]))';
% nodePosition = nodes(:,1) + D_2;

%% Tensión 
S = zeros(1,nel);
for iele = 1:nel;
    dir = nodes(elements(iele,2),:) - nodes(elements(iele,1),:);
    le = norm(dir);

    B = [-1 1]/le;
    eleDofs = node2dof(elements(iele,:),nDofNod);
    S(iele) = E(iele) * B *D_2(eleDofs);
end

