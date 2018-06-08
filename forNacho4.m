function [tipo]=forNacho4(nod3,elem3D)

CoordFisurasX=[100 200 300];

anchoFisuraMaximo=199;

alturaMaxima=54.55-1;% d_estrato_10 = 15;   
alturaMinima=15+1;% d_estrato_5 = 54.55;

nod3=round(nod3(:,[2 1 3])); % para que quede como lo habia programado yo


LargoY=400;%6000;

graficarMalla=false;%true;%

tipo=zeros(length(elem3D),1);

%% La magia
for k=1:length(CoordFisurasX)
posicionFisura=CoordFisurasX(k);

% nodosObjetivo=nod3(nod3(:,1)==posicionFisura,:);
% plot3(nodosObjetivo(:,1),nodosObjetivo(:,2),nodosObjetivo(:,3),'*')
% hold on
nodosObjetivo=find(nod3(:,1)==posicionFisura...
                    & nod3(:,2)>(LargoY-anchoFisuraMaximo)*0.5...
                    & nod3(:,2)<(LargoY+anchoFisuraMaximo)*0.5...
                    & nod3(:,3)<=alturaMaxima ...
                    & nod3(:,3)>=alturaMinima);



% % % % % plot3(nodosObjetivo(:,1),nodosObjetivo(:,2),nodosObjetivo(:,3),'*')
% % % % 
% % % % nodosDuplex=nodosObjetivo;
% % % % 
% % % % 
% % % % % plot3(nodosDuplex(:,1),nodosDuplex(:,2),nodosDuplex(:,3),'*')
% % % % 
% % % % numNod=length(nod3(:,1));
% % % % 
% % % % reemplazarNod(1)=0;
% % % % 
% % % % por(1)=0;
% % % % 
% % % % for i=1:length(nodosDuplex(:,1))
% % % %     aux=length(find(nod3(:,1)==nodosDuplex(i,1) & nod3(:,2)==nodosDuplex(i,2) & nod3(:,3)==nodosDuplex(i,3)));
% % % %     reemplazarNod(end+1:end+aux,1)=find(nod3(:,1)==nodosDuplex(i,1) & nod3(:,2)==nodosDuplex(i,2) & nod3(:,3)==nodosDuplex(i,3));
% % % %     por(end+1:end+aux,1)=numNod+i;
% % % % end
% % % % reemplazarNod(1)=[];
% % % % 
% % % % por(1)=[];
% % % % % plot3(nod3(reemplazarNod,1),nod3(reemplazarNod,2),nod3(reemplazarNod,3),'+')
% % % % 
% % % % reemplazarNodPor=[reemplazarNod por];
% % % % 
% % % % % elementsBarra=[elementsBarra
% % % % %                reemplazarNodPor];
% % % % 
% % % % % nodosDuplex(:,1)=nodosDuplex(:,1)+aperturaFisuras*ones(length(nodosDuplex(:,1)),1);
% % % % 
% % % % % nod3=[nod3
% % % % %       nodosDuplex];
% % % % % figure
% % % % % plot3(nod3(:,1),nod3(:,2),nod3(:,3),'*')
% % % % 
% % % % 
% % % % % Ya genere los nodos, ahora tengo que hacer que los elementos del otro
% % % % % lado de la fisura vean los elementos que tienen que ver
% % % % clear aux

for i=1:length(nodosObjetivo(:,1))
    aux=find(elem3D(:,1)==nodosObjetivo(i,1) | ...
             elem3D(:,2)==nodosObjetivo(i,1) | ...
             elem3D(:,3)==nodosObjetivo(i,1) | ...
             elem3D(:,4)==nodosObjetivo(i,1) | ...
             elem3D(:,5)==nodosObjetivo(i,1) | ...
             elem3D(:,6)==nodosObjetivo(i,1) | ...
             elem3D(:,7)==nodosObjetivo(i,1) | ...
             elem3D(:,8)==nodosObjetivo(i,1));
    for j=1:length(aux)
        if sum(nod3(elem3D(aux(j),:),1))>posicionFisura*8
            tipo(aux(j))=2;
%             elem3D(aux(j),elem3D(aux(j),:)==nodosObjetivo(i,1))=nodosObjetivo(i,2);
        else
            tipo(aux(j))=1;
        end
    end
    
