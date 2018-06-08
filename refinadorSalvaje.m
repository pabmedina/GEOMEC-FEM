function [ elements, nodes] = refinadorSalvaje( elements, nodes,tipo )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


alturaMaxima=inf;
alturaMinima=-inf;

alturaMaximaCoser=70;
alturaMinimaCoser=23;

nod3=nodes;

elem3D=elements;

%% Refinamiento

elemARefinar=find(tipo==1);

numNod=length(nod3);

nodTipo=zeros(numNod,1);

for i=1:length(elemARefinar)
    numNod=length(nod3);
    
    [nod3, elem3DSalida]=Refinamiento3DeUnPaso(nod3,elem3D,elemARefinar(i));
    
    numNodNew=length(nod3);
    
    nodTipo(numNod+1:numNodNew)=1;
    
    elem3D=[elem3D
            elem3DSalida];
        numElem=length(elem3D);
        tipo(numElem-3:numElem)=3;
end

elemARefinar=find(tipo==2);

for i=1:length(elemARefinar)
    
    numNod=length(nod3);
    
    elem3D(elemARefinar(i),:)=[elem3D(elemARefinar(i),3) elem3D(elemARefinar(i),4) elem3D(elemARefinar(i),1) elem3D(elemARefinar(i),2) elem3D(elemARefinar(i),7) elem3D(elemARefinar(i),8) elem3D(elemARefinar(i),5) elem3D(elemARefinar(i),6)];
    
    [nod3, elem3DSalida]=Refinamiento3DeUnPaso(nod3,elem3D,elemARefinar(i));
    
    elem3D=[elem3D
            elem3DSalida];
    
	numNodNew=length(nod3);
         
    nodTipo(numNod+1:numNodNew)=2;
        
        numElem=length(elem3D);
        tipo(numElem-3:numElem)=4;
end

elem3D([find(tipo==1)' find(tipo==2)'],:)=[];

tipo([find(tipo==1)' find(tipo==2)'])=[];

nod3=round(nod3,5);

checkNodes=find(nodTipo);

Reemplazar=[];

for i=1:length(checkNodes)
    porNodoAct=checkNodes(i);
    reemplazar=find(nod3(:,1)==nod3(checkNodes(i),1) & ...
         nod3(:,2)==nod3(checkNodes(i),2) & ...
         nod3(:,3)==nod3(checkNodes(i),3) & ...
         nodTipo(:)==nodTipo(checkNodes(i)));
	reemplazar(reemplazar==porNodoAct)=[];
    
    if reemplazar>porNodoAct & isempty(reemplazar)==0
        
        Reemplazar=[Reemplazar
                    reemplazar porNodoAct];
                
    end
    
    
    
    
    
end


%% Elementos

for i=1:length(Reemplazar(:,1))
    
    aux=find(elem3D(:,1)==Reemplazar(i,1) | ...
             elem3D(:,2)==Reemplazar(i,1) | ...
             elem3D(:,3)==Reemplazar(i,1) | ...
             elem3D(:,4)==Reemplazar(i,1) | ...
             elem3D(:,5)==Reemplazar(i,1) | ...
             elem3D(:,6)==Reemplazar(i,1) | ...
             elem3D(:,7)==Reemplazar(i,1) | ...
             elem3D(:,8)==Reemplazar(i,1));
         
    for j=1:length(aux)
        
        elem3D(aux(j),elem3D(aux(j),:)==Reemplazar(i,1))=Reemplazar(i,2);
        
    end
    
end



%% Eliminar nodos de mas

Eliminar= sort(Reemplazar(:,1),'descend');

for i=1:length(Eliminar)
    
    for j=1:8
        
        elem3D(elem3D(:,j)>Eliminar(i),j)=elem3D(elem3D(:,j)>Eliminar(i),j)-1;
        
    end
    
end

nod3(Reemplazar(:,1),:)=[];

nodTipo(Reemplazar(:,1))=[];



%% Coser

% alturaMaximaCoser
% alturaMinimaCoser

checkNodes=find(nodTipo);

Reemplazar=[];

