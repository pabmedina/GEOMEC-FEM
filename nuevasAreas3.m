function  [ele_fisu3_y3_1, sizeFisu3_1, nodos1_fisu3, ele_fisu3_y3_2 , sizeFisu3_2, nodos2_fisu3] = nuevasAreas3(nodes,elements,p,tol_malla3,nel,nnodel,z_cota1,z_cota2)
        ele_fisu3_1 = false(nel,1);
        
        for iele = 1:nel
            i = nodes(elements(iele,:),1);
            j = nodes(elements(iele,:),2);
            z = nodes(elements(iele,:),3);
            for inod = 1:nnodel
                if i(inod) >= 200 - p*tol_malla3 && i(inod) <= 200 + p*tol_malla3 && j(inod) < 300  && j(inod) > 299.9 && z(inod) < z_cota1 && z(inod) > z_cota2
                    ele_fisu3_1(iele) = true;
                end

            end
        end

        ele_fisu3_y3_1 = elements(ele_fisu3_1,:);
        sizeFisu3_1 = size(ele_fisu3_y3_1,1);
        
        
        fisura3.auxiliar1 = reshape(ele_fisu3_y3_1,1,[])';
        fisura3.nodoPosicion1 = fisura3.auxiliar1(nodes(fisura3.auxiliar1,2)>299.95); 
        nodos1_fisu3 = unique(fisura3.nodoPosicion1);             

        fisura3.largo = true(size(nodos1_fisu3,1),1);
        for i = 1:length(fisura3.largo)
            jcont = nodes(nodos1_fisu3(i,:),2);
            if jcont == 300
                fisura3.largo(i) = false;
            end
        end
        nodos1_fisu3 = nodos1_fisu3(fisura3.largo,:);
        norma3_1 = zeros(length(nodos1_fisu3),1);
        for i=1:length(nodos1_fisu3)
            norma3_1(i,1)=norm([nodes(nodos1_fisu3(i),1) nodes(nodos1_fisu3(i),3)]);
        end
        [~,orden3_1]=sort(norma3_1);
        nodos1_fisu3=nodos1_fisu3(orden3_1);
        
        ele_fisu3_2 = false(nel,1);

        for iele = 1:nel
            i = nodes(elements(iele,:),1);
            j = nodes(elements(iele,:),2);
            z = nodes(elements(iele,:),3);
            for inod = 1:nnodel
                if i(inod) >= 200 - p*tol_malla3 && i(inod) <= 200 + p*tol_malla3 && j(inod) > 300  && j(inod) < 300.1 && z(inod) < z_cota1 && z(inod) > z_cota2
                    ele_fisu3_2(iele) = true;
                end
            end
        end

        ele_fisu3_y3_2 = elements(ele_fisu3_2,:);
        sizeFisu3_2 = size(ele_fisu3_y3_2,1);
        
        
        fisura3.auxiliar2 = reshape(ele_fisu3_y3_2,1,[])';
        fisura3.nodoPosicion2 = fisura3.auxiliar2(nodes(fisura3.auxiliar2,2)<300.05); 
        nodos2_fisu3 = unique(fisura3.nodoPosicion2);             

        fisura3.largo2 = true(size(nodos2_fisu3,1),1);
        for i = 1:length(fisura3.largo2)
            jcont = nodes(nodos2_fisu3(i,:),2);
            if jcont == 300
                fisura3.largo2(i) = false;
            end
        end
        nodos2_fisu3 = nodos2_fisu3(fisura3.largo2,:);
        norma3_2 = zeros(length(nodos2_fisu3),1);
        for i=1:length(nodos2_fisu3)
            norma3_2(i,1)=norm([nodes(nodos2_fisu3(i),1) nodes(nodos2_fisu3(i),3)]);
        end
        [~,orden3_2]=sort(norma3_2);
        nodos2_fisu3=nodos2_fisu3(orden3_2);

end