end
if graficarMalla==true
    figure(10)
    graficadorMalladorH8(nod3,elem3D(find(tipo==1),:),nod3(:,3))
    plot3(nod3(nodosObjetivo,1),nod3(nodosObjetivo,2),nod3(nodosObjetivo,3),'k*')
    hold on
    figure(20)
    graficadorMalladorH8(nod3,elem3D(find(tipo==2),:),nod3(:,3))
    plot3(nod3(nodosObjetivo,1),nod3(nodosObjetivo,2),nod3(nodosObjetivo,3),'k*')
    hold on
end
end

%% La segunda magia

for k=1:length(CoordFisurasX)

    posicionFisura=CoordFisurasX(k);
    
    ObjetivoTipo3Y4=find(nod3(:,1)==posicionFisura);
    
    ObjetivoTipo5Y6=find(nod3(:,1)==posicionFisura...
                        & nod3(:,2)>(LargoY-anchoFisuraMaximo)*0.5...
                        & nod3(:,2)<(LargoY+anchoFisuraMaximo)*0.5...
                        & nod3(:,3)>alturaMaxima);
    
    ObjetivoTipo7Y8=find(nod3(:,1)==posicionFisura...
                        & nod3(:,2)>(LargoY-anchoFisuraMaximo)*0.5...
                        & nod3(:,2)<(LargoY+anchoFisuraMaximo)*0.5...
                        & nod3(:,3)<alturaMinima);
                    
                    
    %Seleccoin de los minimos (5y6) o maximos (7y8) para filtrar los tipos
    i=0;
    while i<length(ObjetivoTipo5Y6)
        i=i+1;
        if isempty(find(nod3(ObjetivoTipo5Y6,1)==nod3(ObjetivoTipo5Y6(i),1) & nod3(ObjetivoTipo5Y6,2)==nod3(ObjetivoTipo5Y6(i),2) & nod3(ObjetivoTipo5Y6,3)>nod3(ObjetivoTipo5Y6(i),3)))==false
            ObjetivoTipo5Y6(nod3(ObjetivoTipo5Y6,1)==nod3(ObjetivoTipo5Y6(i),1) & nod3(ObjetivoTipo5Y6,2)==nod3(ObjetivoTipo5Y6(i),2) & nod3(ObjetivoTipo5Y6,3)>nod3(ObjetivoTipo5Y6(i),3))=[];
            i=0;
        end
    end
    i=0;
    while i<length(ObjetivoTipo7Y8)
        i=i+1;
        if isempty(find(nod3(ObjetivoTipo7Y8,1)==nod3(ObjetivoTipo7Y8(i),1) & nod3(ObjetivoTipo7Y8,2)==nod3(ObjetivoTipo7Y8(i),2) & nod3(ObjetivoTipo7Y8,3)<nod3(ObjetivoTipo7Y8(i),3)))==false
            ObjetivoTipo7Y8(nod3(ObjetivoTipo7Y8,1)==nod3(ObjetivoTipo7Y8(i),1) & nod3(ObjetivoTipo7Y8,2)==nod3(ObjetivoTipo7Y8(i),2) & nod3(ObjetivoTipo7Y8,3)<nod3(ObjetivoTipo7Y8(i),3))=[];
            i=0;
        end
    end
%     i=0;
%     while i<length(ObjetivoTipo3Y4)
%         i=i+1;
%         if isempty(find(nod3(ObjetivoTipo3Y4,1)==nod3(ObjetivoTipo3Y4(i),1) & nod3(ObjetivoTipo3Y4,2)==nod3(ObjetivoTipo3Y4(i),2) & nod3(ObjetivoTipo3Y4,3)>nod3(ObjetivoTipo3Y4(i),3)))==false
%             ObjetivoTipo3Y4(nod3(ObjetivoTipo3Y4,1)==nod3(ObjetivoTipo3Y4(i),1) & nod3(ObjetivoTipo3Y4,2)==nod3(ObjetivoTipo3Y4(i),2) & nod3(ObjetivoTipo3Y4,3)>nod3(ObjetivoTipo3Y4(i),3))=[];
%             i=0;
%         end
%     end
    
    if graficarMalla==true
        
        figure(10)
        graficadorMalladorH8(nod3,elem3D(find(tipo==1),:),nod3(:,3))
        plot3(nod3(ObjetivoTipo5Y6,1),nod3(ObjetivoTipo5Y6,2),nod3(ObjetivoTipo5Y6,3),'k+')
        hold on
        plot3(nod3(ObjetivoTipo7Y8,1),nod3(ObjetivoTipo7Y8,2),nod3(ObjetivoTipo7Y8,3),'b+')
