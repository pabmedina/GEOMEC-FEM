clc 
clearvars
tic
% close all

nodes = [ 0 0
          1 0]*1000;
      
elements = [1 2];
%             2 3
%             2 3];
        
        
nNod = size(nodes,1);
nel = size(elements,1);
nDofNod = 1;
ndoftot=nNod*nDofNod;

A = 40*50;  % Area de cada elemento 

q = 10000;



R = zeros(nNod,nDofNod);               % Vector de cargas                   
R(2,1) = q; 


bc = false(nNod,nDofNod);       % Matriz de condiciones de borde
bc(1,1) = true;
% bc(end) = true;



% Propiedades del Material
E_0 = 210E3;

E = E_0;
    
% Armado Matriz de Rigidez
K = zeros(nDofNod*nNod);

for iele = 1:nel;
    dir = nodes(elements(iele,2),:) - nodes(elements(iele,1),:);
    le = norm(dir);
    Ke =  A*E_0/le * [ 1 -1
                    -1  1 ];
    eleDofs = node2dof(elements(iele,:),nDofNod);     
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;
end


% Reduccion Matriz
fixed = reshape(bc',[],1);
free = ~fixed;

Rr = reshape(R',[],1);

% Solver
Dr = K(free,free)\Rr(free);
% Reconstruccion
D = zeros(nDofNod*nNod,1);
D(free) = D(free) + Dr;


%%  Energía potencial elástica
Desp = D.^2;
pi = 0.5*D'*(K)*D - D'*R;
 
    
toc
% end