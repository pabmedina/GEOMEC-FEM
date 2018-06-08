clc
clearvars

addpath('mallasvigaflexion')
    
malla = 'M2';
switch malla
    case 'M1'
        nodesload = load('nodesM1.txt');
        nodes = nodesload(:,[2,3]);
        elementsload = load('elementsM1.txt');
        elements = elementsload(:,2:5);    
    case 'M2'
        nodesload = load('nodesM2.txt');
        nodes = nodesload(:,[2,3]);
        elementsload = load('elementsM2.txt');
        elements = elementsload(:,2:5);  
    case 'M3'
        nodesload = load('nodesM3.txt');
        nodes = nodesload(:,[2,3]);
        elementsload = load('elementsM3.txt');
        elements = elementsload(:,2:5);         
    case 'M4'
        nodesload = load('nodesM4.txt');
        nodes = nodesload(:,[2,3]);
        elementsload = load('elementsM4.txt');
        elements = elementsload(:,2:5);    
end

eleType = 'Q4';
ndof = 2;
nNod = size(nodes,1);
nel = size(elements,1);
ndoftot = nNod*ndof;
ndofel = 8;
nnodel = 4;
meshplot(elements,nodes,'b')

%% Constitutivo Plane stress

E = 170E3;
NU = 0.33;

C = E/(1-NU^2)*[1  NU  0
                NU  1  0
                0   0 (1-NU)/2];
            
 
% Gauss

a   = 1/sqrt(3);
% Ubicaciones puntos de Gauss

upg = [ -a  -a
         a  -a
         a   a
        -a   a ];    
    
npg = size(upg,1);
wpg = ones(npg,1);
%% [K] Matriz de rigidez

nodeDofs  = reshape(1:ndoftot,ndof,nNod)';
K         = zeros(ndoftot);%sparse(ndoftot,ndoftot);

[row, col, nodesEle] = get_mapping_strat(nel,nodeDofs,elements,nodes,ndofel,nnodel,ndof);

fcn = @plus;

for iele = 1:nel
    Ke_10       =   element_stiffness(npg,upg,nodesEle(:,:,iele),C,ndofel,wpg,ndof,eleType);
    [ROW, COL]  =   get_map(row(:,:,iele),col(:,:,iele));
    K           =   fcn(K,sparse(ROW,COL,Ke_10,ndoftot,ndoftot));
end

ipa1 = false(nNod,1);
for inodo = 1:nNod
    i = nodes(inodo,1);
    if i<2 && i>1.97
        ipa1(inodo) = true;
    end
end

ipa2 = false(nNod,1);
for inodo = 1:nNod
    i = nodes(inodo,1);
    if i<2.03 && i>2
        ipa2(inodo) = true;
    end
end

nodos1_fis = find(ipa1);
nodos2_fis = find(ipa2);

elements_Barra = [nodos1_fis nodos2_fis];

nelSpringFisura  = size(elements_Barra,1);

ndofel_b = 4;
E = 100;
A = 10;
Kbarra = zeros(ndoftot);%sparse(ndoftot,ndoftot);

[row, col] = get_mapping_barra(nelSpringFisura,nodeDofs,elements_Barra,ndofel_b);
for iele = 1:nelSpringFisura
    [ke_Barra]  =  k_barra(iele,nodes,elements_Barra,E,A);              
    [ROW, COL]  =  get_map(row(:,:,iele),col(:,:,iele));
    Kbarra      =  fcn(Kbarra,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
end 

Knew = K + Kbarra;

stout = false(nel,1);
for iele = 1:nel
    i = nodes(elements(iele,:),1);
    for inod = 1:nnodel
        if i(inod) == 4
            stout(iele)=true;
        end
    end  
end
eleCargados = elements(stout,:);    


% % Ubicaciones puntos de Gauss
GPr   = 1/sqrt(3);

upgr1 = [ 1  -GPr
          1   GPr ];

npgr = size(upgr1,1);
wpgr = ones(npgr,1);

R = zeros(nNod,ndof);
Rr = reshape(R',[],1);
sig = 0;
tau = 100;
t=1;

for iele = 1:size(eleCargados,1)
    re = zeros(ndof*nnodel,1);         % 24 sería la cantidad de componentes en x y z que tendría el vector de cargas en un solo elemento H8
    nodesEle = nodes(eleCargados(iele,:),:);
    for ipg = 1:npgr
        % Punto de Gauss
        ksi = upgr1(ipg,1);
        eta = upgr1(ipg,2);  
        
        N  = shapefuns([ksi,eta],eleType);
        dN = shapefunsder([ksi,eta],eleType);
        jac = dN*nodesEle;                
        
        Ne = [N(1) 0  N(2) 0  N(3) 0  N(4) 0
              0  N(1) 0  N(2) 0  N(3) 0  N(4)];
      
        fi = [ tau*t*jac(2,1) + sig*t*jac(2,2)
               sig*t*jac(2,1) - tau*t*jac(2,2)];
           
        re = re + Ne'*fi*wpgr(ipg);
    end
    eleDofs = nodeDofs(eleCargados(iele,:),:);
    eleDofs = reshape(eleDofs',[],1);
    Rr(eleDofs,1) = Rr(eleDofs,1) + re;
end


bc = false(nNod,ndof);
bc(nodes(:,1)==0,1) = true;
bc(nodes(:,1)==0 & nodes(:,2)==0, 2) = true;

fixed  = reshape(bc',[],1);
free  = ~fixed;

% Solver
Dr = Knew(free,free)\Rr(free);

% Reconstruccion
D = zeros(ndof*nNod,1);
D(free) = D(free) + Dr;

D_1 = (reshape(D,ndof,[]))';
nodePosition = nodes + D_1;

meshplot(elements,nodePosition,'r')






            