function v = node2dof(nodeList, nDof)        % v=node2dof(elements(1,1:2),3)    ---> node2dof( [1 2], 3)
                                             %% v=node2dof(elements(2,1:2),3)-------> node2dof( [1 3], 3) 
nNod = length(nodeList);                 %2

v = zeros(nNod,nDof);                   % 2*3

for iNod = 1:nNod                % hasta 2
    v(iNod,:) =  ((nodeList(iNod) - 1)*nDof + 1) : nodeList(iNod)*nDof;   % v(1,:) = 1:3;  %% v(1,:) = 1:3
                                                                              % v(2,:) = 4:6    %% v(2,:) = 7:9
end

v = reshape(v',1,[]);
    
