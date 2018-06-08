clc 
clearvars
tic
% close all

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

desp1=0.008;

despRot=4*desp1;

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
    while rompedor < 1

        if gapViejo>(desp1+despRot)*0.5 & count==0
            direccion=-1;
        end
        
        if direccion==-1 & gapViejo<desp1+(despRot-desp1)*0.1
            direccion= 1;
            count=1;
        end
        
        q = q+qPaso*direccion;
        error=1;
        iteracion=0;
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

        
        
            if gap>desp1 && gap>=gapViejo

                dir = nodes(elements(2,2),:) - nodes(elements(2,1),:);
                le = norm(dir);
                Ke =  A*E/le * [ 1 -1
                                -1  1 ];
                eleDofs = node2dof(elements(2,:),nDofNod);     
                K(eleDofs,eleDofs) = K(eleDofs,eleDofs) - Ke;


                if gap<=despRot
                    E = (((gap-desp1)*(-desp1*E_0))/(despRot-desp1)+desp1*E_0)/gap;

                else
                    E = 0;
                end


                Ke =  A*E/le * [ 1 -1
                                -1  1 ];
                eleDofs = node2dof(elements(2,:),nDofNod);     
                K(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;

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
        disp(iteracion)
     
        figure(1)
        plot(gap,q,'r.')
        hold on
        plot(gap,Tension(2),'b.')
        figure(2)
        plot(gap,E,'b.')
        hold on
        figure(3)
        plot(gap,iteracion,'b.')
        hold on
        if abs(gap)>3*despRot
            break
        elseif gap<-0.5*desp1
            break
        end
        
%         iter=iter+1;
    end
    
    
toc
% end