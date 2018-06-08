function [bCorr,b]=aperturaDeGrietaConCorreccion(nod,elementsBarra,f,f_0)
num_nod = length(nod(:,1));
b = sparse(num_nod,1);
for i=1:length(elementsBarra(:,1))
    b(elementsBarra(i,1),1) = norm(nod(elementsBarra(i,1),:)-nod(elementsBarra(i,2),:));
end

bCorr=b*(sqrt(f/f_0));
end