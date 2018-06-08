clc 
clearvars
tic
close all

cicloDeCarga='trac50%CompTrac110%CompTracRot';%'trac50%Relaj0.011Trac75%Relaj0.011TracRot';%'trac50%ComprTrac75%CompTracRot';%'trac50%Relaj0.004Trac75%Relaj0.004TracRot';%



switch cicloDeCarga
    case 'trac50%ComprTrac75%CompTracRot'
        rebote=-0.002;
        traccionUltima=0.75;
    case 'trac50%Relaj0.004Trac75%Relaj0.004TracRot'
        rebote=0.004;
        traccionUltima=0.75;
    case 'trac50%Relaj0.011Trac75%Relaj0.011TracRot'
        rebote=0.011;  
        traccionUltima=0.75;
    case 'trac50%CompTrac110%CompTracRot'
        rebote=-0.002;  
        traccionUltima=1.1;
end








nodes = [ 0 0
          1 0
          2 0
          3 0]*1000;
      
elements = [1 2
            2 3
            3 4];
%             2 3
%             2 3];
        
        
nNod = size(nodes,1);
nel = size(elements,1);
nDofNod = 1;
ndoftot=nNod*nDofNod;

A = 4000;  % Area de cada elemento 

qPaso = 100;
q= qPaso;
L = 1600;

bc = false(nNod,nDofNod);       % Matriz de condiciones de borde
bc(1,1) = true;
bc(end) = true;



% Propiedades del Material
E_00 = 210E3;

E_0=E_00;

E = E_00;
    
% Armado Matriz de Rigidez
K = zeros(nDofNod*nNod);

for iele = 1:nel;
    dir = nodes(elements(iele,2),:) - nodes(elements(iele,1),:);
    le = norm(dir);
    Ke =  A*E_00/le * [ 1 -1
                      -1  1 ];
    eleDofs = node2dof(elements(iele,:),nDofNod);     
    K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;
    
end
dir = nodes(elements(2,2),:) - nodes(elements(2,1),:);
le = norm(dir);
Ke =  A*E/le * [ 1 -1
                -1  1 ];
eleDofs = node2dof(elements(2,:),nDofNod);     
K(eleDofs,eleDofs) = K(eleDofs,eleDofs) - Ke;

