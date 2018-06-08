clc
close all
clearvars

addpath('mallasvigaflexion')
    
malla = 'M4';
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
    case 'M5'
        nodesload = load('nodesM5.txt');
        nodes = nodesload(:,[2,3]);
        elementsload = load('elementsM5.txt');
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

%% Condiciones de borde
bc = false(nNod,ndof);
bc(nodes(:,1)==0,1) = true;
bc(nodes(:,1)==0 & nodes(:,2)==0, 2) = true;

fixed  = reshape(bc',[],1);
free  = ~fixed;

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

Coord_x = nodes(elements_Barra(:,2),2);

nelSpringFisura  = size(elements_Barra,1);

ndofel_b = 4;
E = 100;
A = 10;
Kbarra = zeros(ndoftot);%sparse(ndoftot,ndoftot);

% [row, col] = get_mapping_barra(nelSpringFisura,nodeDofs,elements_Barra,ndofel_b);
% for iele = 1:nelSpringFisura
%     [ke_Barra]  =  k_barra(iele,nodes,elements_Barra,E,A);              
%     [ROW, COL]  =  get_map(row(:,:,iele),col(:,:,iele));
%     Kbarra      =  fcn(Kbarra,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
% end 

stout1 = false(nel,1);
for iele = 1:nel
    i = nodes(elements(iele,:),1);
    for inod = 1:nnodel
        if i(inod) == 4
            stout1(iele)=true;
        end
    end  
end
eleCargados = elements(stout1,:);    

%% Vector de cargas
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



% Knew = K + Kbarra;

error = 1;
iteracionError=1;

E_B = 12e3;     %12e6;%


Knew = K;

Ediff_d1=0;
Ediff_d2=0;

desp_1 = 0.003; %   0.5; %   %% Definirlo según el módelo de resorte que se elija. Eso va a depender de la distancia al wellbore

despRot = 0.04;  %   0.6; %   %% Definirlo según el módelo de resorte que se elija. Eso va a depender de la distancia al wellbore


E_BB = zeros(nelSpringFisura,1);
E_variable = E_B;
gapViejo = zeros(nelSpringFisura,1);


A_Barra = A*ones(nelSpringFisura,1);
desp_1Variable=zeros(nelSpringFisura,1);

% E_variable = E*ones(nelSpringFisura,1);
k_barras = zeros(ndofel_b,ndofel_b,nelSpringFisura);
dof_barras = zeros(ndofel_b,nelSpringFisura);
count2 = zeros(nelSpringFisura,1);
nodePosition = zeros(nNod,ndof);

for iele = 1:nelSpringFisura
    E_variable(iele,1)=E_B;
    E_BB(iele,1)=E_B;
    gapViejo(iele,1) = 0;
    desp_1Variable(iele,1)=desp_1;
    count2(iele,1)=0;
end

D = zeros(ndof*nNod,1);
Time = 10;
Rtot = zeros(length(Rr),Time);
la = find(Rr);
for itime=1:Time
    
    Rtot(la,itime) = Rr(la) + itime*0.1;
    while error>5e-3
        Jacobo = sparse(ndoftot,ndoftot);
        Kbarra = sparse(ndoftot,ndoftot);
        [row, col] = get_mapping_barra(nelSpringFisura,nodeDofs,elements_Barra,ndofel_b);

        if iteracionError<2

            for iele = 1:nelSpringFisura
                [ke_Barra, kBarra_Mod]  =  k_barra(iele,nodes,elements_Barra,E_variable(iele),A_Barra(iele));
                k_barras(:,:,iele)      =  kBarra_Mod;                   
                [ROW, COL]              =  get_map(row(:,:,iele),col(:,:,iele));
                dof_barras(:,iele)      =  COL(:,1);
                Kbarra                  =  fcn(Kbarra,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
            end 
            Knew = K + Kbarra;
            % Solver
            Dr = Knew(free,free)\Rtot(free,itime);

            % Reconstruccion
    %         D = zeros(ndof*nNod,1);
            D(free) = D(free) + Dr;

            D_1 = (reshape(D,ndof,[]))';
%             nodePosition = nodes + D_1;
        end

        gap_fisu = zeros(nelSpringFisura,1);
        for ispring = 1:length(gap_fisu)
            gap_fisu(ispring) = norm(D_1(elements_Barra(ispring,1),1) - D_1(elements_Barra(ispring,2),1));
        end

        
        KBarraOld=Kbarra;% SOLO PARA DEBUGUEO!!!!
        Kbarra = sparse(ndoftot,ndoftot);

        for ispring = 1:length(gap_fisu)

            if gap_fisu(ispring)>=gapViejo(ispring,itime)
                count2(ispring)=0;
                E_BB(ispring,itime+1)=E_BB(ispring,itime);
                disp('hola')
            end

            if gap_fisu(ispring)<desp_1Variable(ispring) && gap_fisu(ispring)>=0
                E_variable(ispring) = E_BB(ispring,itime);
                disp('ZONA LINEAL')
            end

            if gap_fisu(ispring)>=desp_1Variable(ispring) && gap_fisu(ispring)>=gapViejo(ispring,itime)
                if gap_fisu(ispring)<=despRot
                    E_variable(ispring) = (((gap_fisu(ispring)-desp_1Variable(ispring))*(-desp_1Variable(ispring)*E_BB(ispring,itime)))/(despRot-desp_1Variable(ispring))+desp_1Variable(ispring)*E_BB(ispring,itime))/gap_fisu(ispring);
                    Ediff_d1 = (E_BB(ispring,itime)*desp_1Variable(ispring) - (E_BB(ispring,itime)*desp_1Variable(ispring)*(-gap_fisu(ispring) + desp_1Variable(ispring)))/(desp_1Variable(ispring) - despRot))/gap_fisu(ispring)^2 + (E_BB(ispring,itime)*desp_1Variable(ispring))/((-gap_fisu(ispring))*(desp_1Variable(ispring) - despRot));
                    Ediff_d2 = -(E_BB(ispring,itime)*desp_1Variable(ispring) - (E_BB(ispring,itime)*desp_1Variable(ispring)*(-gap_fisu(ispring) + desp_1Variable(ispring)))/(desp_1Variable(ispring) - despRot))/(-gap_fisu(ispring))^2 - (E_BB(ispring,itime)*desp_1Variable(ispring))/((-gap_fisu(ispring))*(desp_1Variable(ispring) - despRot));   
                    disp('ZONA COHESIVA')
                else
                    E_variable(ispring)=0;
                    E_BB(ispring,itime+1)=E_variable(ispring);
                    disp('ZONA DE ROTURA')
                end
            end

            if gapViejo(ispring,itime)>=0 && gap_fisu(ispring)<=gapViejo(ispring,itime)

                if count2(ispring)==0
                    E_BB(ispring,itime+1)=E_variable(ispring);
                    E_BB(ispring,itime)=E_variable(ispring);
                    if desp_1Variable(ispring)<gap_fisu(ispring);
                        desp_1Variable(ispring)=gap_fisu(ispring);
                    end
                    count2(ispring)=1;
                else
                    E_BB(ispring,itime+1)=E_BB(ispring,itime);
                end
                E_variable(ispring)=E_BB(ispring,itime);
            end

            if gap_fisu(ispring)<0
                E_variable(ispring) = E_B*10; 
                E_BB(ispring,itime+1)=E_BB(ispring,itime);
                disp('ZONA  COMPRESIVA')
            end

            if gap_fisu(ispring)>desp_1Variable(ispring) && gap_fisu(ispring)>=gapViejo(ispring,itime) && gap_fisu(ispring)<=despRot

                dir = nodes(elements_Barra(ispring,2),1:2) - nodes(elements_Barra(ispring,1),1:2);
                le = norm(dir);

                jac11 = (Ediff_d1*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,1),2) - (Ediff_d1*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,2),2) + E_variable(ispring)*A_Barra(ispring)/le;
                jac12 = (Ediff_d2*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,1),2) - ((Ediff_d2*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,2),2) + E_variable(ispring)*A_Barra(ispring)/le);
                jac21 = -((Ediff_d1*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,1),2) + E_variable(ispring)*A_Barra(ispring)/le) + (Ediff_d1*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,2),2);
                jac22 = -(Ediff_d2*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,1),2) + (Ediff_d2*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,2),2) + E_variable(ispring)*A_Barra(ispring)/le;

                jaca = [jac11 jac12
                        jac21 jac22];

                dir = dir / le;
