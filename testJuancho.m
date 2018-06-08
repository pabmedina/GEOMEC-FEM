clc
clearvars

addpath('mallas')

nodesload = load('nodesPatch.txt');
nodes = nodesload(:,[2,3,4]);
elementsload = load('elementsPatch.txt');
elements = elementsload(:,2:9);    

% meshplot3D(elements,nodes,'b','w')

ndof = 3;
nnodel = 8;
ndofel = 24;
nNod = size(nodes,1);    % numero de nodos sin considerar los resortes
nel = size(elements,1);
nDofTot = nNod*ndof;  


EV_10 = 7.6599E9;
EH_10 = 12.128E9;

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


%% Tensor Constitutivo Estrato 10 [C] 6x6
% Material transversalmente isotrópico

C = [ A11_10 A12_10 A13_10 0      0      0
         A21_10 A22_10 A23_10 0      0      0
         A31_10 A32_10 A33_10 0      0      0
         0      0      0      Gv_10  0      0
         0      0      0      0      Gv_10  0
         0      0      0      0      0      Gh_10];
     
     

nodeDofs = reshape(1:nDofTot,ndof,nNod)';


%% Gauss

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


A = cell(3,1);
for iele = 1%1:nel
    Ke = sparse(ndof*nnodel,ndof*nnodel);
%     Re = zeros(ndof*nnodel,1);
    nodesEle = nodes(elements(iele,:),:);
    for ipg = 1:npg
        % Punto de Gauss
        ksi = upg(ipg,1);
        eta = upg(ipg,2);
        zeta= upg(ipg,3);
        % Derivadas de las funciones de forma respecto de ksi, eta, zeta
        dN = [ ((eta - 1)*(zeta + 1))/8, -((eta - 1)*(zeta - 1))/8, ((eta + 1)*(zeta - 1))/8, -((eta + 1)*(zeta + 1))/8, -((eta - 1)*(zeta + 1))/8, ((eta - 1)*(zeta - 1))/8, -((eta + 1)*(zeta - 1))/8, ((eta + 1)*(zeta + 1))/8
               ((ksi - 1)*(zeta + 1))/8, -((ksi - 1)*(zeta - 1))/8, ((ksi - 1)*(zeta - 1))/8, -((ksi - 1)*(zeta + 1))/8, -((ksi + 1)*(zeta + 1))/8, ((ksi + 1)*(zeta - 1))/8, -((ksi + 1)*(zeta - 1))/8, ((ksi + 1)*(zeta + 1))/8
               ((eta - 1)*(ksi - 1))/8,  -((eta - 1)*(ksi - 1))/8,  ((eta + 1)*(ksi - 1))/8,  -((eta + 1)*(ksi - 1))/8,  -((eta - 1)*(ksi + 1))/8,  ((eta - 1)*(ksi + 1))/8,  -((eta + 1)*(ksi + 1))/8,  ((eta + 1)*(ksi + 1))/8 ];
        
        dN = dN(:,[8,4,1,5,7,3,2,6]);
        jac = dN*nodesEle;                      
        % Derivadas de las funciones de forma respecto de x,y.
        dNxyz = jac\dN;          % dNxy = inv(jac)*dN
        
        B = zeros(size(C,2),ndof*nnodel);
        
        B(1,1:ndof:ndofel) = dNxyz(1,:);
        B(2,2:ndof:ndofel) = dNxyz(2,:); 
        B(3,3:ndof:ndofel) = dNxyz(3,:);
        B(4,1:ndof:ndofel) = dNxyz(2,:);
        B(4,2:ndof:ndofel) = dNxyz(1,:);
        B(5,2:ndof:ndofel) = dNxyz(3,:);
        B(5,3:ndof:ndofel) = dNxyz(2,:);
        B(6,1:ndof:ndofel) = dNxyz(3,:);
        B(6,3:ndof:ndofel) = dNxyz(1,:);

        
        
        Ke = Ke + B'*C*B*wpg(ipg)*det(jac);
   
        
    end
    eleDofs = nodeDofs(elements(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    
    I = repmat(eleDofs,1,size(eleDofs,1));
    J = repmat(eleDofs',size(eleDofs,1),1);
    A{1}{iele}=I;
    A{2}{iele}=J;
    A{3}{iele}=Ke;

end

I = vertcat(A{1,1}{:});
J = vertcat(A{2,1}{:});
s = vertcat(A{3,1}{:});
S = sparse(I,J,s);
