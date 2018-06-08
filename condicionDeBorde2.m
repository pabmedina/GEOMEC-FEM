function [uno,dos]=condicionDeBorde2(elementsBarra,BC)
    dos=BC;
    nodosSelectos=elementsBarra(:,1);
    uno=nodosSelectos;
    interseccionDosYNodosSelectos=sparse(length(dos),1);
    for i=1:length(dos)
        interseccionDosYNodosSelectos(i,1)=find(nodosSelectos==dos(i));
    end
    uno(interseccionDosYNodosSelectos)=[];
end