% Reduccion Matriz
fixed = reshape(bc',[],1);
free = ~fixed;

desp1=0.008;

despRot=4*desp1;

rompedor=0;
iter=0;
E_Barra = [-1e15 3e7 -2e4 0];

caso = '1';
t = 1:1:20;

gapViejo=0;
direccion=1;
Ediff_d2 = 0;
Ediff_d3 = 0;
% for itime = 1:length(t)
Knew = K;%zeros(ndoftot);
count=0;
count2=0;

kele1 = K(1:2,1:2);
kele3 = K(3:4,3:4);


while rompedor < 1
    iter=iter+1;

    if count>0
        if gapViejo(iter)<rebote

            direccion= 1;

        end
    end
    if gapViejo(iter)>(despRot)*0.5
        if count==0
            direccion=-1;
            count=1;
        end
    end

    if gapViejo(iter)>(despRot)*traccionUltima
        if count==1
            direccion=-1;
            count=2;
        end
    end

    
    q = q+qPaso*direccion;
    error=1;
    iteracion=0;

    R = zeros(nNod,nDofNod);               % Vector de cargas                   
    R(2,1) = -q; 
    R(3,1) =  q;
    Rr = reshape(R',[],1);
    
    tstart = tic;

    while error>1e-5
%         Kprima = zeros(ndoftot);

        dir = nodes(elements(2,2),:) - nodes(elements(2,1),:);
        le = norm(dir);
        Ke =  A*E/le * [ 1 -1
                        -1  1 ];
        eleDofs = node2dof(elements(2,:),nDofNod);     
        Knew(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;

        iteracion=iteracion+1;


%         Rr = reshape(R',[],1);

        % Solver


        Dr = Knew(free,free)\Rr(free);
        % Reconstruccion
        D = zeros(nDofNod*nNod,1);
        D(free) = D(free) + Dr;

        gap = D(3)-D(2);
        
        Ke=Ke*0;
        
        if gap>=gapViejo(iter)
            count2=0;
            E_00(iter+1)=E_00(iter);
        end
        
        if gap<desp1 && gap>=0
            
            E=E_00(iter);
            
            Ke =  A*E/le * [ 1 -1
                            -1  1 ];
            eleDofs = node2dof(elements(2,:),nDofNod);
            Knew(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;
            
        end
        

        if gap>=desp1 && gap>=gapViejo(iter)

            if gap<=despRot
                E = ((((D(3)-D(2))-desp1)*(-desp1*E_00(iter)))/(despRot-desp1)+desp1*E_00(iter))/(D(3)-D(2));
                Ediff_d2 = (E_00(iter)*desp1 - (E_00(iter)*desp1*(D(2) - D(3) + desp1))/(desp1 - despRot))/(D(2) - D(3))^2 + (E_00(iter)*desp1)/((D(2) - D(3))*(desp1 - despRot));
                Ediff_d3 = -(E_00(iter)*desp1 - (E_00(iter)*desp1*(D(2) - D(3) + desp1))/(desp1 - despRot))/(D(2) - D(3))^2 - (E_00(iter)*desp1)/((D(2) - D(3))*(desp1 - despRot));               
            else
                E = 0;
                E_00(iter+1)=E;
            end

            Ke =  A*E/le * [ 1 -1
                            -1  1 ];
            eleDofs = node2dof(elements(2,:),nDofNod);     
            Knew(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;
            
        end
        
        if gap >=0 && gap<=gapViejo(iter)
            if count2==0
                E_00(iter+1)=E;
                E_00(iter)=E;
                desp1=gap;
                count2=1
            else
                E_00(iter+1)=E_00(iter);
            end
            
            E=E_00(iter);
            
            Ke =  A*E/le * [ 1 -1
                -1  1 ];
            eleDofs = node2dof(elements(2,:),nDofNod);
            Knew(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;
            
        end

        if gap<0     

%             dir = nodes(elements(2,2),:) - nodes(elements(2,1),:);
%             le = norm(dir);
%             Ke =  A*E/le * [ 1 -1
%                             -1  1 ];
%             eleDofs = node2dof(elements(2,:),nDofNod);     
%             K(eleDofs,eleDofs) = K(eleDofs,eleDofs) - Ke;

            E = E_0*10;
            
            E_00(iter+1)=E_00(iter);

            Ke =  A*E/le * [ 1 -1
                            -1  1 ];
            eleDofs = node2dof(elements(2,:),nDofNod);     
            Knew(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;

        end
        
%         if gap>desp1 && gap>=gapViejo && gap<=despRot
%             Jacobo= zeros(ndoftot);
            
            Jacobo = K;
            Jac = zeros(2,2);
%             D(2)=0;
%             D(3)=0;
            Jac(1,1) = (Ediff_d2*A/le)*D(2) - (Ediff_d2*A/le)*D(3) + E*A/le;
            Jac(1,2) = (Ediff_d3*A/le)*D(2) - ((Ediff_d3*A/le)*D(3) + E*A/le);
            Jac(2,1) = -((Ediff_d2*A/le)*D(2) + E*A/le) + (Ediff_d2*A/le)*D(3);
            Jac(2,2) = -(Ediff_d3*A/le)*D(2) + (Ediff_d3*A/le)*D(3) + E*A/le;
            
            
%             Jacobo(1:2,1:2) = Jacobo(1:2,1:2)+kele1;
            Jacobo(2:3,2:3) = Jacobo(2:3,2:3)+ Jac;
%             Jacobo(3:4,3:4) = Jacobo(3:4,3:4) + kele3;
            
            Dnew = D(2:3,1) - Jacobo(free,free)\(Knew(free,free)*D(free) - R(free));

            Dnuevo = zeros(4,1);
            Dnuevo(2) = Dnew(1);
            Dnuevo(3) = Dnew(2);
            
            error=norm(Knew(free,free)*Dnuevo(free) - Rr(free));
            D = Dnuevo;
            gap = D(3) - D(2);
            Tension = Ke*[0 gap]';
            
%         else
%             Tension = Ke*[0 gap]';
%             error=norm(Knew(free,free)*Dr-Rr(free));
%             
%         end
        
        if iteracion>10000
            disp('warning: se fue a la mierda...')
            errorPosta=error;
            error=0;
        end
        
    end
    
    gapViejo(iter+1)=gap;
%     disp(iteracion)
    telapsed = toc(tstart);


    figure(1)
    subplot(2,1,1)
    plot(gap,q,'r+')
    hold on
    plot(gap,Tension(2),'b+')
    
    subplot(2,1,2)
    plot(gap,E,'k.')
    hold on
    figure(2)
    subplot(2,1,1)
    plot(gap,iteracion,'k.')
    hold on
    subplot(2,1,2)
    plot(gap,telapsed,'k.')
    hold on
%     figure(3)
%     plot(iter,E_00(iter),'k.')
%     hold on
    drawnow
    if abs(gap)>0.04
        break
    elseif gap<-0.5*desp1
        break
    end

%         iter=iter+1;
end
toc 
figure(1)

subplot(2,1,1)
title('Fuerza/Gap')
xlabel('Gap')
ylabel('Fuerza')

subplot(2,1,2)
title('Modulo Young/Gap')
xlabel('Gap')
ylabel('E')

figure(2)

subplot(2,1,1)
title('Iteraciones/Gap')
xlabel('Gap')
ylabel('Iteraciones')

subplot(2,1,2)
title('TiempoCorrida/Gap')
xlabel('Gap')
ylabel('Segundos')

% end