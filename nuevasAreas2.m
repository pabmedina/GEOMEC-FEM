function [ele_fisu2_y2_1, sizeFisu2_1, nodos1_fisu2, ele_fisu2_y2_2 , sizeFisu2_2, nodos2_fisu2] = nuevasAreas2(nodes,elements,m,tol_malla2,nel,nnodel,z_cota1,z_cota2)

        ele_fisu2_1 = false(nel,1);
        
        for iele = 1:nel
            i = nodes(elements(iele,:),1);
            j = nodes(elements(iele,:),2);
            z = nodes(elements(iele,:),3);
            for inod = 1:nnodel
                if i(inod) >= 200 - m*tol_malla2 && i(inod) <= 200 + m*tol_malla2 && j(inod) < 200  && j(inod) > 199.9 && z(inod) < z_cota1 && z(inod) > z_cota2
                    ele_fisu2_1(iele) = true;
                end
            end
        end

        ele_fisu2_y2_1 = elements(ele_fisu2_1,:);
        sizeFisu2_1 = size(ele_fisu2_y2_1,1);

        fisura2.auxiliar1 = reshape(ele_fisu2_y2_1,1,[])';
        fisura2.nodoPosicion1 = fisura2.auxiliar1(nodes(fisura2.auxiliar1,2)>199.95); 
        nodos1_fisu2 = unique(fisura2.nodoPosicion1);             

        fisura2.largo = true(size(nodos1_fisu2,1),1);
        for i = 1:length(fisura2.largo)
            jcont = nodes(nodos1_fisu2(i,:),2);
            if jcont == 200
                fisura2.largo(i) = false;
            end
        end
        nodos1_fisu2 = nodos1_fisu2(fisura2.largo,:);
        norma2_1 = zeros(length(nodos1_fisu2),1);
        for i=1:length(nodos1_fisu2)
            norma2_1(i,1)=norm([nodes(nodos1_fisu2(i),1) nodes(nodos1_fisu2(i),3)]);
        end
        [~,orden2_1]=sort(norma2_1);
        nodos1_fisu2=nodos1_fisu2(orden2_1);

        
        ele_fisu2_2 = false(nel,1);

        for iele = 1:nel
            i = nodes(elements(iele,:),1);
            j = nodes(elements(iele,:),2);
            z = nodes(elements(iele,:),3);
            for inod = 1:nnodel
                if i(inod) >= 200 - m*tol_malla2 && i(inod) <= 200 + m*tol_malla2 && j(inod) > 200  && j(inod) < 200.1  && z(inod) < z_cota1 && z(inod) > z_cota2
                    ele_fisu2_2(iele) = true;
                end

            end
        end

        ele_fisu2_y2_2 = elements(ele_fisu2_2,:);
        sizeFisu2_2 = size(ele_fisu2_y2_2,1);
        
        
        fisura2.auxiliar2 = reshape(ele_fisu2_y2_2,1,[])';
        fisura2.nodoPosicion2 = fisura2.auxiliar2(nodes(fisura2.auxiliar2,2)<200.05); 
        nodos2_fisu2 = unique(fisura2.nodoPosicion2);             

        fisura2.largo2 = true(size(nodos2_fisu2,1),1);
        for i = 1:length(fisura2.largo2)
            jcont = nodes(nodos2_fisu2(i,:),2);
            if jcont == 200
                fisura2.largo2(i) = false;
            end
        end
        nodos2_fisu2 = nodos2_fisu2(fisura2.largo2,:);
        norma2_2 = zeros(length(nodos2_fisu2),1);
        for i=1:length(nodos2_fisu2)
            norma2_2(i,1)=norm([nodes(nodos2_fisu2(i),1) nodes(nodos2_fisu2(i),3)]);
        end
        [~,orden2_2]=sort(norma2_2);
        nodos2_fisu2=nodos2_fisu2(orden2_2);

end

