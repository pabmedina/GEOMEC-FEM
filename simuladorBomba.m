function [PinReal]=simuladorBomba(PinMax,QActual,QMax,dos,num_nod)
PinReal=zeros(num_nod,1);
% aux1=find(QActual(dos)>=QMax);
% QActual(dos(aux1))=QMax*1;
PinReal(dos)=PinMax*(1-(QActual(dos)/QMax));
aux1=find(PinReal(dos)<0);
PinReal(dos(aux1))=0;
aux2=find(PinReal(dos)>PinMax);
PinReal(dos(aux2))=PinMax;


end



