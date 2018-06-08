function [nod3, elem3D,tipo]=unAdina(eleFisura1_ymenos, ...
    eleFisura1_ymas,eleFisura2_ymenos, ...
    eleFisura2_ymas,eleFisura3_ymenos, ...
    eleFisura3_ymas,nodes,elements) 

%% Inicializadores

aperturaFisuras=0;

anchoFisuraMaximo=200;

alturaMaxima=inf;
alturaMinima=-inf;

alturaMaximaCoser=inf;
alturaMinimaCoser=inf;

%% Clasificacion en tipo de elemento
tipo=zeros(length(elements(:,1)),1);

for i=1:length(eleFisura1_ymenos(:,1))
    
    tipo(elements(:,1)==eleFisura1_ymenos(i,1) & elements(:,8)==eleFisura1_ymenos(i,8))=1;
end

for i=1:length(eleFisura1_ymas(:,1))
    
    tipo(elements(:,1)==eleFisura1_ymas(i,1) & elements(:,8)==eleFisura1_ymas(i,8))=2;
end

for i=1:length(eleFisura2_ymenos(:,1))
    
    tipo(elements(:,1)==eleFisura2_ymenos(i,1) & elements(:,8)==eleFisura2_ymenos(i,8))=1;
end

for i=1:length(eleFisura2_ymas(:,1))
    
    tipo(elements(:,1)==eleFisura2_ymas(i,1) & elements(:,8)==eleFisura2_ymas(i,8))=2;
end

for i=1:length(eleFisura3_ymenos(:,1))
    
    tipo(elements(:,1)==eleFisura3_ymenos(i,1) & elements(:,8)==eleFisura3_ymenos(i,8))=1;
end

for i=1:length(eleFisura3_ymas(:,1))
    
    tipo(elements(:,1)==eleFisura3_ymas(i,1) & elements(:,8)==eleFisura3_ymas(i,8))=2;
end
    
%     
% disp(tipo)
% 
% sum(tipo)
% elements(find(tipo),:)

%% Traduccion a variables mias

nod3=nodes;

elem3D=elements;


%% Refinamiento

elemARefinar1=find(tipo==1);

numNod=length(nod3);

nodTipo=zeros(numNod,1);

for i=1:length(elemARefinar1)
    numNod=length(nod3);
    
    % Estaba asi
    
    elem3D(elemARefinar1(i),:)=[elem3D(elemARefinar1(i),2) elem3D(elemARefinar1(i),3) elem3D(elemARefinar1(i),4) elem3D(elemARefinar1(i),1) elem3D(elemARefinar1(i),6) elem3D(elemARefinar1(i),7) elem3D(elemARefinar1(i),8) elem3D(elemARefinar1(i),5)];
    

%     [nod3, elem3DSalida]=Refinamiento3DeUnPaso(nod3,elem3D,elemARefinar1(i));
    
    [nod3, elem3DSalida]=Refinamiento3DeDosPasos(nod3,elem3D,elemARefinar1(i));
    
    elem3DSalida = elem3DSalida(:,[4 1 2 3 8 5 6 7]);
    
    numNodNew=length(nod3);
    
    nodTipo(numNod+1:numNodNew)=1;
    
    elem3D=[elem3D
            elem3DSalida];
        numElem=length(elem3D);
        tipo(numElem-3:numElem)=3;
end

elemARefinar2=find(tipo==2);

for i=1:length(elemARefinar2)
    
    numNod=length(nod3);
    
    % Estaba asi
    
    elem3D(elemARefinar2(i),:)=[elem3D(elemARefinar2(i),4) elem3D(elemARefinar2(i),1) elem3D(elemARefinar2(i),2) elem3D(elemARefinar2(i),3) elem3D(elemARefinar2(i),8) elem3D(elemARefinar2(i),5) elem3D(elemARefinar2(i),6) elem3D(elemARefinar2(i),7)];
        
