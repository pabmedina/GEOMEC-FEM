clc
clearvars
%% Malla

% Vamos a realizar 4 elementos H8, separados por un resorte

nodes = [  1   0.5   1
           0    1    1
           0    0    1
           1    0    1
           1    1    0
           0    1    0
           0    0    0
           1    0    0    % El_1
           2    1    1
           2    0    1
           2    1    0
           2    0    0    % El_2
           1    2    1
           0    2    1
           1    1.5  1
           1    2    0
           0    2    0
           2    2    1
           2    2    0]*1e3;
       
       
elements = [ 1 2 3 4 5 6 7 8
             9 1 4 10 11 5 8 12
             13 14 2 15 16 17 6 5
             18 13 15 9 19 16 5 11];
         
         
% meshplot3D(elements,nodes,'b','w')

nnod = size(nodes,1);
nel = size(elements,1);
nnodel = 8;
ndof = 3;
ndoftot = nnod*ndof;

%% Propiedades constitutivas del estrato 9

EV_9 = 7.959E3;
EH_9 = 12.4598E3;

NuV_9 = 0.19;
NuH_9 = 0.27;

A_9 = EH_9/((1 + NuH_9)*((EH_9/EV_9)*(1 - NuH_9) - (2*NuV_9^2)));

A11_9 = A_9*((EH_9/EV_9) - NuV_9^2);
A22_9 = A11_9;

A12_9 = A_9*((EH_9/EV_9)*NuH_9 + NuV_9^2);
A21_9 = A12_9;

A13_9 = A_9*NuV_9*(1 + NuH_9);
A23_9 = A13_9;
A31_9 = A13_9;
A32_9 = A13_9;

A33_9 = A_9*(1 - NuH_9^2);

Gv_9 = EV_9/(2*(1 + NuV_9));

Gh_9 = EH_9/(2*(1 + NuH_9));


%% Tensor Constitutivo Estrato 9 [C] 6x6
% Material transversalmente isotrópico

C_9 = [ A11_9 A12_9 A13_9    0      0      0
        A21_9 A22_9 A23_9    0      0      0
        A31_9 A32_9 A33_9    0      0      0
        0      0      0      Gv_9   0      0
        0      0      0      0      Gv_9   0
        0      0      0      0      0      Gh_9];
    
    
%% [K_9] Estrato 9
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
     
K = zeros(ndoftot);

npg = size(upg,1);
wpg = ones(npg,1);



ndofel = nnodel*ndof;

nodeDofs = reshape(1:ndoftot,ndof,nnod)';

