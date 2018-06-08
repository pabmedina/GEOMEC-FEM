function [ele_fisu1_y1_1, sizeFisu1_1, nodos1_fisu1, ele_fisu1_y1_2 , sizeFisu1_2, nodos2_fisu1] = nuevasAreas1(nodes,elements,n,tol_malla,nel,nnodel,z_cota1,z_cota2)

        ele_fisu1_1 = false(nel,1);
        
        for iele = 1:nel
            i = nodes(elements(iele,:),1);
            j = nodes(elements(iele,:),2);
            z = nodes(elements(iele,:),3);
            for inod = 1:nnodel
                if i(inod) >= 200 - n*tol_malla && i(inod) <= 200 + n*tol_malla && j(inod) < 100  && j(inod) > 99.95 && z(inod) < z_cota1 && z(inod) > z_cota2
                    ele_fisu1_1(iele) = true;    
                end
            end
        end

        ele_fisu1_y1_1 = elements(ele_fisu1_1,:);
        sizeFisu1_1 = size(ele_fisu1_y1_1,1);
        
        fisura1.auxiliar1 = reshape(ele_fisu1_y1_1,1,[])';
        fisura1.nodoPosicion1 = fisura1.auxiliar1(nodes(fisura1.auxiliar1,2)>99.95); 
        nodos1_fisu1 = unique(fisura1.nodoPosicion1);             
        
        fisura1.largo = true(size(nodos1_fisu1,1),1);
        for i = 1:length(fisura1.largo)
            jcont = nodes(nodos1_fisu1(i,:),2);
            if jcont == 100
                fisura1.largo(i) = false;
            end
        end
        nodos1_fisu1 = nodos1_fisu1(fisura1.largo,:);
        norma1_1 = zeros(length(nodos1_fisu1),1);  
        for i=1:length(nodos1_fisu1)
            norma1_1(i,1) = norm([nodes(nodos1_fisu1(i),1) nodes(nodos1_fisu1(i),3)]);
        end
        [~,orden1_1]=sort(norma1_1);
        nodos1_fisu1=nodos1_fisu1(orden1_1);

        ele_fisu1_2 = false(nel,1);

        for iele = 1:nel
            i = nodes(elements(iele,:),1);
            j = nodes(elements(iele,:),2);
            z = nodes(elements(iele,:),3);
            for inod = 1:nnodel
                if i(inod) >= 200 - n*tol_malla && i(inod) <= 200 + n*tol_malla && j(inod) > 100  && j(inod) < 100.1 && z(inod) < z_cota1 && z(inod) > z_cota2
                    ele_fisu1_2(iele) = true;
                end
            end
        end

        ele_fisu1_y1_2 = elements(ele_fisu1_2,:);
        sizeFisu1_2 = size(ele_fisu1_y1_2,1);
               
        fisura1.auxiliar2 = reshape(ele_fisu1_y1_2,1,[])';        
        fisura1.nodoPosicion2 = fisura1.auxiliar2(nodes(fisura1.auxiliar2,2)<100.05);
        nodos2_fisu1 = unique(fisura1.nodoPosicion2);   

        fisura1.largo2 = true(size(nodos2_fisu1,1),1);
        for i = 1:length(fisura1.largo2)
            jcont = nodes(nodos2_fisu1(i,:),2);
            if jcont == 100
                fisura1.largo2(i) = false;
            end
        end
        nodos2_fisu1 = nodos2_fisu1(fisura1.largo2,:);
        
        norma1_2 = zeros(length(nodos2_fisu1),1);
        for i=1:length(nodos2_fisu1)
            norma1_2(i,1)=norm([nodes(nodos2_fisu1(i),1) nodes(nodos2_fisu1(i),3)]);
        end
        [~,orden1_2]=sort(norma1_2);
        nodos2_fisu1=nodos2_fisu1(orden1_2);

end

