function [elemNew]=eliminadorElementosDobles(elem)
e=1;
num_elem=length(elem);
selector=zeros(num_elem,1);
while e<num_elem
nodosSelectos=elem(e,:);
selector=zeros(num_elem,1);
for i=1:4
    for j=1:4
        elementoPosible=find(elem([e+1:num_elem],j)==nodosSelectos(i));
        selector(elementoPosible+e)=selector(elementoPosible+e)+1;
    end
end
eliminar=find(selector==4);
elem(eliminar,:)=[];
num_elem=length(elem);
e=e+1;
end
elemNew=elem;
end