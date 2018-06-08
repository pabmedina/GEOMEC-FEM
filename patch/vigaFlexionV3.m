clc
close all
clearvars

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                          %
% NOTA: Version cargada en la entalla (donde esta la fisu) %
%                                                          % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



addpath('mallasvigaflexion')
    
malla = 'M5';
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
    case 'M6'
        nodesload = load('nodesM6.txt');
        nodes = nodesload(:,[2,3]);
        elementsload = load('elementsM6.txt');
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
bc(nodes(:,1)==4,1) = true;
bc(nodes(:,1)==4 & nodes(:,2)==0, 2) = true;

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



stout1 = false(nel,1);
for iele = 1:nel
    i = nodes(elements(iele,:),1);
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if i(inod) < 2 && i(inod) > 1.8 && j(inod)==1 % acá tendría que agregar una j inferior. e.g. j(inod)>=nodes(elements_Barra(:,2),k)  %% ACLARACIÓN!! el elements_Barra tiene que estar flipeado
            stout1(iele)=true;
        end
    end  
end
eleCargados1 = elements(stout1,:);    

stout2 = false(nel,1);
for iele = 1:nel
    i = nodes(elements(iele,:),1);
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if i(inod) > 2 && i(inod) < 2.2 && j(inod)==1
            stout2(iele)=true;
        end
    end  
end
eleCargados2 = elements(stout2,:); 

% Knew = K + Kbarra;

error = 1;
iteracionError=1;

E_B = 12e4;     %12e6;%


Knew = K;

Ediff_d1=0;
Ediff_d2=0;

desp_1 = 0.000003; %   0.5; %   %% Definirlo según el módelo de resorte que se elija. Eso va a depender de la distancia al wellbore

despRot = 0.4;  %   0.6; %   %% Definirlo según el módelo de resorte que se elija. Eso va a depender de la distancia al wellbore


E_BB = zeros(nelSpringFisura,1);
E_variable = E_B;
gapViejo = zeros(nelSpringFisura,1);


A_Barra = A*ones(nelSpringFisura,1);
desp_1Variable=zeros(nelSpringFisura,1);

% E_variable = E*ones(nelSpringFisura,1);
k_barras = zeros(ndofel_b,ndofel_b,nelSpringFisura);
k_prima = zeros(ndofel_b,ndofel_b,nelSpringFisura);
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
Time = 20;
Rtot = zeros(ndoftot,Time);
energia = 0;
desp1 = [desp_1/2;0;-desp_1/2;0];
despRotura = [despRot/2;0;-despRot/2;0];

[row, col] = get_mapping_barra(nelSpringFisura,nodeDofs,elements_Barra,ndofel_b);
% Largo_Ele = zeros(nelSpringFisura,1);
% 
% for iele = 1:nelSpringFisura
%     
%     dir = nodes(elements_Barra(iele,2),1:2) - nodes(elements_Barra(iele,1),1:2);
%     Largo_Ele(iele,1) = norm(dir);
%     
% end 
%  
gapNuevo = zeros(nelSpringFisura,Time);
% 
% G = 40;
% Length = sum(Largo_Ele)/nelSpringFisura;    % es un largo promedio de los elementos Barra que forman la parte cohesiva de la fisura

Gtasa = 12; 
Gtasa0 = 12;
Length = (2.01-1.99)/2;
Desp1nuevo = zeros(4,nelSpringFisura,Time);

