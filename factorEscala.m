function fsArea = factorEscala(nodos_interes,elements,nnodel,area)

aux = false(length(elements),length(nodos_interes));

for inod = 1:length(nodos_interes)
    nodo = nodos_interes(inod);
    for iele = 1:length(elements)
        for nodele = 1: nnodel
            ele_Node = elements(iele,nodele);
            if ele_Node == nodo
                aux(iele,inod) = true;
            end
        end
    end
end

fsArea = zeros(length(nodos_interes),1);
for inod = 1:length(nodos_interes)
    fsArea(inod) = 0.25*sum(area(aux(:,inod)));
end


end

