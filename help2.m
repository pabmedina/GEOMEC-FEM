function [AUXx, AUXz_1, AUXz_2] = help2(elements_Barra,nodos_fis,nodes)



    AUX1 = false(size(elements_Barra,1)/3,1);
    minimo_x = min(nodes(nodos_fis,1));
    minimo_z = min(nodes(nodos_fis,3));
    maximo_z = max(nodes(nodos_fis,3));
    
    eles = elements_Barra(1+size(elements_Barra,1)/3:2*size(elements_Barra,1)/3,1);
    
    for i = 1:size(elements_Barra,1)/3
        inod = nodes(eles(i,1),:);
        for j = 1:length(nodos_fis)
            jnod = nodes(nodos_fis(j),:);
            if inod==jnod 
                AUX1(i) = true;
            end
        end
    end
    
    AUX2=false(size(elements_Barra,1)/3,1);
    
    for i = 1:size(elements_Barra,1)/3
        inod = nodes(eles(i,1),1);
        if inod==minimo_x
            AUX2(i) = true;
        end
    end
    
    AUX3 = false(size(elements_Barra,1)/3,1);
    for i = 1:size(elements_Barra,1)/3
        inod = nodes(elements_Barra(i,1),3);
        if inod==minimo_z
            AUX3(i) = true;
        end
    end
    
    AUX4 = false(size(elements_Barra,1)/3,1);
    for i = 1:size(elements_Barra,1)/3
        inod = nodes(elements_Barra(i,1),3);
        if inod==maximo_z
            AUX4(i) = true;
        end
    end
    
    AUXx = AUX1 & AUX2;
    AUXz_1 = AUX1 & AUX3;
    AUXz_2 = AUX1 & AUX4;


end