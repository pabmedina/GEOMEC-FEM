function [nod_in]=detectorDeCoordDeBombas(coordBombas,nodes)

% coordBombas=[200.0000   99.9750   24.9800
%              200.0000  199.9750   24.9800
%              200.0000  299.9750   24.9800];
%          
% tolCoordBombas=[1 1 1];
cB=coordBombas;

nod_aux1 = false(size(nodes,1),1);
nod_aux2 = false(size(nodes,1),1);
nod_aux3 = false(size(nodes,1),1);


for i = 1:size(nodes,1)
    inod = nodes(i,1);
    jnod = nodes(i,2);
    knod = nodes(i,3);
    for j = 1:length(coordBombas(:,1))
        if inod == cB(j,1) 
            nod_aux1(i) = true;
        end
        if jnod == cB(j,2)
            nod_aux2(i) = true;
        end
        if knod == cB(j,3)
            nod_aux3(i) = true;
        end
    end
    
end
logic = nod_aux1 & nod_aux2 & nod_aux3;
nod_in = find(logic);

% nod_in = nodes(nod_aux,1);
% for i=1:length(coordBombas(:,1))
% 
% 
% 
% selector=zeros(length(nodes),1);
% 
% 
% 
% selector(elements_Barra(:,1))=1;
% 
% selector(nodes(:,1)>cB(i,1)-tolCoordBombas(1))=selector(nodes(:,1)>cB(i,1)-tolCoordBombas(1))+1;
% 
% selector(nodes(:,1)<cB(i,1)+tolCoordBombas(1))=selector(nodes(:,1)<cB(i,1)+tolCoordBombas(1))+1;
% 
% selector(nodes(:,2)>cB(i,2)-tolCoordBombas(1))=selector(nodes(:,2)>cB(i,2)-tolCoordBombas(1))+1;
% 
% selector(nodes(:,2)<cB(i,2)+tolCoordBombas(1))=selector(nodes(:,2)<cB(i,2)+tolCoordBombas(1))+1;
% 
% selector(nodes(:,3)>cB(i,3)-tolCoordBombas(1))=selector(nodes(:,3)>cB(i,3)-tolCoordBombas(1))+1;
% 
% selector(nodes(:,3)<cB(i,3)+tolCoordBombas(1))=selector(nodes(:,3)<cB(i,3)+tolCoordBombas(1))+1;
% 
% 
% nod_in(i,1)=min(find(selector==7));
% end