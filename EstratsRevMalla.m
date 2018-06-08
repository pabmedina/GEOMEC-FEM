clc
clearvars
close all
 %% Malla
 
malla = 'M3test';%'M3';%'M333P';%'M22';%'M333';%

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
end

nnod = size(nodes,1);
nel = size(elements,1);

ndof = 3;
ndoftot = nnod*ndof;
nnodel = 8;

ycoord_fisu1 = 100;
ycoord_fisu2 = 200;
ycoord_fisu3 = 300;

p_net1 = 20;
p_net2 = 20;
p_net3 = 20;

p_West = 0;%60;
p_East = 0;%60
p_South = 0; %60
p_North = 0; %60
p_Top = 60; %60
% meshplot3D(elements,nodes,'b','w')

%% Separamos los elementos que están en contacto con las distintas fisuras

% Nos devuelve los elementos que estan en la coordenada y = 100-

ele_fisu1_1 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) < 100  && j(inod) > 99.9
           ele_fisu1_1(iele) = true;
        end
    end
end

ele_fisu1_y1_1 = elements(ele_fisu1_1,:);
sizeFisu1_1 = size(ele_fisu1_y1_1,1);

% Nos devuelve los elementos que estan en la coordenada y = 100+

ele_fisu1_2 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) > 100  && j(inod) < 100.1
           ele_fisu1_2(iele) = true;
        end
    end
end

ele_fisu1_y1_2 = elements(ele_fisu1_2,:);
sizeFisu1_2 = size(ele_fisu1_y1_2,1);

% Nos devuelve los elementos que estan en la coordenada y = 200-

ele_fisu2_1 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) < 200  && j(inod) > 199.9
           ele_fisu2_1(iele) = true;
        end
    end
end

ele_fisu2_y2_1 = elements(ele_fisu2_1,:);
sizeFisu2_1 = size(ele_fisu2_y2_1,1);

% Nos devuelve los elementos que estan en la coordenada y = 200+

ele_fisu2_2 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) > 200  && j(inod) < 200.1
           ele_fisu2_2(iele) = true;
        end
    end
end

ele_fisu2_y2_2 = elements(ele_fisu2_2,:);
sizeFisu2_2 = size(ele_fisu2_y2_2,1);

% Nos devuelve los elementos que estan en la coordenada y = 300-

ele_fisu3_1 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) < 300  && j(inod) > 299.9
           ele_fisu3_1(iele) = true;
        end
    end
end

ele_fisu3_y3_1 = elements(ele_fisu3_1,:);
sizeFisu3_1 = size(ele_fisu3_y3_1,1);

% Nos devuelve los elementos que estan en la coordenada y = 300+

ele_fisu3_2 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) > 300  && j(inod) < 300.1
           ele_fisu3_2(iele) = true;
        end
    end
end

ele_fisu3_y3_2 = elements(ele_fisu3_2,:);
sizeFisu3_2 = size(ele_fisu3_y3_2,1);

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

tol = 0.01;
% Elementos del Estrato 10

ele_estrato10 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if i(inod) < d_estrato_10
           ele_estrato10(iele) = true;
        end
    end
end
    
ele_strat10 = elements(ele_estrato10,:);
    
% Elementos del Estrato 9

ele_estrato9 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if i(inod) < d_estrato_10 + tol && i(inod) > d_estrato_10 - tol
           ele_estrato9(iele) = true;     
        elseif i(inod) < d_estrato_9
           ele_estrato9(iele) = false;
        end

    end
end
  
ele_strat9 = elements(ele_estrato9,:);    

% Elementos del Estrato 8

ele_estrato8 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if i(inod)< d_estrato_8 && i(inod)>d_estrato_9
            ele_estrato8(iele) = true;
        end
%         if i(inod) < d_estrato_9 + tol && i(inod) > d_estrato_9 - tol
%            ele_estrato8(iele) = true;     
%         elseif i(inod) < d_estrato_8
%            ele_estrato8(iele) = false;    % aca esta el problema
%         end

    end
end
   
ele_strat8 = elements(ele_estrato8,:);

% Elementos del Estrato 7

ele_estrato7 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if i(inod) < d_estrato_8 + tol && i(inod) > d_estrato_8 - tol
           ele_estrato7(iele) = true;     
        elseif i(inod) < d_estrato_7
           ele_estrato7(iele) = false;
        end

    end
