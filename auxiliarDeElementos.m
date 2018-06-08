function [tipo, sizetipo] = auxiliarDeElementos(elementsFIS,nodes,nnodel,coord)
    ipa2 = false(size(elementsFIS,1),1);
    ipa3 = false(size(elementsFIS,1),1);
    
    
    for iele = 1:size(elementsFIS,1)
        j = nodes(elementsFIS(iele,:),2);
        i = nodes(elementsFIS(iele,:),1);
        for inod = 1:nnodel
            if  j(inod)>coord && i(inod)>300
                ipa2(iele) = true;
            end
            if  j(inod)>coord && i(inod)<100
                ipa3(iele) = true;
            end
        end
    end
    
    aux1 = elementsFIS(ipa2,:);
    aux2 = elementsFIS(ipa3,:);
    
    tipo = [ aux1;aux2];
    sizetipo = size(tipo,1);


end