% Rr = zeros(nNod,ndof);
% Rr(nodes(:,1)==1.99,1) = -2000;
% Rr(nodes(:,1)==2.01, 1) = 2000;
% Rr = reshape(Rr',[],1);

for itime=1:Time
 
    disp(['Time: ' num2str(itime)])
%     Rr = Rr + Rr*itime*0.01;
    sig=125000*(itime*0.1);
    Rr = vectorCargas(nodes,eleCargados1,eleCargados2,nnodel,ndof,nodeDofs,nNod,eleType,sig);
    

    iteracionError=1;
    iter = 0;
    Rtot(:,itime) = Rr;
    while error>1e-5
        % E_variable
        iter=iter+1;
        Jacobo = sparse(ndoftot,ndoftot);
        Kbarra = sparse(ndoftot,ndoftot);
        [row, col] = get_mapping_barra(nelSpringFisura,nodeDofs,elements_Barra,ndofel_b);
        if iteracionError<2
            for iele = 1:nelSpringFisura
                [ke_Barra, kBarra_Mod, kprima]  =  k_barra(iele,nodes,elements_Barra,E_variable(iele),A_Barra(iele),E_B,Length,nelSpringFisura);
                k_prima(:,:,iele)               =  kprima;
                k_barras(:,:,iele)              =  kBarra_Mod;                   
                [ROW, COL]                      =  get_map(row(:,:,iele),col(:,:,iele));
                dof_barras(:,iele)              =  COL(:,1);
                Kbarra                          =  fcn(Kbarra,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
            end 
            
            energia_total = zeros(1,nelSpringFisura);
            for i = 1:nelSpringFisura
                energia_total(1,i) = 0.5*desp1'*k_prima(:,:,i)*despRotura;
            end
                        
            Knew = K + Kbarra;
            D = zeros(ndof*nNod,1);
            Dr = Knew(free,free)\Rtot(free,itime);
            D(free) = D(free) + Dr;

            D_1 = (reshape(D,ndof,[]))';

        end
%         energia_total
        % Solver
        
        % Reconstruccion

%             nodePosition = nodes + D_1;
%         end
%         D
        gap_fisu = zeros(nelSpringFisura,1);
%         gap_test = zeros(nelSpringFisura,1);
        for ispring = 1:length(gap_fisu)
            gap_fisu(ispring) = norm(D_1(elements_Barra(ispring,1),1) - D_1(elements_Barra(ispring,2),1));
        end
%         gap_fisu
        
       
        
        KBarraOld=Kbarra;% SOLO PARA DEBUGUEO!!!!
        Kbarra = sparse(ndoftot,ndoftot);

        for ispring = 1:length(gap_fisu)

            if gap_fisu(ispring)>=gapViejo(ispring,itime)
                count2(ispring)=0;
                E_BB(ispring,itime+1)=E_BB(ispring,itime);
%                 disp('HOLA')
            end

            if gap_fisu(ispring)<desp_1Variable(ispring) && gap_fisu(ispring)>=0
                E_variable(ispring) = E_BB(ispring,itime);
%                 disp('ZONA LINEAL')
            end

            if gap_fisu(ispring)>=desp_1Variable(ispring) && gap_fisu(ispring)>=gapViejo(ispring,itime)
                if gap_fisu(ispring)<=despRot
                    E_variable(ispring) = (((gap_fisu(ispring)-desp_1Variable(ispring))*(-desp_1Variable(ispring)*E_BB(ispring,itime)))/(despRot-desp_1Variable(ispring))+desp_1Variable(ispring)*E_BB(ispring,itime))/gap_fisu(ispring);
                    Ediff_d1 = (E_BB(ispring,itime)*desp_1Variable(ispring) - (E_BB(ispring,itime)*desp_1Variable(ispring)*(-gap_fisu(ispring) + desp_1Variable(ispring)))/(desp_1Variable(ispring) - despRot))/gap_fisu(ispring)^2 + (E_BB(ispring,itime)*desp_1Variable(ispring))/((-gap_fisu(ispring))*(desp_1Variable(ispring) - despRot));
                    Ediff_d2 = -(E_BB(ispring,itime)*desp_1Variable(ispring) - (E_BB(ispring,itime)*desp_1Variable(ispring)*(-gap_fisu(ispring) + desp_1Variable(ispring)))/(desp_1Variable(ispring) - despRot))/(-gap_fisu(ispring))^2 - (E_BB(ispring,itime)*desp_1Variable(ispring))/((-gap_fisu(ispring))*(desp_1Variable(ispring) - despRot));   
%                     disp('ZONA COHESIVA')
                else
                    E_variable(ispring)=0;
                    E_BB(ispring,itime+1)=E_variable(ispring);
%                     disp('ZONA DE ROTURA')
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
%                 disp('ZONA  COMPRESIVA')
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

             ke_Barra              =  k_barra(ispring,nodes,elements_Barra,E_variable(ispring),A_Barra(ispring),E_B,Length,nelSpringFisura);
             k_barras(:,:,ispring) =  ke_Barra;
             [ROW, COL]            =  get_map(row(:,:,ispring),col(:,:,ispring));
             dof_barras(:,ispring) =  COL(:,1);
             Kbarra                =  fcn(Kbarra,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
        end
%         k_barras

        Jacobiano = Jacobo + K;
        Knew2 = K + Kbarra;
        % Solver
        % Reconstruccion
%         Dr_nuevo = D(free) - Jacobiano(free,free)\(Knew(free,free)*D(free) - Rtot(free,itime));
%         Dn = zeros(ndof*nNod,1);
%         Dn(free) = D(free) + Dr_nuevo;
%         error=norm(Knew(free,free)*Dn(free) - Rtot(free,itime))

        Dr_nuevo = Knew2(free,free)\Rtot(free,itime);
        Dn = zeros(ndof*nNod,1);
        Dn(free) = Dn(free) + Dr_nuevo;
%         Dn
        error = norm(D-Dn);
        D=Dn;
        Knew=Knew2;

        D_1 = (reshape(D,ndof,[]))';
        nodePosition = nodes + D_1;
        iteracionError=iteracionError+1;

%         for ispring = 1:length(gap_fisu)
%             gap_fisu(ispring) = norm(D_1(elements_Barra(ispring,1),1) - D_1(elements_Barra(ispring,2),1));
%         end
%         gap_fisu

    %         meshplot(elements,nodePosition,'r')
    end

%     gap_fisu
    

    for ispring = 1:nelSpringFisura
        gapNuevo(ispring,itime) = norm(D_1(elements_Barra(ispring,1),1) - D_1(elements_Barra(ispring,2),1));
        Desp1nuevo(:,ispring,itime) = [gapNuevo(ispring,itime)/2, 0, -gapNuevo(ispring,itime)/2,0 ];
        
    end

    energia_remanente = zeros(1,nelSpringFisura);
    for ispring = 1:nelSpringFisura
        energia_remanente(1,ispring) = 0.5*Desp1nuevo(:,ispring,itime)'*k_barras(:,:,ispring)*despRotura;
    end
%     energia_remanente
    energia_remanente = flip(energia_remanente);
%     energia_remanente 
    damage = energia_total - energia_remanente;
    gap_test = flip(gap_fisu);
    
    logical_energy = false(nelSpringFisura,1);
    for ispring = 1:nelSpringFisura
        if damage(ispring)==max(energia_total)
            logical_energy(ispring)=true;
        end
    end
    
    testing = '2';
    switch testing
        case '1'
            for ispring = 1:nelSpringFisura
                if gap_test(ispring)>=despRot
                    eps_tot = damage(1);
                    k=1;
                    while eps_tot<Gtasa
                        k = k+1;
                        eps_tot = eps_tot + damage(1,k);
                        if eps_tot>=Gtasa
                            disp(['Rompe en el resorte n°:' num2str(k)])
                        end

                        if k>=nelSpringFisura
                            disp('El G es mucho mayor a la energia gastada. Aumentar la carga')
                            break
                        end 
                    end 
                    Gtasa = Gtasa + sum(damage(1:k-1));
        %         else
        %             disp('El G es mucho mayor a la energia gastada. Aumentar la carga')
                end
            end
        case '2'
       
            eps_tot = sum(damage(logical_energy))

            if eps_tot<Gtasa
                disp('Aumentar carga')
            end
            if eps_tot>=Gtasa
                k = sum(logical_energy);
                disp(['Rompe en el resorte n°:' num2str(k)])
                
                k
                
                stout1 = false(nel,1);
                
                
                if k<nelSpringFisura
                    clear eleCargados1 eleCargados2
                for iele = 1:nel
                    i = nodes(elements(iele,:),1);
                    j = nodes(elements(iele,:),2);
                    for inod = 1:nnodel
                        if i(inod) < 2 && i(inod) > 1.8 && j(inod)<=1 && j(inod)>=nodes(elements_Barra((end-k),1),2) 
                            stout1(iele)=true;
                        end
                    end  
                end
                eleCargados1 = elements(stout1,:);    

                stout2 = false(nel,1);
                for iele = 1:nel
                    i = nodes(elements(iele,:),1);
                    j = nodes(elements(iele,:),2);
                    for inod = 1:nnodel
                        if i(inod) > 2 && i(inod) < 2.2 && j(inod)<=1 && j(inod)>=nodes(elements_Barra((end-k),1),2)
                            stout2(iele)=true;
                        end
                    end  
                end
                eleCargados2 = elements(stout2,:); 
                end

                if k>=nelSpringFisura
                    disp('El G es mucho mayor a la energia gastada. Aumentar la carga')
%                     break
                end 
%                 Gtasa = Gtasa + eps_tot
                Gtasa = Gtasa0 + eps_tot;
            end 
    end
    gap_fisu
%     disp(Gtasa)
%     gap_fisu
%         Kbarra-KBarraOld
    iteracionError=iteracionError-1;
    gapViejo(:,itime+1)=gap_fisu;
    error=1;

end

meshplot(elements,nodePosition,'r')



% 
% figure(2)
% plot(Coord_x,gap_fisu,'r*')


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








            