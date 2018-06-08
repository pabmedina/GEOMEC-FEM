function [uno,dos]=condicionDeBorde(elementsBarra,BC,nodosDelDominioDeFisura)
    dos=BC;
    nodosSelectos=elementsBarra(ismember(elementsBarra(:,1),nodosDelDominioDeFisura),1);
    uno=nodosSelectos;
    interseccionDosYNodosSelectos=sparse(length(dos),1);
    for i=1:length(dos)
        interseccionDosYNodosSelectos(i,1)=find(nodosSelectos==dos(i));
    end
    uno(interseccionDosYNodosSelectos)=[];
end

