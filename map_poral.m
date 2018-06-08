function [row, col, nodesEle] = map_poral(nel,nodeDofs,elements,nodes,ndofel,nnodel,ndof)

eleDofs = zeros(ndofel,nel);
row=zeros(nnodel,nnodel,nel);
ele = zeros(nnodel,nel);

for iele = 1:nel 
    eleDofs(:,iele) = reshape(nodeDofs(elements(iele,:),:)',1,[])';
    ele(:,iele) = elements(iele,:);
end
col = zeros(nnodel,nnodel,nel);

for i=1:nnodel
    for j=1:nel
    row(:,i,j)=ele(:,j);    
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

