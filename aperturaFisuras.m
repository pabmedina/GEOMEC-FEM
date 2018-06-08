function gap = aperturaFisuras(nodos1_fisu1,nodos1_fisu2,nodos1_fisu3,D_1,nodos2_fisu1,nodos2_fisu2,nodos2_fisu3,nodes)

    IPA1 = false(size(nodos1_fisu1,1),1);
    inod1 = zeros(size(nodos1_fisu1,1),1);
    
    for i = 1:size(nodos1_fisu1,1)
        inod1(i) = nodes(nodos1_fisu1(i,1),1);
        IPA1(1) = true;
        if i>1
            if inod1(i)<=inod1(1)
                IPA1(i) = true;
            end
        end
    end
    
    gap.fisura1 = mean(D_1(nodos2_fisu1(IPA1),2)) - mean(D_1(nodos1_fisu1(IPA1),2));
    
    IPA2 = false(size(nodos1_fisu2,1),1);
    inod2 = zeros(size(nodos1_fisu2,1),1);
    
    for i = 1:size(nodos1_fisu2,1)
        inod2(i) = nodes(nodos1_fisu2(i,1),1);
        IPA2(1) = true;
        if i>1
            if inod2(i)<=inod2(1)
                IPA2(i) = true;
            end
        end
    end
    
    gap.fisura2 = mean(D_1(nodos2_fisu2(IPA2),2)) - mean(D_1(nodos1_fisu2(IPA2),2));
    
    IPA3 = false(size(nodos1_fisu3,1),1);
    inod3 = zeros(size(nodos1_fisu3,1),1);
    
    for i = 1:size(nodos1_fisu3,1)
        inod3(i) = nodes(nodos1_fisu3(i,1),1);
        IPA3(1) = true;
        if i>1
            if inod3(i)<=inod3(1)
                IPA3(i) = true;
            end
        end
    end
    
    gap.fisura3 = mean(D_1(nodos2_fisu3(IPA3),2)) - mean(D_1(nodos1_fisu3(IPA3),2));

end

