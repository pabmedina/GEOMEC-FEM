clc
clearvars

nodesload = load('nodesMegaMalla.txt');
nodes = nodesload(:,[2,3,4]);
elementsload = load('elementsMegaMalla.txt');
elements = elementsload(:,2:9);    

% meshplot3D(elements,nodes,'b','w')
nel = size(elements,1);
ndof = 3; 
nnodel = 8;
ndofel = 24;
nNod = size(nodes,1);   
nDofTot = nNod*ndof;     

%% Propiedades constitutivas del estrato 10

EV_10 = 7.6599E3;
EH_10 = 12.128E3;

NuV_10 = 0.18;
NuH_10 = 0.27;

A_10 = EH_10/((1 + NuH_10)*((EH_10/EV_10)*(1 - NuH_10) - (2*NuV_10^2)));

A11_10 = A_10*((EH_10/EV_10) - NuV_10^2);
A22_10 = A11_10;

A12_10 = A_10*((EH_10/EV_10)*NuH_10 + NuV_10^2);
A21_10 = A12_10;

A13_10 = A_10*NuV_10*(1 + NuH_10);
A23_10 = A13_10;
A31_10 = A13_10;
A32_10 = A13_10;

A33_10 = A_10*(1 - NuH_10^2);

Gv_10 = EV_10/(2*(1 + NuV_10));

Gh_10 = EH_10/(2*(1 + NuH_10));

C_10 = [ A11_10 A12_10 A13_10 0      0      0
         A21_10 A22_10 A23_10 0      0      0
         A31_10 A32_10 A33_10 0      0      0
         0      0      0      Gv_10  0      0
         0      0      0      0      Gv_10  0
         0      0      0      0      0      Gh_10];
     
     
%% [K_10] Estrato 10


GP   = 1/sqrt(3);
% % GP = 1;
% % Ubicaciones puntos de Gauss

% upg = [  GP   GP   GP
%         -GP   GP   GP
%         -GP  -GP   GP 
%          GP  -GP   GP  
%          GP   GP  -GP
%         -GP   GP  -GP
%         -GP  -GP  -GP 
%          GP  -GP  -GP ]; 

upg = [  GP   GP   1
        -GP   GP   1
        -GP  -GP   1  
         GP  -GP   1];
%          GP   GP   -1
%         -GP   GP   -1 
%         -GP  -GP   -1  
%          GP  -GP   -1]; 

npg = size(upg,1);
wpg = ones(npg,1);

K = zeros(nDofTot);

