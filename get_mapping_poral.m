function [row, col, nodesEle] = get_mapping_poral(nel,nodeDofs,elements,nodes,ndofel,nnodel,ndof)

eleDofs = zeros(ndofel,nel);
row=zeros(ndofel,ndofel,nel);
ele = zeros(nnodel,nel);

for iele = 1:nel 
    eleDofs(:,iele) = reshape(nodeDofs(elements(iele,:),:)',1,[])';
    ele(:,iele) = elements(iele,:);
end
col = zeros(nnodel,ndofel,nel);

for i=1:ndofel
    for j=1:nel
    row(:,i,j)=eleDofs(:,j)';    
    col(:,i,j)=ele(:,j)';
    end
end


for j =1:nel
    
    row(:,:,j)=row(:,:,j)';
end

nodesEle=zeros(nnodel,ndof,nel);
for i=1:nel
    nodesEle(:,:,i)=nodes(elements(i,:),:);
end


end