%     [nod3, elem3DSalida]=Refinamiento3DeUnPaso(nod3,elem3D,elemARefinar2(i));
    
    [nod3, elem3DSalida]=Refinamiento3DeDosPasos(nod3,elem3D,elemARefinar2(i));
    
    elem3DSalida = elem3DSalida(:,[2 3 4 1 6 7 8 5]);
    
    elem3D=[elem3D
            elem3DSalida];
    
	numNodNew=length(nod3);
         
    nodTipo(numNod+1:numNodNew)=2;
        
        numElem=length(elem3D);
        tipo(numElem-3:numElem)=4;
end

elem3D([find(tipo==1)' find(tipo==2)'],:)=[];

tipo([find(tipo==1)' find(tipo==2)'])=[];

nod3=round(nod3,6);

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
%         reemplazar
%         nodTipo(reemplazar)
        
        
%         porNodoAct
        Reemplazar=[Reemplazar
                    reemplazar porNodoAct*ones(length(reemplazar),1)];
                
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
     
    
    
	reemplazar(reemplazar==porNodoAct)=[];
    
    if reemplazar>porNodoAct & nod3(porNodoAct,3)>alturaMaximaCoser
             
        
            Reemplazar=[Reemplazar
                        reemplazar porNodoAct*ones(length(reemplazar),1)];
            coser=[coser
                   porNodoAct];
                
    elseif reemplazar>porNodoAct & nod3(porNodoAct,3)<alturaMinimaCoser
        
            Reemplazar=[Reemplazar
                        reemplazar porNodoAct*ones(length(reemplazar),1)];
            coser=[coser
                   porNodoAct];
    elseif reemplazar>porNodoAct & nod3(porNodoAct,3)>alturaMinimaCoser & nod3(porNodoAct,3)<alturaMaximaCoser
        
        elementsBarra=[elementsBarra
                        reemplazar porNodoAct*ones(length(reemplazar),1)];
                
    end
    
    
end
% figure(40)
% hold on
% plot3(nod3(coser,1),nod3(coser,2),nod3(coser,3),'b*')
% 
% figure(50)
% hold on
% plot3(nod3(coser,1),nod3(coser,2),nod3(coser,3),'b*')

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
    
%     for j=1:2
%         
%         elementsBarra(elementsBarra(:,j)>Eliminar(i),j)=elementsBarra(elementsBarra(:,j)>Eliminar(i),j)-1;
%         
%     end
    
    coser(coser(:)>Eliminar(i))=coser(coser(:)>Eliminar(i))-1;
    
    
end

nod3(Reemplazar(:,1),:)=[];

end

%% Graficar

% figure(30)
% graficadorMalladorH8(nod3,elem3D,nod3(:,3))
% axis equal

% figure(40)
% graficadorMalladorH8(nod3,elem3D(find(tipo==3),:),nod3(:,3))
% plot3(nod3(coser,1),nod3(coser,2),nod3(coser,3),'r*')
% % plot3(nod3(elementsBarra(:,1),1),nod3(elementsBarra(:,1),2),nod3(elementsBarra(:,1),3),'m*')
% axis equal

% figure(50)
% graficadorMalladorH8(nod3,elem3D(find(tipo==4),:),nod3(:,3))
% plot3(nod3(coser,1),nod3(coser,2),nod3(coser,3),'r*')
% % plot3(nod3(elementsBarra(:,2),1),nod3(elementsBarra(:,2),2),nod3(elementsBarra(:,2),3),'y*')
% axis equal

%% Chequeo de nodos sueltos

checkElem=[];

for i=1:8
    checkElem=[checkElem
               elem3D(:,i)];
end

nodes=1:length(nod3);

check=ismember(nodes,checkElem);

nodoSueltoPorLaVida=find(check==0);

% nod3(nod3(:,1)>CoordFisurasX,1)=nod3(nod3(:,1)>CoordFisurasX,1)+aperturaFisuras




end