end
   
ele_strat7 = elements(ele_estrato7,:);
                
% Elementos del Estrato 6

ele_estrato6 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if i(inod) < d_estrato_7 + tol && i(inod) > d_estrato_7 - tol
           ele_estrato6(iele) = true;     
        elseif i(inod) < d_estrato_6
           ele_estrato6(iele) = false;
        end

    end
end
   
ele_strat6 = elements(ele_estrato6,:);

% Elementos del Estrato 5

ele_estrato5 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if i(inod) < d_estrato_6 + tol && i(inod) > d_estrato_6 - tol
           ele_estrato5(iele) = true;     
        elseif i(inod) < d_estrato_5
           ele_estrato5(iele) = false;
        end

    end
end
   
ele_strat5 = elements(ele_estrato5,:);   


% Elementos del Estrato 4

ele_estrato4 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if i(inod) < d_estrato_5 + tol && i(inod) > d_estrato_5 - tol
           ele_estrato4(iele) = true;     
        elseif i(inod) < d_estrato_4
           ele_estrato4(iele) = false;
        end

    end
end
   
ele_strat4 = elements(ele_estrato4,:);

% Elementos del Estrato 3

ele_estrato3 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if i(inod) < d_estrato_4 + tol && i(inod) > d_estrato_4 - tol
           ele_estrato3(iele) = true;     
        elseif i(inod) < d_estrato_3
           ele_estrato3(iele) = false;
        end

    end
end
   
ele_strat3 = elements(ele_estrato3,:);

% Elementos del Estrato 2

ele_estrato2 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if i(inod) < d_estrato_3 + tol && i(inod) > d_estrato_3 - tol
           ele_estrato2(iele) = true;     
        elseif i(inod) < d_estrato_2
           ele_estrato2(iele) = false;
        end

    end
end
   
ele_strat2 = elements(ele_estrato2,:);


% Elementos del Estrato 1

ele_estrato1 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if i(inod) < d_estrato_2 + tol && i(inod) > d_estrato_2 - tol
           ele_estrato1(iele) = true;     
        elseif i(inod) < d_estrato_1
           ele_estrato1(iele) = false;
        end

    end
end
   
ele_strat1 = elements(ele_estrato1,:);



%% Propiedades constitutivas del estrato 10

[ C_1, C_2, C_3, C_4, C_5, C_6, C_7, C_8, C_9, C_10] = propiedades_constitutivas;
    
%% Armamos las matrices de rigidez de cada estrato [K_10, K_9, K_8,....., K_1]

% Gauss. Es una integración Full? Ver orden, pero me parece que si, ya que los elementos tienen un de deformación lineal  

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

aux10 = false(nnod,1);
aux10(nodes(:,3)<d_estrato_10+0.01,1) = true;

ndoftot_10 = sum(aux10)*ndof;

K = sparse(ndoftot,ndoftot);

nel_10 = size(ele_strat10,1);
ndofel_10 = nnodel*ndof;

nodes_strat10 = nodes(aux10,:);
nnod_10 = size(nodes_strat10,1);
nodeDofs = reshape(1:ndoftot,ndof,nnod)';

eigsval=zeros(13,nel_10);

for iele = 1:nel_10
    
    Ke_10 = sparse(ndofel_10,ndofel_10);
    nodesEle_10 = nodes_strat10(ele_strat10(iele,:),:);
    
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

        jac = dN*nodesEle_10;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C_10,1),ndofel_10);

        B(1,1:ndof:ndofel_10) = dNxyz(1,:);
        B(2,2:ndof:ndofel_10) = dNxyz(2,:); 
        B(3,3:ndof:ndofel_10) = dNxyz(3,:);
        B(4,1:ndof:ndofel_10) = dNxyz(2,:);
        B(4,2:ndof:ndofel_10) = dNxyz(1,:);
        B(5,2:ndof:ndofel_10) = dNxyz(3,:);
        B(5,3:ndof:ndofel_10) = dNxyz(2,:);
        B(6,1:ndof:ndofel_10) = dNxyz(3,:);
        B(6,3:ndof:ndofel_10) = dNxyz(1,:);

        Ke_10 = Ke_10 + B'*C_10*B*wpg(ipg)*det(jac);
                    
    end
    
