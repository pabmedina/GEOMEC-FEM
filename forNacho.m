function [eleFisura1_ymenos, sizefis1_menos, eleFisura1_ymas,sizefis1_mas,eleFisura2_ymenos,sizefis2_menos,eleFisura2_ymas,sizefis2_mas,eleFisura3_ymenos,sizefis3_menos,eleFisura3_ymas,sizefis3_mas] = forNacho(nel,nnodel,nodes,elements)  

    % Nos devuelve los elementos que estan en la coordenada y = 100-

    ele_fisu1_1 = false(nel,1);

    for iele = 1:nel
        j = nodes(elements(iele,:),2);
        for inod = 1:nnodel
            if j(inod) < 99 
               ele_fisu1_1(iele) = true;
            end
        end
    end
    
    eleFisura1_ymenos = elements(ele_fisu1_1,:);

    
    ipa = false(size(eleFisura1_ymenos,1),1);

    for iele = 1:size(eleFisura1_ymenos,1)
        j = nodes(eleFisura1_ymenos(iele,:),2);
        i = nodes(eleFisura1_ymenos(iele,:),1);
        for inod = 1:nnodel
            if  j(inod)>95 && i(inod)<300 && i(inod)>100
                ipa(iele) = true;
            end
        end
    end
        
    eleFisura1_ymenos = eleFisura1_ymenos(ipa,:);
    sizefis1_menos = size(eleFisura1_ymenos,1);


%     % Nos devuelve los elementos que estan en la coordenada y = 100+

    ele_fisu1_2 = false(nel,1);

    for iele = 1:nel
        j = nodes(elements(iele,:),2);
        for inod = 1:nnodel
            if j(inod) > 100 && j(inod)<200  
               ele_fisu1_2(iele) = true;
            end
        end
    end
    
    eleFisura1_ymas = elements(ele_fisu1_2,:);
    
    ipa1 = false(size(eleFisura1_ymas,1),1);

    for iele = 1:size(eleFisura1_ymas,1)
        j = nodes(eleFisura1_ymas(iele,:),2);
        i = nodes(eleFisura1_ymas(iele,:),1);
        for inod = 1:nnodel
            if  j(inod)<105 && i(inod)<300 && i(inod)>100
                ipa1(iele) = true;
            end
        end
    end
        
    eleFisura1_ymas = eleFisura1_ymas(ipa1,:);
    sizefis1_mas = size(eleFisura1_ymas,1);
    
    
%     % Nos devuelve los elementos que estan en la coordenada y = 200-

    ele_fisu2_1 = false(nel,1);

    for iele = 1:nel
        j = nodes(elements(iele,:),2);
        for inod = 1:nnodel
            if j(inod) < 200 && j(inod) > 140
               ele_fisu2_1(iele) = true;
            end
        end
    end
% 
    eleFisura2_ymenos = elements(ele_fisu2_1,:);
    
    stout = false(size(eleFisura2_ymenos,1),1);

    for iele = 1:size(eleFisura2_ymenos,1)
        j = nodes(eleFisura2_ymenos(iele,:),2);
        i = nodes(eleFisura2_ymenos(iele,:),1);
        for inod = 1:nnodel
            if  j(inod)>199 && i(inod)<300 && i(inod)>100
                stout(iele) = true;
            end
        end
    end
        
    eleFisura2_ymenos = eleFisura2_ymenos(stout,:);
    sizefis2_menos = size(eleFisura2_ymenos,1);

%     % Nos devuelve los elementos que estan en la coordenada y = 200+

    ele_fisu2_2 = false(nel,1);

    for iele = 1:nel
        j = nodes(elements(iele,:),2);
        for inod = 1:nnodel
            if j(inod) > 200  && j(inod) < 255
               ele_fisu2_2(iele) = true;
            end
        end
    end
    
    eleFisura2_ymas = elements(ele_fisu2_2,:);
    
    stout2 = false(size(eleFisura2_ymas,1),1);

    for iele = 1:size(eleFisura2_ymas,1)
        j = nodes(eleFisura2_ymas(iele,:),2);
        i = nodes(eleFisura2_ymas(iele,:),1);
        for inod = 1:nnodel
            if  j(inod)<205 && i(inod)<300 && i(inod)>100
                stout2(iele) = true;
            end
        end
    end
        
    eleFisura2_ymas = eleFisura2_ymas(stout2,:);
    sizefis2_mas = size(eleFisura2_ymas,1);

%     % Nos devuelve los elementos que estan en la coordenada y = 300-

    ele_fisu3_1 = false(nel,1);

    for iele = 1:nel
        j = nodes(elements(iele,:),2);
        for inod = 1:nnodel
            if j(inod) < 300  %&& j(inod) > 240
               ele_fisu3_1(iele) = true;
            end
        end
    end

    eleFisura3_ymenos = elements(ele_fisu3_1,:);
    
    honney = false(size(eleFisura3_ymenos,1),1);

    for iele = 1:size(eleFisura3_ymenos,1)
        j = nodes(eleFisura3_ymenos(iele,:),2);
        i = nodes(eleFisura3_ymenos(iele,:),1);
        for inod = 1:nnodel
            if  j(inod)>298 && i(inod)<300 && i(inod)>100
                honney(iele) = true;
            end
        end
    end
        
    eleFisura3_ymenos = eleFisura3_ymenos(honney,:);
    sizefis3_menos = size(eleFisura3_ymenos,1);
  
%     % Nos devuelve los elementos que estan en la coordenada y = 300+

    ele_fisu3_2 = false(nel,1);

    for iele = 1:nel
        j = nodes(elements(iele,:),2);
        for inod = 1:nnodel
            if j(inod) > 300  && j(inod) < 355
               ele_fisu3_2(iele) = true;
            end
        end
    end

    eleFisura3_ymas = elements(ele_fisu3_2,:);
    
    honney2 = false(size(eleFisura3_ymas,1),1);

    for iele = 1:size(eleFisura3_ymas,1)
        j = nodes(eleFisura3_ymas(iele,:),2);
        i = nodes(eleFisura3_ymas(iele,:),1);
        for inod = 1:nnodel
            if  j(inod)<305 && i(inod)<300 && i(inod)>100
                honney2(iele) = true;
            end
        end
    end
        
    eleFisura3_ymas = eleFisura3_ymas(honney2,:);
    sizefis3_mas = size(eleFisura3_ymas,1);
end

