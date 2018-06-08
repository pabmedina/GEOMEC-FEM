function [Row, Col, nodesEle] = get_mapping_el(nel,nodeDofs,elements,nodes,ndofel,nnodel,ndof)

eleDofs = zeros(ndofel,nel);
row=zeros(ndofel,ndofel,nel);

for iele = 1:nel 
    eleDofs(:,iele) = reshape(nodeDofs(elements(iele,:),:)',1,[])';
end


for i=1:ndofel
    for j=1:nel
    row(:,i,j)=eleDofs(:,j)';    
    end
end

col=zeros(ndofel,ndofel,nel);

for j =1:nel
    col(:,:,j)=row(:,:,j);
    row(:,:,j)=row(:,:,j)';
end

nodesEle=zeros(nnodel,ndof,nel);
for i=1:nel
    nodesEle(:,:,i)=nodes(elements(i,:),:);
end

Col = zeros(ndofel,1,nel);

for i=1:nel
Col(:,1,i)=col(:,1,i);
end

Row = zeros(ndofel,1,nel);
Row(:,1,:) = 1;

end