nodeDofs = reshape(1:nDofTot,ndof,nNod)';
vol=0;
area=zeros(nel,1);
% for iele = 1:nel
%     
%     Ke = zeros(ndofel);
%     nodesEle = nodes(elements(iele,:),:);
%     
%     for ipg = 1:npg
%         % Punto de Gauss
%         ksi = upg(ipg,1);
%         eta = upg(ipg,2);  
%         zeta = upg(ipg,3);
%         
%         % Funciones de forma
%         N = [ (1-ksi)*(1-eta)*(1+zeta)/8, (1-ksi)*(1-eta)*(1-zeta)/8, (1-ksi)*(1+eta)*(1-zeta)/8.... 
%               (1-ksi)*(1+eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1-zeta)/8....
%               (1+ksi)*(1+eta)*(1-zeta)/8, (1+ksi)*(1+eta)*(1+zeta)/8 ];
%           
%         N = N(1,[8,4,1,5,7,3,2,6]);  
%         
%         % Derivadas de las funciones de forma respecto de ksi, eta, zeta         
%         dN = [ ((eta - 1)*(zeta + 1))/8, -((eta - 1)*(zeta - 1))/8, ((eta + 1)*(zeta - 1))/8, -((eta + 1)*(zeta + 1))/8, -((eta - 1)*(zeta + 1))/8, ((eta - 1)*(zeta - 1))/8, -((eta + 1)*(zeta - 1))/8, ((eta + 1)*(zeta + 1))/8
%                ((ksi - 1)*(zeta + 1))/8, -((ksi - 1)*(zeta - 1))/8, ((ksi - 1)*(zeta - 1))/8, -((ksi - 1)*(zeta + 1))/8, -((ksi + 1)*(zeta + 1))/8, ((ksi + 1)*(zeta - 1))/8, -((ksi + 1)*(zeta - 1))/8, ((ksi + 1)*(zeta + 1))/8
%                ((eta - 1)*(ksi - 1))/8,  -((eta - 1)*(ksi - 1))/8,  ((eta + 1)*(ksi - 1))/8,  -((eta + 1)*(ksi - 1))/8,  -((eta - 1)*(ksi + 1))/8,  ((eta - 1)*(ksi + 1))/8,  -((eta + 1)*(ksi + 1))/8,  ((eta + 1)*(ksi + 1))/8 ];
%         
%            
%         dN = dN(:,[8,4,1,5,7,3,2,6]);
%         dN = dN(1:2,1:4);
%         
%         nodesEle = nodesEle(1:4,1:2);
%         jac = dN*nodesEle;                
%         area(iele) = area(iele) + det(jac);
%            
%     end
%     eleDofs = nodeDofs(elements(iele,:),:);
%     eleDofs = reshape(eleDofs',[],1);
%     K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;  
% end



for iele = 1:nel

    nodesEle = nodes(elements(iele,:),:);
    
    for ipg = 1:npg
        % Punto de Gauss
        ksi = upg(ipg,1);
        eta = upg(ipg,2);  
        zeta = upg(ipg,3);
        
        % Derivadas de las funciones de forma respecto de ksi, eta, zeta         
        dN = [ ((eta - 1)*(zeta + 1))/8, -((eta - 1)*(zeta - 1))/8, ((eta + 1)*(zeta - 1))/8, -((eta + 1)*(zeta + 1))/8, -((eta - 1)*(zeta + 1))/8, ((eta - 1)*(zeta - 1))/8, -((eta + 1)*(zeta - 1))/8, ((eta + 1)*(zeta + 1))/8
               ((ksi - 1)*(zeta + 1))/8, -((ksi - 1)*(zeta - 1))/8, ((ksi - 1)*(zeta - 1))/8, -((ksi - 1)*(zeta + 1))/8, -((ksi + 1)*(zeta + 1))/8, ((ksi + 1)*(zeta - 1))/8, -((ksi + 1)*(zeta - 1))/8, ((ksi + 1)*(zeta + 1))/8
               ((eta - 1)*(ksi - 1))/8,  -((eta - 1)*(ksi - 1))/8,  ((eta + 1)*(ksi - 1))/8,  -((eta + 1)*(ksi - 1))/8,  -((eta - 1)*(ksi + 1))/8,  ((eta - 1)*(ksi + 1))/8,  -((eta + 1)*(ksi + 1))/8,  ((eta + 1)*(ksi + 1))/8 ];
        
           
        dN = dN(:,[8,4,1,5,7,3,2,6]);
        dN = dN(1:2,1:4);
        
        nodesEle = nodesEle(1:4,1:2);
        jac = dN*nodesEle;                
        area(iele) = area(iele) + det(jac);
           
    end

end

nodos_interes = [6 7 10 11 14 15]';   % estos son los nodos1_fisu1 nodos2_fisu1.. etc
aux = false(nel,length(nodos_interes));

for inod = 1:length(nodos_interes)
    nodo = nodos_interes(inod);
    for iele = 1:nel
        for nodele = 1: nnodel
            ele_Node = elements(iele,nodele);
            if ele_Node == nodo
                aux(iele,inod) = true;
            end
        end
    end
end

factor_escala = zeros(length(nodos_interes),1);
for inod = 1:length(nodos_interes)
    factor_escala(inod) = sum(area(aux(:,inod)));
end