for iele = 1:nel
    
    Ke_9 = zeros(ndofel);
    nodesEle = nodes(elements(iele,:),:);
    
    for ipg = 1:npg
        % Punto de Gauss
        ksi = upg(ipg,1);
        eta = upg(ipg,2);  
        zeta = upg(ipg,3);
        
        % Funciones de forma
        N = [ (1-ksi)*(1-eta)*(1+zeta)/8, (1-ksi)*(1-eta)*(1-zeta)/8, (1-ksi)*(1+eta)*(1-zeta)/8.... 
              (1-ksi)*(1+eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1-zeta)/8....
              (1+ksi)*(1+eta)*(1-zeta)/8, (1+ksi)*(1+eta)*(1+zeta)/8 ];
          
        N = N(1,[8,4,1,5,7,3,2,6]);   
        
        % Derivadas de las funciones de forma respecto de ksi, eta, zeta         
        dN = [ ((eta - 1)*(zeta + 1))/8, -((eta - 1)*(zeta - 1))/8, ((eta + 1)*(zeta - 1))/8, -((eta + 1)*(zeta + 1))/8, -((eta - 1)*(zeta + 1))/8, ((eta - 1)*(zeta - 1))/8, -((eta + 1)*(zeta - 1))/8, ((eta + 1)*(zeta + 1))/8
               ((ksi - 1)*(zeta + 1))/8, -((ksi - 1)*(zeta - 1))/8, ((ksi - 1)*(zeta - 1))/8, -((ksi - 1)*(zeta + 1))/8, -((ksi + 1)*(zeta + 1))/8, ((ksi + 1)*(zeta - 1))/8, -((ksi + 1)*(zeta - 1))/8, ((ksi + 1)*(zeta + 1))/8
               ((eta - 1)*(ksi - 1))/8,  -((eta - 1)*(ksi - 1))/8,  ((eta + 1)*(ksi - 1))/8,  -((eta + 1)*(ksi - 1))/8,  -((eta - 1)*(ksi + 1))/8,  ((eta - 1)*(ksi + 1))/8,  -((eta + 1)*(ksi + 1))/8,  ((eta + 1)*(ksi + 1))/8 ];
        
        dN = dN(:,[8,4,1,5,7,3,2,6]);

        jac = dN*nodesEle;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C_9,1),ndofel);

        B(1,1:ndof:ndofel) = dNxyz(1,:);
        B(2,2:ndof:ndofel) = dNxyz(2,:); 
        B(3,3:ndof:ndofel) = dNxyz(3,:);
        B(4,1:ndof:ndofel) = dNxyz(2,:);
        B(4,2:ndof:ndofel) = dNxyz(1,:);
        B(5,2:ndof:ndofel) = dNxyz(3,:);
        B(5,3:ndof:ndofel) = dNxyz(2,:);
        B(6,1:ndof:ndofel) = dNxyz(3,:);
        B(6,3:ndof:ndofel) = dNxyz(1,:);

        Ke_9 = Ke_9 + B'*C_9*B*wpg(ipg)*det(jac);             
    end
 
    eleDofs = nodeDofs(elements(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke_9;  
end

% % % elements_Barra = [ 1 15];
% % %                
% % %                
% % % nelB = size(elements_Barra,1);    
% % % 
% % % %% Ensamble de los elementos barra a la K global
% % % A_Barra = 1000;
% % % E_Barra = 1e10;
% % % 
% % % for iele = 1:nelB
% % %     dir = nodes(elements_Barra(iele,2),1:2) - nodes(elements_Barra(iele,1),1:2);
% % %     L = norm(dir);
% % %     dir = dir / L;
% % %     k = E_Barra*A_Barra / L;
% % %     ke_B  = [ k -k
% % %              -k  k ];    % matriz de rigidez en coordenadas locales
% % %     T = [ dir 0 0
% % %           0 0 dir ];
% % %     ke_Barra = T' * ke_B * T; 
% % %     eleDofs = nodeDofs(elements_Barra(iele,:),1:2);
% % %     eleDofs = reshape(eleDofs',[],1);
% % %     K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + ke_Barra;
% % % end
%% Vamos a poner el "resorte"

% gap = nodes(15,2)-nodes(1,2);

p = -1000000;

% R = zeros(ndoftot,1);
R = zeros(nnod,ndof);

R(1,2)=p;
R(15,2)=-p;

% R(3,2)=p;
% R(4,2)=p;
% R(10,2)=p;
% R(7,2)=p;
% R(8,2)=p;
% R(12,2)=p;
% 
% R(18,2)=-p;
% R(13,2)=-p;
% R(19,2)=-p;
% R(16,2)=-p;
% R(14,2)=-p;
% R(17,2)=-p;

bc = false(nnod,ndof);
bc(nodes(:,3)==0,[1 2 3])= true;


%% Reducción de matriz
fixed = reshape(bc',[],1);
free = ~fixed;
Rr = reshape(R',[],1);

%% Solver
Dr = K(free,free)\Rr(free);

%% Reconstrucción
D = zeros(ndoftot,1);
D(free) = D(free) + Dr;

%% Configuracion deformada
D_1 = (reshape(D,ndof,[]))';
nodePosition = nodes + D_1*5000;


% figure(1)
% meshplot3D(elements,nodePosition,'b','w')

%% La hora de la verdad

gap = D_1(15,2) - D_1(1,2),
elements_Barra = [ 1 15];                         
nelB = size(elements_Barra,1);    


if gap<0
    A_Barra = 1000;
    E_Barra = 1e10;
    for iele = 1:nelB
        dir = nodes(elements_Barra(iele,2),1:2) - nodes(elements_Barra(iele,1),1:2);
        L = norm(dir);
        dir = dir/L;
        k = E_Barra*A_Barra/L;
        
        ke_B = [ k  -k
                -k   k];
            
        T = [ dir  0 0
              0 0  dir];
          
        ke_Barra = T'*ke_B*T;
        eleDofs = nodeDofs(elements_Barra(iele,:),1:2);
        eleDofs = reshape(eleDofs',[],1);
        K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + ke_Barra;
    end
    
    % Solver
    Dr = K(free,free)\Rr(free);

    % Reconstrucción
    D = zeros(ndoftot,1);
    D(free) = D(free) + Dr;

    % Configuracion deformada
    D_1 = (reshape(D,ndof,[]))';
    nodePosition_1 = nodes + D_1*5000;
    
    gap1 = D_1(15,2) - D_1(1,2);
end

desplazamiento1 = 0.15;

if gap>0 && gap<desplazamiento1
    
    A_Barra = 1000;
    E_Barra = 1e2;
    for iele = 1:nelB
        dir = nodes(elements_Barra(iele,2),1:2) - nodes(elements_Barra(iele,1),1:2);
        L = norm(dir);
        dir = dir/L;
        k = E_Barra*A_Barra/L;
        
        ke_B = [ k  -k
                -k   k];
            
        T = [ dir  0 0
              0 0  dir];
          
        ke_Barra = T'*ke_B*T;
        eleDofs = nodeDofs(elements_Barra(iele,:),1:2);
        eleDofs = reshape(eleDofs',[],1);
        K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + ke_Barra;
    end
    
    % Solver
    Dr = K(free,free)\Rr(free);

    % Reconstrucción
    D = zeros(ndoftot,1);
    D(free) = D(free) + Dr;

    % Configuracion deformada
    D_1 = (reshape(D,ndof,[]))';
    nodePosition_1 = nodes + D_1*50;
    
    gap2 = D_1(15,2) - D_1(1,2);    
end

desplazamiento2 = 2;

if gap>desplazamiento1 && gap<desplazamiento2
    
    A_Barra = 1000;
    E_Barra = -1e2;
    
    for iele = 1:nelB
        dir = nodes(elements_Barra(iele,2),1:2) - nodes(elements_Barra(iele,1),1:2);
        L = norm(dir);
        dir = dir/L;
        k = E_Barra*A_Barra/L;
        
        ke_B = [ k  -k
                -k   k];
            
        T = [ dir  0 0
              0 0  dir];
          
        ke_Barra = T'*ke_B*T;
        eleDofs = nodeDofs(elements_Barra(iele,:),1:2);
        eleDofs = reshape(eleDofs',[],1);
        K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + ke_Barra;
    end
    
    % Solver
    Dr = K(free,free)\Rr(free);

    % Reconstrucción
    D = zeros(ndoftot,1);
    D(free) = D(free) + Dr;

    % Configuracion deformada
    D_1 = (reshape(D,ndof,[]))';
    nodePosition_1 = nodes + D_1*50;
    
    gap3 = D_1(15,2) - D_1(1,2);   
end

if gap > desplazamiento2
    
    A_Barra = 1000;
    E_Barra = 0;
    
    for iele = 1:nelB
        dir = nodes(elements_Barra(iele,2),1:2) - nodes(elements_Barra(iele,1),1:2);
        L = norm(dir);
        dir = dir/L;
        k = E_Barra*A_Barra/L;
        
        ke_B = [ k  -k
                -k   k];
            
        T = [ dir  0 0
              0 0  dir];
          
        ke_Barra = T'*ke_B*T;
        eleDofs = nodeDofs(elements_Barra(iele,:),1:2);
        eleDofs = reshape(eleDofs',[],1);
        K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + ke_Barra;
    end
    
    % Solver
    Dr = K(free,free)\Rr(free);

    % Reconstrucción
    D = zeros(ndoftot,1);
    D(free) = D(free) + Dr;

    % Configuracion deformada
    D_1 = (reshape(D,ndof,[]))';
    nodePosition_1 = nodes + D_1*5;
    
    gap4 = D_1(15,2) - D_1(1,2);  
end


% figure(2)
% meshplot3D(elements,nodePosition_1,'b','w')



% % % % % % % % % % % % % % %% Multiplicadores de Lagrange
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % %Debo agregar tantas ecuaciones e incógnitas como restricciones impongo (1).
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % %% Impongo restricciones
% % % % % % % % % % % % % % Con = zeros(3,ndoftot);
% % % % % % % % % % % % % % Con(1,[2 44]) = [1 1];   % Para dejar el gap
% % % % % % % % % % % % % % Con(2,[1 43]) = [1 -1];  % u1 = u15
% % % % % % % % % % % % % % Con(3,[3 45]) = [1 -1];  % w1 = w15
% % % % % % % % % % % % % % Q = [gap 0 0]';
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % isFreeLagrange = true(ndoftot+3,1);
% % % % % % % % % % % % % % isFreeLagrange(1:ndoftot) = free;
% % % % % % % % % % % % % % KLagrange = zeros(ndoftot+3,ndoftot+3);
% % % % % % % % % % % % % % KLagrange(1:ndoftot,1:ndoftot) = K; 
% % % % % % % % % % % % % % KLagrange([ndoftot+1 ndoftot+2 ndoftot+3],1:ndoftot) = Con;
% % % % % % % % % % % % % % KLagrange(1:ndoftot,[ndoftot+1 ndoftot+2 ndoftot+3]) = Con';
% % % % % % % % % % % % % % KLagrange([ndoftot+1 ndoftot+2 ndoftot+3],[ndoftot+1 ndoftot+2 ndoftot+3]) = zeros(3);
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % RLagrange = zeros(ndoftot+3,1);
% % % % % % % % % % % % % % RLagrange(1:ndoftot) = Rr;
% % % % % % % % % % % % % % RLagrange(ndoftot+1:ndoftot+3) = Q;
% % % % % % % % % % % % % %  
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % %Solver
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % DLagrange = KLagrange(isFreeLagrange,isFreeLagrange)\RLagrange(isFreeLagrange);
% % % % % % % % % % % % % %  
% % % % % % % % % % % % % % % Reconstrucción
% % % % % % % % % % % % % % D2 = zeros(ndoftot,1);
% % % % % % % % % % % % % % nLag = size(DLagrange,1);
% % % % % % % % % % % % % % D2(free) = D2(free) + DLagrange(1:nLag-3);
% % % % % % % % % % % % % % D_2 = (reshape(D2,ndof,[]))';
% % % % % % % % % % % % % % nodePosition2 = nodes + D_2;
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % figure(3)
% % % % % % % % % % % % % % meshplot3D(elements,nodePosition2,'b','w')
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % aa = [nodes nodePosition2];
% % % % % % % % % % % % % % posta = aa([1 15],[2 5]);
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % D_2(1,2)
% % % % % % % % % % % % % % D_2(15,2)
% % % % % % % % % % % % % % 
% % % % % % % % % % % % % % prueba = gap-D_2(15,2)
% % % % % % % % % % % % % % prueba2 = D_2(1,2) + D_2(15,2)
% % % % % % % % % % % % % % % defnogap = posta(2,1)-posta(1,1)
% % % % % % % % % % % % % % % defgap = posta(2,2)-posta(1,2)