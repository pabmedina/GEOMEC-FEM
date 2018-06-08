function [row, col, nodesEle] = get_mapping_strat(nel,nodeDofs,ele_strat,nodes,ndofel,nnodel,ndof)

eleDofs = zeros(ndofel,nel);
row=zeros(ndofel,ndofel,nel);

for iele = 1:nel 
    eleDofs(:,iele) = reshape(nodeDofs(ele_strat(iele,:),:)',1,[])';
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
    nodesEle(:,:,i)=nodes(ele_strat(i,:),:);
end


end