%                 disp('hola')

                T = [ dir 0 0
                      0 0 dir ];

                jaca = T' * jaca * T; 

                [ROW, COL]     =  get_map(row(:,:,ispring),col(:,:,ispring));   
                Jacobo         =  fcn(Jacobo,sparse(ROW,COL,jaca,ndoftot,ndoftot));                  
            end   

             ke_Barra              =  k_barra(ispring,nodes,elements_Barra,E_variable(ispring),A_Barra(ispring));
             k_barras(:,:,ispring) =  ke_Barra;
             [ROW, COL]            =  get_map(row(:,:,ispring),col(:,:,ispring));
             dof_barras(:,ispring) =  COL(:,1);
             Kbarra                =  fcn(Kbarra,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
        end

        Jacobiano = Jacobo + K;
        Knew = K + Kbarra;
        % Solver

        Dr = D(free) - Jacobiano(free,free)\(Knew(free,free)*D(free) - Rtot(free,itime));

%             Dr_nuevo = Knew(free,free)\Rr(free);

        % Reconstruccion
        D = zeros(ndof*nNod,1);
        D(free) = D(free) + Dr;
%             D(free) = D(free) + Dr_nuevo;

        error=norm(Knew(free,free)*D(free) - Rtot(free,itime));


        D_1 = (reshape(D,ndof,[]))';
        nodePosition = nodes + D_1;
        iteracionError=iteracionError+1;

        for ispring = 1:length(gap_fisu)
            gap_fisu(ispring) = norm(D_1(elements_Barra(ispring,1),1) - D_1(elements_Barra(ispring,2),1));
        end

    %         meshplot(elements,nodePosition,'r')
    end
%         Kbarra-KBarraOld
    iteracionError=iteracionError-1;
    gapViejo(:,itime+1)=gap_fisu;
    error=1;
end

meshplot(elements,nodePosition,'r')




figure(2)
plot(Coord_x,gap_fisu,'r*')


% % Solver
% Dr = Knew(free,free)\Rr(free);
% 
% % Reconstruccion
% D = zeros(ndof*nNod,1);
% D(free) = D(free) + Dr;
% 
% D_1 = (reshape(D,ndof,[]))';
% nodePosition = nodes + D_1;
% 
% meshplot(elements,nodePosition,'r')








            