function [selectorLogico]=seleccionDeElementosDeFisura(elementsBarra, elemNew, aperturaMinima,b)
nodosSelectos=elementsBarra(:,1);
num_elem=length(elemNew(:,1));
selector=sparse(num_elem,1);
selectorApertura=selector;

for i=1:length(nodosSelectos)
    for j=1:4
        elementoPosible=find(elemNew(:,j)==nodosSelectos(i));
        selector(elementoPosible)=selector(elementoPosible)+1;
        if b(nodosSelectos(i))>=aperturaMinima
            selectorApertura(elementoPosible)=selectorApertura(elementoPosible)+1;
        end
    end
end


selectorLogico=false(num_elem,1);
% for i=1:num_elem
%     if selector(i)==4 && selectorApertura(i)>=1
%         selectorLogico(i,1)=true;
%     else
%         selectorLogico(i,1)=false;
%     end
% end
selector=floor(selector/4);
selectorLogico(find(selectorApertura.*selector))=true;
end