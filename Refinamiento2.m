function [nod3, elem3DSalida]=Refinamiento2(nod3,elem3Entrada,elemARefinar)

pasosDe3=2;

uno=nod3(elem3Entrada(elemARefinar,1),:);
    dos=nod3(elem3Entrada(elemARefinar,2),:);
    tres=nod3(elem3Entrada(elemARefinar,4),:);
    cuatro=nod3(elem3Entrada(elemARefinar,3),:);
    cinco=nod3(elem3Entrada(elemARefinar,5),:);
    seis=nod3(elem3Entrada(elemARefinar,6),:);
    siete=nod3(elem3Entrada(elemARefinar,8),:);
    ocho=nod3(elem3Entrada(elemARefinar,7),:);
    
    numNod=length(nod3(:,1));

aux1=miLinspace(ocho,siete,pasosDe3+1) ;

aux2=miLinspace(seis,cinco,pasosDe3+1) ;

aux3=miLinspace(dos,uno,pasosDe3+1) ;

aux4=miLinspace(cuatro,tres,pasosDe3+1) ;

aux1(1,:)=[];
    
    aux2(1,:)=[];
    
    aux3(1,:)=[];
    
    aux4(1,:)=[];
    
    aux1(end,:)=[];
    nod3=[nod3
        aux1];
    
    aux2(end,:)=[];
    nod3=[nod3
        aux2];
    
    aux3(end,:)=[];
    nod3=[nod3
        aux3];
    
    aux4(end,:)=[];
    nod3=[nod3
        aux4];
    
    elem3DSalida=[11+numNod-8 elem3Entrada(elemARefinar,2) elem3Entrada(elemARefinar,3) 12+numNod-8 10+numNod-8 elem3Entrada(elemARefinar,6) elem3Entrada(elemARefinar,7) 9+numNod-8
                  elem3Entrada(elemARefinar,1) 11+numNod-8 12+numNod-8 elem3Entrada(elemARefinar,4) elem3Entrada(elemARefinar,5) 10+numNod-8 9+numNod-8 elem3Entrada(elemARefinar,8)];
    
%     +numNod-8
    
    %                 uno=nod3(elem3Entrada(elemARefinar,1),:);q
%     dos=nod3(elem3Entrada(elemARefinar,2),:);
%     tres=nod3(elem3Entrada(elemARefinar,4),:);
%     cuatro=nod3(elem3Entrada(elemARefinar,3),:);q
%     cinco=nod3(elem3Entrada(elemARefinar,5),:);
%     seis=nod3(elem3Entrada(elemARefinar,6),:);
%     siete=nod3(elem3Entrada(elemARefinar,8),:);
%     ocho=nod3(elem3Entrada(elemARefinar,7),:);
% 
%     hold on
%     graficadorMalladorH8(nod3, elem3DSalida, nod3(:,3))
end