elementsBarra=[];

coser=[];

for i=1:length(nod3(:,1))
    porNodoAct=i;
            
    reemplazar=find(nod3(:,1)==nod3(i,1) & ...
                    nod3(:,2)==nod3(i,2) & ...
                    nod3(:,3)==nod3(i,3));
     
    
    
	reemplazar(reemplazar==porNodoAct)=[]
    
    if reemplazar>porNodoAct & nod3(porNodoAct,3)>alturaMaximaCoser
             
        
            Reemplazar=[Reemplazar
                        reemplazar porNodoAct];
            coser=[coser
                   porNodoAct];
                
    elseif reemplazar>porNodoAct & nod3(porNodoAct,3)<alturaMinimaCoser
        
            Reemplazar=[Reemplazar
                        reemplazar porNodoAct];
            coser=[coser
                   porNodoAct];
    elseif reemplazar>porNodoAct & nod3(porNodoAct,3)>alturaMinimaCoser & nod3(porNodoAct,3)<alturaMaximaCoser
        
        elementsBarra=[elementsBarra
                        reemplazar porNodoAct];
                
    end
    
    
end
figure(40)
hold on
plot3(nod3(coser,1),nod3(coser,2),nod3(coser,3),'b*')

figure(50)
hold on
plot3(nod3(coser,1),nod3(coser,2),nod3(coser,3),'b*')

%% Elementos
if isempty(Reemplazar)==0
for i=1:length(Reemplazar(:,1))
    
    aux=find(elem3D(:,1)==Reemplazar(i,1) | ...
             elem3D(:,2)==Reemplazar(i,1) | ...
             elem3D(:,3)==Reemplazar(i,1) | ...
             elem3D(:,4)==Reemplazar(i,1) | ...
             elem3D(:,5)==Reemplazar(i,1) | ...
             elem3D(:,6)==Reemplazar(i,1) | ...
             elem3D(:,7)==Reemplazar(i,1) | ...
             elem3D(:,8)==Reemplazar(i,1));
         
    for j=1:length(aux)
        
        elem3D(aux(j),elem3D(aux(j),:)==Reemplazar(i,1))=Reemplazar(i,2);
        
    end
    
end



%% Eliminar nodos de mas

Eliminar= sort(Reemplazar(:,1),'descend');

for i=1:length(Eliminar)
    
    for j=1:8
        
        elem3D(elem3D(:,j)>Eliminar(i),j)=elem3D(elem3D(:,j)>Eliminar(i),j)-1;
        
    end
    
    for j=1:2
        
        elementsBarra(elementsBarra(:,j)>Eliminar(i),j)=elementsBarra(elementsBarra(:,j)>Eliminar(i),j)-1;
        
    end
    
    coser(coser(:)>Eliminar(i))=coser(coser(:)>Eliminar(i))-1;
    
    
end

nod3(Reemplazar(:,1),:)=[];

end

%% Graficar

figure(30)
graficadorMalladorH8(nod3,elem3D,nod3(:,3))
axis equal

figure(40)
graficadorMalladorH8(nod3,elem3D(find(tipo==3),:),nod3(:,3))
plot3(nod3(coser,1),nod3(coser,2),nod3(coser,3),'r*')
plot3(nod3(elementsBarra(:,1),1),nod3(elementsBarra(:,1),2),nod3(elementsBarra(:,1),3),'m*')
axis equal

figure(50)
graficadorMalladorH8(nod3,elem3D(find(tipo==4),:),nod3(:,3))
plot3(nod3(coser,1),nod3(coser,2),nod3(coser,3),'r*')
plot3(nod3(elementsBarra(:,2),1),nod3(elementsBarra(:,2),2),nod3(elementsBarra(:,2),3),'y*')
axis equal

%% Chequeo de nodos sueltos

checkElem=[];

for i=1:8
    checkElem=[checkElem
               elem3D(:,i)];
end

nodes=1:length(nod3);

check=ismember(nodes,checkElem);

nodoSueltoPorLaVida=find(check==0)

elements=elem3D;

nodes=nod3;

end

