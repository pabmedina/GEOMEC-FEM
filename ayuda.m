function AUX = ayuda(elements_Barra,nodos_fis,nodes)



    AUX1 = false(size(elements_Barra,1)/3,1);
    minimo_x = min(nodes(nodos_fis,1));
    
    for i = 1:size(elements_Barra,1)/3
        inod = nodes(elements_Barra(i,1),:);
        for j = 1:length(nodos_fis)
            jnod = nodes(nodos_fis(j),:);
            if inod==jnod 
                AUX1(i) = true;
            end
        end
    end
    
    AUX2=false(size(elements_Barra,1)/3,1);
    
    for i = 1:size(elements_Barra,1)/3
        inod = nodes(elements_Barra(i,1),1);
        if inod==minimo_x
            AUX2(i) = true;
        end
    end
    
    AUX = AUX1 & AUX2;


end

