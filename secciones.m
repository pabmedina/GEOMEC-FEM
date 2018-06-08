function [seccion125, seccion150, seccion175, seccion200] = secciones2(nel,nnodel,elements,nodes)
    % Nos devuelve los elementos que estan en la coordenada y = 100-

    ele_seccion125 = false(nel,1);

    for iele = 1:nel
        i = nodes(elements(iele,:),1);
        for inod = 1:nnodel
            if i(inod) < 125
               ele_seccion125(iele) = true;
            end
        end
    end

    seccion125.elements = elements(ele_seccion125,:);
    seccion125.size = size(seccion125.elements,1);
    
    ele_seccion150 = false(nel,1);

    for iele = 1:nel
        i = nodes(elements(iele,:),1);
        for inod = 1:nnodel
            if i(inod) < 150
               ele_seccion150(iele) = true;
            end
        end
    end

    seccion150.elements = elements(ele_seccion150,:);
    seccion150.size = size(seccion150.elements,1);
    
    ele_seccion175 = false(nel,1);

    for iele = 1:nel
        i = nodes(elements(iele,:),1);
        for inod = 1:nnodel
            if i(inod) < 175
               ele_seccion175(iele) = true;
            end
        end
    end

    seccion175.elements = elements(ele_seccion175,:);
    seccion175.size = size(seccion175.elements,1);    
    
    
    ele_seccion200 = false(nel,1);

    for iele = 1:nel
        i = nodes(elements(iele,:),1);
        for inod = 1:nnodel
            if i(inod) < 200
               ele_seccion200(iele) = true;
            end
        end
    end

    seccion200.elements = elements(ele_seccion200,:);
    seccion200.size = size(seccion200.elements,1);

end

