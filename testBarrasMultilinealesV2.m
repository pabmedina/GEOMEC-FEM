clc 
clearvars
tic
close all

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

kele1 = K(1:2,1:2);
kele3 = K(3:4,3:4);


while rompedor < 1

    if gapViejo>(desp1+despRot)*0.5 && count==0
        direccion=-1;
    end
%     if direccion==-1 & gapViejo<desp1+(despRot-desp1)*0.1
%         direccion= 1;
%         count=1;
%     end
    
    
    q = q+qPaso*direccion;
    error=1;
    iteracion=0;

    R = zeros(nNod,nDofNod);               % Vector de cargas                   
    R(2,1) = -q; 
    R(3,1) =  q;
    Rr = reshape(R',[],1);

    while error>1e-5
%         Kprima = zeros(ndoftot);

        dir = nodes(elements(2,2),:) - nodes(elements(2,1),:);
        le = norm(dir);
        Ke =  A*E/le * [ 1 -1
                        -1  1 ];
        eleDofs = node2dof(elements(2,:),nDofNod);     
        Knew(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;

        iteracion=iteracion+1;

        % Solver

        Dr = Knew(free,free)\Rr(free);
        % Reconstruccion
        D = zeros(nDofNod*nNod,1);
        D(free) = D(free) + Dr;

        gap = D(3)-D(2);

        if gap>desp1 && gap>=gapViejo

            if gap<=despRot
                E = ((((D(3)-D(2))-desp1)*(-desp1*E_0))/(despRot-desp1)+desp1*E_0)/(D(3)-D(2));
                Ediff_d2 = (E_0*desp1 - (E_0*desp1*(D(2) - D(3) + desp1))/(desp1 - despRot))/(D(2) - D(3))^2 + (E_0*desp1)/((D(2) - D(3))*(desp1 - despRot));
                Ediff_d3 = -(E_0*desp1 - (E_0*desp1*(D(2) - D(3) + desp1))/(desp1 - despRot))/(D(2) - D(3))^2 - (E_0*desp1)/((D(2) - D(3))*(desp1 - despRot));               
            else
                E = 0;
            end

            Ke =  A*E/le * [ 1 -1
                            -1  1 ];
            eleDofs = node2dof(elements(2,:),nDofNod);     
            Knew(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;
            
        end

        if gap<0
            
            E = E_0*10;
            Ke =  A*E/le * [ 1 -1
                            -1  1 ];
            eleDofs = node2dof(elements(2,:),nDofNod);     
            Knew(eleDofs,eleDofs) = K(eleDofs,eleDofs) + Ke;

        end
        
        if gap>desp1 && gap>=gapViejo && gap<=despRot
%             Jacobo= zeros(ndoftot);
            
            Jacobo = K;
            Jac = zeros(2,2);
%             D(2)=0;
%             D(3)=0;
            Jac(1,1) = (Ediff_d2*A/le)*D(2) - (Ediff_d2*A/le)*D(3) + E*A/le;
            Jac(1,2) = (Ediff_d3*A/le)*D(2) - ((Ediff_d3*A/le)*D(3) + E*A/le);
            Jac(2,1) = -((Ediff_d2*A/le)*D(2) + E*A/le) + (Ediff_d2*A/le)*D(3);
            Jac(2,2) = -(Ediff_d3*A/le)*D(2) + (Ediff_d3*A/le)*D(3) + E*A/le;
            
            Jacobo(2:3,2:3) = Jacobo(2:3,2:3)+ Jac;
            
            Dnew = D(2:3,1) - Jacobo(free,free)\(Knew(free,free)*D(free) - R(free));

            Dnuevo = zeros(4,1);
            Dnuevo(2) = Dnew(1);
            Dnuevo(3) = Dnew(2);
            
            error=norm(Knew(free,free)*Dnuevo(free) - Rr(free));
            D = Dnuevo;
            gap = D(3) - D(2);
            Tension = Ke*[0 gap]';
            
        else
            Tension = Ke*[0 gap]';
            error=norm(Knew(free,free)*Dr-Rr(free));
            
        end
        
        if iteracion>10000
            disp('warning: se fue a la mierda...')
            errorPosta=error;
            error=0;
        end
        
    end
    
    gapViejo=gap;
%     disp(iteracion)

    figure(1)
    plot(gap,q,'b+')
    hold on
    plot(gap,Tension(2),'r+')
    figure(2)
    plot(gap,E,'k.')
    hold on
    figure(3)
    plot(gap,iteracion,'k.')
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