%     eigsval(:,iele)=eigs(Ke_10,13,'SM');
    eleDofs = nodeDofs(ele_strat10(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke_10;  
end


%% [K_9] Estrato 9

aux9 = false(nnod,1);
aux9(nodes(:,3)<d_estrato_9 + 0.01,1) = true;
aux9(nodes(:,3)==0,1) = false;
ndoftot_9 = sum(aux9)*ndof;

nel_9 = size(ele_strat9,1);
ndofel_9 = nnodel*ndof;

nodes_strat9 = nodes(aux9,:);
nnod_9 = size(nodes_strat9,1);

for iele = 1:nel_9
    
    Ke_9 = sparse(ndofel_9,ndofel_9);
    nodesEle_9 = nodes(ele_strat9(iele,:),:);
    
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

        jac = dN*nodesEle_9;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C_9,1),ndofel_9);

        B(1,1:ndof:ndofel_9) = dNxyz(1,:);
        B(2,2:ndof:ndofel_9) = dNxyz(2,:); 
        B(3,3:ndof:ndofel_9) = dNxyz(3,:);
        B(4,1:ndof:ndofel_9) = dNxyz(2,:);
        B(4,2:ndof:ndofel_9) = dNxyz(1,:);
        B(5,2:ndof:ndofel_9) = dNxyz(3,:);
        B(5,3:ndof:ndofel_9) = dNxyz(2,:);
        B(6,1:ndof:ndofel_9) = dNxyz(3,:);
        B(6,3:ndof:ndofel_9) = dNxyz(1,:);

        Ke_9 = Ke_9 + B'*C_9*B*wpg(ipg)*det(jac);             
    end
 
    eleDofs = nodeDofs(ele_strat9(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke_9;  
end
    

%% [K_8] Estrato 8

aux8 = false(nnod,1);
aux8(nodes(:,3)<d_estrato_8 + 0.01,1) = true;
aux8(nodes(:,3)==0,1) = false;
aux8(nodes(:,3)==d_estrato_10,1) = false;

ndoftot_8 = sum(aux8)*ndof;

nel_8 = size(ele_strat8,1);
ndofel_8 = nnodel*ndof;

nodes_strat8 = nodes(aux8,:);
nnod_8 = size(nodes_strat8,1);

for iele = 1:nel_8
    
    Ke_8 = sparse(ndofel_8,ndofel_8);
    nodesEle_8 = nodes(ele_strat8(iele,:),:);
    
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

        jac = dN*nodesEle_8;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C_8,1),ndofel_8);

        B(1,1:ndof:ndofel_8) = dNxyz(1,:);
        B(2,2:ndof:ndofel_8) = dNxyz(2,:); 
        B(3,3:ndof:ndofel_8) = dNxyz(3,:);
        B(4,1:ndof:ndofel_8) = dNxyz(2,:);
        B(4,2:ndof:ndofel_8) = dNxyz(1,:);
        B(5,2:ndof:ndofel_8) = dNxyz(3,:);
        B(5,3:ndof:ndofel_8) = dNxyz(2,:);
        B(6,1:ndof:ndofel_8) = dNxyz(3,:);
        B(6,3:ndof:ndofel_8) = dNxyz(1,:);

        Ke_8 = Ke_8 + B'*C_8*B*wpg(ipg)*det(jac);             
    end
 
    eleDofs = nodeDofs(ele_strat8(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke_8;  
end


     
%% [K_7] Estrato 7

aux7 = false(nnod,1);
aux7(nodes(:,3)<d_estrato_7 + 0.01,1) = true;
aux7(nodes(:,3)==0,1) = false;
aux7(nodes(:,3)==d_estrato_10,1) = false;
aux7(nodes(:,3)==d_estrato_9,1) = false;


ndoftot_7 = sum(aux7)*ndof;

nel_7 = size(ele_strat7,1);
ndofel_7 = nnodel*ndof;

nodes_strat7 = nodes(aux7,:);
nnod_7 = size(nodes_strat7,1);

for iele = 1:nel_7
    
    Ke_7 = sparse(ndofel_7,ndofel_7);
    nodesEle_7 = nodes(ele_strat7(iele,:),:);
    
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

        jac = dN*nodesEle_7;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C_7,1),ndofel_7);

        B(1,1:ndof:ndofel_7) = dNxyz(1,:);
        B(2,2:ndof:ndofel_7) = dNxyz(2,:); 
        B(3,3:ndof:ndofel_7) = dNxyz(3,:);
        B(4,1:ndof:ndofel_7) = dNxyz(2,:);
        B(4,2:ndof:ndofel_7) = dNxyz(1,:);
        B(5,2:ndof:ndofel_7) = dNxyz(3,:);
        B(5,3:ndof:ndofel_7) = dNxyz(2,:);
        B(6,1:ndof:ndofel_7) = dNxyz(3,:);
        B(6,3:ndof:ndofel_7) = dNxyz(1,:);

        Ke_7 = Ke_7 + B'*C_7*B*wpg(ipg)*det(jac);             
    end
 
    eleDofs = nodeDofs(ele_strat7(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke_7;  
end

%% [K_6] Estrato 6

aux6 = false(nnod,1);
aux6(nodes(:,3)<d_estrato_6 + 0.01,1) = true;
aux6(nodes(:,3)==0,1) = false;
aux6(nodes(:,3)==d_estrato_10,1) = false;
aux6(nodes(:,3)==d_estrato_8,1) = false;
aux6(nodes(:,3)==d_estrato_9,1) = false;


ndoftot_6 = sum(aux6)*ndof;

nel_6 = size(ele_strat6,1);
ndofel_6 = nnodel*ndof;

nodes_strat6 = nodes(aux6,:);
nnod_6 = size(nodes_strat6,1);

for iele = 1:nel_6
    
    Ke_6 = sparse(ndofel_6,ndofel_6);
    nodesEle_6 = nodes(ele_strat6(iele,:),:);
    
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

        jac = dN*nodesEle_6;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C_6,1),ndofel_6);

        B(1,1:ndof:ndofel_6) = dNxyz(1,:);
        B(2,2:ndof:ndofel_6) = dNxyz(2,:); 
        B(3,3:ndof:ndofel_6) = dNxyz(3,:);
        B(4,1:ndof:ndofel_6) = dNxyz(2,:);
        B(4,2:ndof:ndofel_6) = dNxyz(1,:);
        B(5,2:ndof:ndofel_6) = dNxyz(3,:);
        B(5,3:ndof:ndofel_6) = dNxyz(2,:);
        B(6,1:ndof:ndofel_6) = dNxyz(3,:);
        B(6,3:ndof:ndofel_6) = dNxyz(1,:);

        Ke_6 = Ke_6 + B'*C_6*B*wpg(ipg)*det(jac);             
    end
 
    eleDofs = nodeDofs(ele_strat6(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke_6;  
end


%% [K_5] Estrato 5

aux5 = false(nnod,1);
aux5(nodes(:,3)<d_estrato_5 + 0.01,1) = true;
aux5(nodes(:,3)==0,1) = false;
aux5(nodes(:,3)==d_estrato_10,1) = false;
aux5(nodes(:,3)==d_estrato_9,1) = false;
aux5(nodes(:,3)==d_estrato_8,1) = false;
aux5(nodes(:,3)==d_estrato_7,1) = false;

ndoftot_5 = sum(aux5)*ndof;

nel_5 = size(ele_strat5,1);
ndofel_5 = nnodel*ndof;

nodes_strat5 = nodes(aux5,:);
nnod_5 = size(nodes_strat5,1);

for iele = 1:nel_5
    
    Ke_5 = sparse(ndofel_5,ndofel_5);
    nodesEle_5 = nodes(ele_strat5(iele,:),:);
    
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

        jac = dN*nodesEle_5;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C_5,1),ndofel_5);

        B(1,1:ndof:ndofel_5) = dNxyz(1,:);
        B(2,2:ndof:ndofel_5) = dNxyz(2,:); 
        B(3,3:ndof:ndofel_5) = dNxyz(3,:);
        B(4,1:ndof:ndofel_5) = dNxyz(2,:);
        B(4,2:ndof:ndofel_5) = dNxyz(1,:);
        B(5,2:ndof:ndofel_5) = dNxyz(3,:);
        B(5,3:ndof:ndofel_5) = dNxyz(2,:);
        B(6,1:ndof:ndofel_5) = dNxyz(3,:);
        B(6,3:ndof:ndofel_5) = dNxyz(1,:);

        Ke_5 = Ke_5 + B'*C_5*B*wpg(ipg)*det(jac);             
    end
 
    eleDofs = nodeDofs(ele_strat5(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke_5;  
end


%% [K_4] Estrato 4

aux4 = false(nnod,1);
aux4(nodes(:,3)<d_estrato_4 + 0.01,1) = true;
aux4(nodes(:,3)==0,1) = false;
aux4(nodes(:,3)==d_estrato_10,1) = false;
aux4(nodes(:,3)==d_estrato_9,1) = false;
aux4(nodes(:,3)==d_estrato_8,1) = false;
aux4(nodes(:,3)==d_estrato_7,1) = false;
aux4(nodes(:,3)==d_estrato_6,1) = false;

ndoftot_4 = sum(aux4)*ndof;

nel_4 = size(ele_strat4,1);
ndofel_4 = nnodel*ndof;

nodes_strat4 = nodes(aux4,:);
nnod_4 = size(nodes_strat4,1);

for iele = 1:nel_4
    
    Ke_4 = sparse(ndofel_4,ndofel_4);
    nodesEle_4 = nodes(ele_strat4(iele,:),:);
    
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

        jac = dN*nodesEle_4;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C_4,1),ndofel_4);

        B(1,1:ndof:ndofel_4) = dNxyz(1,:);
        B(2,2:ndof:ndofel_4) = dNxyz(2,:); 
        B(3,3:ndof:ndofel_4) = dNxyz(3,:);
        B(4,1:ndof:ndofel_4) = dNxyz(2,:);
        B(4,2:ndof:ndofel_4) = dNxyz(1,:);
        B(5,2:ndof:ndofel_4) = dNxyz(3,:);
        B(5,3:ndof:ndofel_4) = dNxyz(2,:);
        B(6,1:ndof:ndofel_4) = dNxyz(3,:);
        B(6,3:ndof:ndofel_4) = dNxyz(1,:);

        Ke_4 = Ke_4 + B'*C_4*B*wpg(ipg)*det(jac);             
    end
 
    eleDofs = nodeDofs(ele_strat4(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke_4;  
end

%% [K_3] Estrato 3

aux3 = false(nnod,1);
aux3(nodes(:,3)<d_estrato_3 + 0.01,1) = true;
aux3(nodes(:,3)==0,1) = false;
aux3(nodes(:,3)==d_estrato_10,1) = false;
aux3(nodes(:,3)==d_estrato_9,1) = false;
aux3(nodes(:,3)==d_estrato_8,1) = false;
aux3(nodes(:,3)==d_estrato_7,1) = false;
aux3(nodes(:,3)==d_estrato_6,1) = false;
aux3(nodes(:,3)==d_estrato_5,1) = false;


ndoftot_3 = sum(aux3)*ndof;

nel_3 = size(ele_strat3,1);
ndofel_3 = nnodel*ndof;

nodes_strat3 = nodes(aux3,:);
nnod_3 = size(nodes_strat3,1);

for iele = 1:nel_3
    
    Ke_3 = sparse(ndofel_3,ndofel_3);
    nodesEle_3 = nodes(ele_strat3(iele,:),:);
    
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

        jac = dN*nodesEle_3;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C_3,1),ndofel_3);

        B(1,1:ndof:ndofel_3) = dNxyz(1,:);
        B(2,2:ndof:ndofel_3) = dNxyz(2,:); 
        B(3,3:ndof:ndofel_3) = dNxyz(3,:);
        B(4,1:ndof:ndofel_3) = dNxyz(2,:);
        B(4,2:ndof:ndofel_3) = dNxyz(1,:);
        B(5,2:ndof:ndofel_3) = dNxyz(3,:);
        B(5,3:ndof:ndofel_3) = dNxyz(2,:);
        B(6,1:ndof:ndofel_3) = dNxyz(3,:);
        B(6,3:ndof:ndofel_3) = dNxyz(1,:);

        Ke_3 = Ke_3 + B'*C_3*B*wpg(ipg)*det(jac);             
    end
 
    eleDofs = nodeDofs(ele_strat3(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke_3;  
end


%% [K_2] Estrato 2

aux2 = false(nnod,1);
aux2(nodes(:,3)<d_estrato_2 + 0.01,1) = true;
aux2(nodes(:,3)==0,1) = false;
aux2(nodes(:,3)==d_estrato_10,1) = false;
aux2(nodes(:,3)==d_estrato_9,1) = false;
aux2(nodes(:,3)==d_estrato_8,1) = false;
aux2(nodes(:,3)==d_estrato_7,1) = false;
aux2(nodes(:,3)==d_estrato_6,1) = false;
aux2(nodes(:,3)==d_estrato_5,1) = false;
aux2(nodes(:,3)==d_estrato_4,1) = false;

ndoftot_2 = sum(aux2)*ndof;

nel_2 = size(ele_strat2,1);
ndofel_2 = nnodel*ndof;

nodes_strat2 = nodes(aux2,:);
nnod_2 = size(nodes_strat2,1);

for iele = 1:nel_2
    
    Ke_2 = sparse(ndofel_2,ndofel_2);
    nodesEle_2 = nodes(ele_strat2(iele,:),:);
    
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

        jac = dN*nodesEle_2;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C_2,1),ndofel_2);

        B(1,1:ndof:ndofel_2) = dNxyz(1,:);
        B(2,2:ndof:ndofel_2) = dNxyz(2,:); 
        B(3,3:ndof:ndofel_2) = dNxyz(3,:);
        B(4,1:ndof:ndofel_2) = dNxyz(2,:);
        B(4,2:ndof:ndofel_2) = dNxyz(1,:);
        B(5,2:ndof:ndofel_2) = dNxyz(3,:);
        B(5,3:ndof:ndofel_2) = dNxyz(2,:);
        B(6,1:ndof:ndofel_2) = dNxyz(3,:);
        B(6,3:ndof:ndofel_2) = dNxyz(1,:);

        Ke_2 = Ke_2 + B'*C_2*B*wpg(ipg)*det(jac);             
    end
 
    eleDofs = nodeDofs(ele_strat2(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke_2;  
end


%% [K_1] Estrato 1

aux1 = false(nnod,1);
aux1(nodes(:,3)<d_estrato_1 + 0.01,1) = true;
aux1(nodes(:,3)==0,1) = false;
aux1(nodes(:,3)==d_estrato_10,1) = false;
aux1(nodes(:,3)==d_estrato_9,1) = false;
aux1(nodes(:,3)==d_estrato_8,1) = false;
aux1(nodes(:,3)==d_estrato_7,1) = false;
aux1(nodes(:,3)==d_estrato_6,1) = false;
aux1(nodes(:,3)==d_estrato_5,1) = false;
aux1(nodes(:,3)==d_estrato_4,1) = false;
aux1(nodes(:,3)==d_estrato_3,1) = false;

ndoftot_1 = sum(aux1)*ndof;

nel_1 = size(ele_strat1,1);
ndofel_1 = nnodel*ndof;

nodes_strat1 = nodes(aux1,:);
nnod_1 = size(nodes_strat1,1);

for iele = 1:nel_1
    
    Ke_1 = sparse(ndofel_1,ndofel_1);
    nodesEle_1 = nodes(ele_strat1(iele,:),:);
    
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

        jac = dN*nodesEle_1;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C_1,1),ndofel_1);

        B(1,1:ndof:ndofel_1) = dNxyz(1,:);
        B(2,2:ndof:ndofel_1) = dNxyz(2,:); 
        B(3,3:ndof:ndofel_1) = dNxyz(3,:);
        B(4,1:ndof:ndofel_1) = dNxyz(2,:);
        B(4,2:ndof:ndofel_1) = dNxyz(1,:);
        B(5,2:ndof:ndofel_1) = dNxyz(3,:);
        B(5,3:ndof:ndofel_1) = dNxyz(2,:);
        B(6,1:ndof:ndofel_1) = dNxyz(3,:);
        B(6,3:ndof:ndofel_1) = dNxyz(1,:);

        Ke_1 = Ke_1 + B'*C_1*B*wpg(ipg)*det(jac);             
    end
 
    eleDofs = nodeDofs(ele_strat1(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke_1;  
end