%         plot3(nodosDuplex(:,1),nodosDuplex(:,2),nodosDuplex(:,3),'w*')
%         axis equal
        
        figure(20)
        graficadorMalladorH8(nod3,elem3D(find(tipo==2),:),nod3(:,3))
        plot3(nod3(ObjetivoTipo5Y6,1),nod3(ObjetivoTipo5Y6,2),nod3(ObjetivoTipo5Y6,3),'k+')
        hold on
        plot3(nod3(ObjetivoTipo7Y8,1),nod3(ObjetivoTipo7Y8,2),nod3(ObjetivoTipo7Y8,3),'b+')
%         plot3(nodosDuplex(:,1),nodosDuplex(:,2),nodosDuplex(:,3),'w*')
%         axis equal
        
    end
    
    
    for i=1:length(ObjetivoTipo5Y6)
        aux=find(elem3D(:,1)==ObjetivoTipo5Y6(i,1) | ...
                 elem3D(:,2)==ObjetivoTipo5Y6(i,1) | ...
                 elem3D(:,3)==ObjetivoTipo5Y6(i,1) | ...
                 elem3D(:,4)==ObjetivoTipo5Y6(i,1) | ...
                 elem3D(:,5)==ObjetivoTipo5Y6(i,1) | ...
                 elem3D(:,6)==ObjetivoTipo5Y6(i,1) | ...
                 elem3D(:,7)==ObjetivoTipo5Y6(i,1) | ...
                 elem3D(:,8)==ObjetivoTipo5Y6(i,1));
        for j=1:length(aux)
            if sum(nod3(elem3D(aux(j),:),1))>posicionFisura*8
                if tipo(aux(j))==2
                else
                    tipo(aux(j))=6;
                end
            else
                if tipo(aux(j))==1
                else
                    tipo(aux(j))=5;
                end
            end
        end
        
    end
    for i=1:length(ObjetivoTipo7Y8)
        aux=find(elem3D(:,1)==ObjetivoTipo7Y8(i,1) | ...
                 elem3D(:,2)==ObjetivoTipo7Y8(i,1) | ...
                 elem3D(:,3)==ObjetivoTipo7Y8(i,1) | ...
                 elem3D(:,4)==ObjetivoTipo7Y8(i,1) | ...
                 elem3D(:,5)==ObjetivoTipo7Y8(i,1) | ...
                 elem3D(:,6)==ObjetivoTipo7Y8(i,1) | ...
                 elem3D(:,7)==ObjetivoTipo7Y8(i,1) | ...
                 elem3D(:,8)==ObjetivoTipo7Y8(i,1));
        for j=1:length(aux)
            if sum(nod3(elem3D(aux(j),:),1))>posicionFisura*8
                if tipo(aux(j))==2
                else
                    tipo(aux(j))=8;
                end
            else
                if tipo(aux(j))==1
                else
                    tipo(aux(j))=7;
                end
            end
        end
        
    end
    
    for i=1:length(ObjetivoTipo3Y4)
        aux=find(elem3D(:,1)==ObjetivoTipo3Y4(i,1) | ...
                 elem3D(:,2)==ObjetivoTipo3Y4(i,1) | ...
                 elem3D(:,3)==ObjetivoTipo3Y4(i,1) | ...
                 elem3D(:,4)==ObjetivoTipo3Y4(i,1) | ...
                 elem3D(:,5)==ObjetivoTipo3Y4(i,1) | ...
                 elem3D(:,6)==ObjetivoTipo3Y4(i,1) | ...
                 elem3D(:,7)==ObjetivoTipo3Y4(i,1) | ...
                 elem3D(:,8)==ObjetivoTipo3Y4(i,1));
        for j=1:length(aux)
            if sum(nod3(elem3D(aux(j),:),1))>posicionFisura*8
                if tipo(aux(j))==0%2
%                 else
                    tipo(aux(j))=4;
                end
            else
                if tipo(aux(j))==0%1
%                 else
                    tipo(aux(j))=3;
                end
            end
        end
        
    end
    
end