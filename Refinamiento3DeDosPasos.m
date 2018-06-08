
function [nod3, elem3DSalida]=Refinamiento3DeDosPasos(nod3,elem3Entrada,elemARefinar)


pasosDe3=2;

%% Generador de refinamiento


    % elements(1,:)=[1 2 4 3 5 6 8 7]
    %
    %       Z
    %       [
    %       [
    %       4----------2
    %      /[         /[
    %     / [        / [
    %    /  [       /  [
    %   3----------1   [
    %   [   [      [   [
    %   [   8------[---6---Y
    %   [  /       [  /
    %   [ /        [ /
    %   [/         [/
    %   7----------5
    %  /
    % X
    
    uno=nod3(elem3Entrada(elemARefinar,1),:);
    dos=nod3(elem3Entrada(elemARefinar,2),:);
    tres=nod3(elem3Entrada(elemARefinar,4),:);
    cuatro=nod3(elem3Entrada(elemARefinar,3),:);
    cinco=nod3(elem3Entrada(elemARefinar,5),:);
    seis=nod3(elem3Entrada(elemARefinar,6),:);
    siete=nod3(elem3Entrada(elemARefinar,8),:);
    ocho=nod3(elem3Entrada(elemARefinar,7),:);
    
    numNod=length(nod3(:,1));
%     nod3=[uno
%         dos
%         tres
%         cuatro
%         cinco
%         seis
%         siete
%         ocho];
    
%     elem3D=[uno dos cuatro tres cinco seis ocho siete];
    
    
    %% Direccion de refinamiento X
    
    
    for resumen=1
    
%     aux1=[linspace(ocho(1),siete(1),pasosDe3+1)' linspace(ocho(2),siete(2),pasosDe3+1)' linspace(ocho(3),siete(3),pasosDe3+1)'];
    
    aux1=miLinspace(ocho,siete,pasosDe3+1) ;
    
%     aux1(1,:)=[];
    
%     aux2=[linspace(seis(1),cinco(1),pasosDe3+1)' linspace(seis(2),cinco(2),pasosDe3+1)' linspace(seis(3),cinco(3),pasosDe3+1)'];
    
    aux2=miLinspace(seis,cinco,pasosDe3+1) ;
    
%     aux2(1,:)=[];
    
%     aux3=[linspace(dos(1),uno(1),pasosDe3+1)' linspace(dos(2),uno(2),pasosDe3+1)' linspace(dos(3),uno(3),pasosDe3+1)'];
    
    aux3=miLinspace(dos,uno,pasosDe3+1) ;
    
%     aux3(1,:)=[];
    
%     aux4=[linspace(cuatro(1),tres(1),pasosDe3+1)' linspace(cuatro(2),tres(2),pasosDe3+1)' linspace(cuatro(3),tres(3),pasosDe3+1)'];
    
    aux4=miLinspace(cuatro,tres,pasosDe3+1) ;
    
%     aux4(1,:)=[];
    
    
    if length(aux1(:,1))>0
    
    for i=1:length(aux1(:,1))
        
        aux5=[linspace(aux1(i,1), aux2(i,1),3^(i-1)+1)', linspace(aux1(i,2), aux2(i,2),3^(i-1)+1)', linspace(aux1(i,3), aux2(i,3),3^(i-1)+1)'];
        
        aux6=[linspace(aux3(i,1), aux4(i,1),3^(i-1)+1)', linspace(aux3(i,2), aux4(i,2),3^(i-1)+1)', linspace(aux3(i,3), aux4(i,3),3^(i-1)+1)'];
        
        
        
        aux5(1,:)=[];
        
        aux5(end,:)=[];
        
        nod3=[nod3
            aux5];
        
        aux6(1,:)=[];
        
        aux6(end,:)=[];
        
        nod3=[nod3
            aux6];
        
    end
    for i=1:length(aux1(:,1))-1
        aux51=[linspace((aux1(i,1)+aux1(i+1,1))*0.5, (aux2(i,1)+aux2(i+1,1))*0.5,3^(i)+1)',...
               linspace((aux1(i,2)+aux1(i+1,2))*0.5, (aux2(i,2)+aux2(i+1,2))*0.5,3^(i)+1)',...
               linspace((aux1(i,3)+aux1(i+1,3))*0.5, (aux2(i,3)+aux2(i+1,3))*0.5,3^(i)+1)'];
        
        aux61=[linspace((aux3(i,1)+aux3(i+1,1))*0.5, (aux4(i,1)+aux4(i+1,1))*0.5,3^(i)+1)',...
               linspace((aux3(i,2)+aux3(i+1,2))*0.5, (aux4(i,2)+aux4(i+1,2))*0.5,3^(i)+1)',...
               linspace((aux3(i,3)+aux3(i+1,3))*0.5, (aux4(i,3)+aux4(i+1,3))*0.5,3^(i)+1)'];
           
%            aux51([1:3:end 4:3:end],:)=[];
           
           aux51([1:3:end],:)=[];
        
%         aux51(3:3:end,:)=[];
        
        nod3=[nod3
            aux51];
        
        aux61([1:3:end],:)=[];
        
%         aux61(3:3:end,:)=[];
        
        nod3=[nod3
            aux61];
    end
    
    
    end
    
    
    
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
    
    
%     plot3(nod3(:,1),nod3(:,2),nod3(:,3),'*')
%     hold on
%     for i=1:length(nod3)
%         text(nod3(i,1),nod3(i,2),nod3(i,3),num2str(i))
%     end
%     
%     hold on
%     
%     plot3(nod3(1:8,1),nod3(1:8,2),nod3(1:8,3),'*')
%     
%     axis equal
% %     xlim([0.9 1])
% % ylim([0 0.1])
% % zlim([0 .01])
% axis off
    end
    
    
%     elem3Dsalida=[12 16 4 3 9 13 8 7
%             11 15 16 12 10 14 13 9
%             1 2 15 11 5 6 14 10
%             15 2 4 16 14 6 8 13];
% figure(5)
%     elem3DSalida=[12+numNod-8 16+numNod-8 elem3Entrada(elemARefinar,3) elem3Entrada(elemARefinar,4) 9+numNod-8 13+numNod-8 elem3Entrada(elemARefinar,7) elem3Entrada(elemARefinar,8)
%             11+numNod-8 15+numNod-8 16+numNod-8 12+numNod-8 10+numNod-8 14+numNod-8 13+numNod-8 9+numNod-8
%             elem3Entrada(elemARefinar,1) elem3Entrada(elemARefinar,2) 15+numNod-8 11+numNod-8 elem3Entrada(elemARefinar,5) elem3Entrada(elemARefinar,6) 14+numNod-8 10+numNod-8
%             15+numNod-8 elem3Entrada(elemARefinar,2) elem3Entrada(elemARefinar,3) 16+numNod-8 14+numNod-8 elem3Entrada(elemARefinar,6) elem3Entrada(elemARefinar,7) 13+numNod-8];
%         
%     elem3DSalida=[12+numNod-8 16+numNod-8 elem3Entrada(elemARefinar,3) elem3Entrada(elemARefinar,4) 9+numNod-8 13+numNod-8 elem3Entrada(elemARefinar,7) elem3Entrada(elemARefinar,8)
%             11+numNod-8 15+numNod-8 16+numNod-8 12+numNod-8 10+numNod-8 14+numNod-8 13+numNod-8 9+numNod-8
%             elem3Entrada(elemARefinar,1) elem3Entrada(elemARefinar,2) 15+numNod-8 11+numNod-8 elem3Entrada(elemARefinar,5) elem3Entrada(elemARefinar,6) 14+numNod-8 10+numNod-8
%             15+numNod-8 elem3Entrada(elemARefinar,2) elem3Entrada(elemARefinar,3) 16+numNod-8 14+numNod-8 elem3Entrada(elemARefinar,6) elem3Entrada(elemARefinar,7) 13+numNod-8];
    
        
    elem3DSalida=[  12+numNod-8 32+numNod-8 elem3Entrada(elemARefinar,3)  48+numNod-8 9+numNod-8  29+numNod-8 elem3Entrada(elemARefinar,7)  45+numNod-8
                    11+numNod-8 31+numNod-8 32+numNod-8 12+numNod-8 10+numNod-8 30+numNod-8 29+numNod-8 9+numNod-8 
                    47+numNod-8 elem3Entrada(elemARefinar,2)  31+numNod-8 11+numNod-8 46+numNod-8 elem3Entrada(elemARefinar,6)  30+numNod-8 10+numNod-8
                    31+numNod-8 elem3Entrada(elemARefinar,2)  elem3Entrada(elemARefinar,3)  32+numNod-8 30+numNod-8 elem3Entrada(elemARefinar,6)  elem3Entrada(elemARefinar,7)  29+numNod-8
                    28+numNod-8 44+numNod-8 48+numNod-8 elem3Entrada(elemARefinar,4)  13+numNod-8 33+numNod-8 45+numNod-8 elem3Entrada(elemARefinar,8) 
                    27+numNod-8 43+numNod-8 44+numNod-8 28+numNod-8 14+numNod-8 34+numNod-8 33+numNod-8 13+numNod-8
                    26+numNod-8 12+numNod-8 43+numNod-8 27+numNod-8 15+numNod-8 9+numNod-8  34+numNod-8 14+numNod-8
                    43+numNod-8 12+numNod-8 48+numNod-8 44+numNod-8 34+numNod-8 9+numNod-8  45+numNod-8 33+numNod-8
                    25+numNod-8 42+numNod-8 12+numNod-8 26+numNod-8 16+numNod-8 35+numNod-8 9+numNod-8  15+numNod-8
                    24+numNod-8 41+numNod-8 42+numNod-8 25+numNod-8 17+numNod-8 36+numNod-8 35+numNod-8 16+numNod-8
                    23+numNod-8 11+numNod-8 41+numNod-8 24+numNod-8 18+numNod-8 10+numNod-8 36+numNod-8 17+numNod-8
                    41+numNod-8 11+numNod-8 12+numNod-8 42+numNod-8 36+numNod-8 10+numNod-8 9+numNod-8  35+numNod-8
                    22+numNod-8 40+numNod-8 11+numNod-8 23+numNod-8 19+numNod-8 37+numNod-8 10+numNod-8 18+numNod-8
                    21+numNod-8 39+numNod-8 40+numNod-8 22+numNod-8 20+numNod-8 38+numNod-8 37+numNod-8 19+numNod-8
                    elem3Entrada(elemARefinar,1)  47+numNod-8 39+numNod-8 21+numNod-8 elem3Entrada(elemARefinar,5)  46+numNod-8 38+numNod-8 20+numNod-8 
                    39+numNod-8 47+numNod-8 11+numNod-8 40+numNod-8 38+numNod-8 46+numNod-8 10+numNod-8 37+numNod-8];
                
                
                
%                 uno=nod3(elem3Entrada(elemARefinar,1),:);q
%     dos=nod3(elem3Entrada(elemARefinar,2),:);
%     tres=nod3(elem3Entrada(elemARefinar,4),:);
%     cuatro=nod3(elem3Entrada(elemARefinar,3),:);q
%     cinco=nod3(elem3Entrada(elemARefinar,5),:);
%     seis=nod3(elem3Entrada(elemARefinar,6),:);
%     siete=nod3(elem3Entrada(elemARefinar,8),:);
%     ocho=nod3(elem3Entrada(elemARefinar,7),:);
        
%     hold on
%     graficadorMalladorH8(nod3, elem3DSalida, nod3(:,3))
    
    
    
end
    