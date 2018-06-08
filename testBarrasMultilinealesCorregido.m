clc 
clearvars
tic
% close all

cicloDeCarga='trac50%ComprTrac75%CompTracRot';%'trac50%Relaj0.004Trac75%Relaj0.004TracRot';%'trac50%Relaj0.011Trac75%Relaj0.011TracRot';%



switch cicloDeCarga
    case 'trac50%ComprTrac75%CompTracRot'
        rebote=-0.002;
        
    case 'trac50%Relaj0.004Trac75%Relaj0.004TracRot'
        rebote=0.004;
        
    case 'trac50%Relaj0.011Trac75%Relaj0.011TracRot'
        rebote=0.011;  
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

qPaso = 50;
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

desp1=0.008;

despRot=4*desp1;%3.1*desp1;%

rompedor=0;
iter=0;
E_Barra = [-1e15 3e7 -2e4 0];

caso = '1';
t = 1:1:20;

gapViejo=0;
direccion=1;

% for itime = 1:length(t)
tic

count=0;
count2=0;
    while rompedor < 1
        if count>0
            if gapViejo<rebote
                direccion= 1;
                
            end
        end
        if gapViejo>(0.008+despRot)*0.5 
            if count==0
                direccion=-1;
                count=1;
            end
        end
        
        if gapViejo>(0.008+despRot)*0.7
            if count==1
                direccion=-1;
                count=2;
            end
        end
        
        
        
        q = q+qPaso*direccion;
        error=1;
        iteracion=0;
        
        tstart = tic;
        
        while error>1e-5
            iteracion=iteracion+1;

            R = zeros(nNod,nDofNod);               % Vector de cargas                   
            R(2,1) = -q; 
            R(3,1) = q;

            % Reduccion Matriz
            fixed = reshape(bc',[],1);
            free = ~fixed;

            Rr = reshape(R',[],1);

            % Solver
            Dr = K(free,free)\Rr(free);
            % Reconstruccion
            D = zeros(nDofNod*nNod,1);
            D(free) = D(free) + Dr;

            gap = D(3)-D(2);
            
            if gap>=gapViejo
                count2=0;
            end
            
            if gap<desp1 && gap>=0
                dir = nodes(elements(2,2),:) - nodes(elements(2,1),:);
                le = norm(dir);
                Ke =  A*E/le * [ 1 -1
                                -1  1 ];
                eleDofs = node2dof(elements(2,:),nDofNod);     
                K(eleDofs,eleDofs) = K(eleDofs,eleDofs) - Ke;
                
                E=E_00;
                
                Ke =  A*E/le * [ 1 -1
                                -1  1 ];
                eleDofs = node2dof(elements(2,:),nDofNod);     
                K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;
            end

        
        
            if gap>desp1 && gap>=gapViejo

                dir = nodes(elements(2,2),:) - nodes(elements(2,1),:);
                le = norm(dir);
                Ke =  A*E/le * [ 1 -1
                                -1  1 ];
                eleDofs = node2dof(elements(2,:),nDofNod);     
                K(eleDofs,eleDofs) = K(eleDofs,eleDofs) - Ke;


                if gap<=despRot
                    E = (((gap-desp1)*(-desp1*E_00))/(despRot-desp1)+desp1*E_00)/gap;

                else
                    E = 0;
                end


                Ke =  A*E/le * [ 1 -1
                                -1  1 ];
                eleDofs = node2dof(elements(2,:),nDofNod);     
                K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;

            end
            
            if gap>0 && gap<=gapViejo && count2==0
                E_00=E;
                desp1=gap;
                count2=1;
            end

            if gap<0

                dir = nodes(elements(2,2),:) - nodes(elements(2,1),:);
                le = norm(dir);
                Ke =  A*E/le * [ 1 -1
                                -1  1 ];
                eleDofs = node2dof(elements(2,:),nDofNod);     
                K(eleDofs,eleDofs) = K(eleDofs,eleDofs) - Ke;


                E = E_0*10;


                Ke =  A*E/le * [ 1 -1
                                -1  1 ];
                eleDofs = node2dof(elements(2,:),nDofNod);     
                K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;

            end
            Tension = Ke*[0 gap]';
                    
            error=norm(K(free,free)*Dr-Rr(free));

            if iteracion>10000
                disp('warning')
                errorPosta=error;
                error=0;
            end
        end
        gapViejo=gap;
%         disp(iteracion)
        telapsed = toc(tstart);
     
        figure(1)
        subplot(2,1,1)
        plot(gap,q,'b.')
        hold on
        
        plot(gap,Tension(2),'y.')
        subplot(2,1,2)
        plot(gap,E,'b.')
        hold on
        xlabel('Gap')
        ylabel('E')
        figure(2)
        subplot(2,1,1)
        plot(gap,iteracion,'b.')
        hold on
        subplot(2,1,2)
        plot(gap,telapsed,'b.')
        hold on
%         drawnow
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