function [tipo1_f1, tipo3_f1, tipo2_f1, tipo4_f1,tipo1_f2,tipo3_f2,tipo2_f2,tipo4_f2,tipo1_f3,tipo3_f3,tipo2_f3,tipo4_f3 ] = forNacho2(nel,nnodel,nodes,elements)  
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

    
    ipa1 = false(size(eleFisura1_ymenos,1),1);

    for iele = 1:size(eleFisura1_ymenos,1)
        j = nodes(eleFisura1_ymenos(iele,:),2);
        i = nodes(eleFisura1_ymenos(iele,:),1);
        
        for inod = 1:nnodel
            if  j(inod)>95 && i(inod)<300 && i(inod)>100
                ipa1(iele) = true;
            end
        end
    end
        
    tipo1_f1 = eleFisura1_ymenos(ipa1,:);
%     size_tipo1_menosf1 = size(tipo1_menosf1,1);
    coordy_menos = 95;

    
    tipo3_f1 = auxiliarDeElementos(eleFisura1_ymenos,nodes,nnodel,coordy_menos);
    
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
    
    ipa2 = false(size(eleFisura1_ymas,1),1);

    for iele = 1:size(eleFisura1_ymas,1)
        j = nodes(eleFisura1_ymas(iele,:),2);
        i = nodes(eleFisura1_ymas(iele,:),1);
        for inod = 1:nnodel
            if  j(inod)<105 && i(inod)<300 && i(inod)>100
                ipa2(iele) = true;
            end
        end
    end
        
    tipo2_f1 = eleFisura1_ymas(ipa2,:);
%     size_tipo1_masf1 = size(tipo1_masf1,1);
    coordy_mas = 105;
    tipo4_f1 = auxiliarDeElementos2(eleFisura1_ymas,nodes,nnodel,coordy_mas);

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
        
    tipo1_f2 = eleFisura2_ymenos(stout,:);
    
    coordy_menos = 199;
    
    tipo3_f2 = auxiliarDeElementos(eleFisura2_ymenos,nodes,nnodel,coordy_menos);
    
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
        
    tipo2_f2 = eleFisura2_ymas(stout2,:);
%     sizefis2_mas = size(eleFisura2_ymas,1);
    coordy_mas = 205;
    tipo4_f2 = auxiliarDeElementos2(eleFisura2_ymas,nodes,nnodel,coordy_mas);

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
        
    tipo1_f3 = eleFisura3_ymenos(honney,:);
%     sizefis3_menos = size(eleFisura3_ymenos,1);
    coordy_menos = 298;
    tipo3_f3 = auxiliarDeElementos(eleFisura3_ymenos,nodes,nnodel,coordy_menos);
    
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
        
    tipo2_f3 = eleFisura3_ymas(honney2,:);
%     sizefis3_mas = size(eleFisura3_ymas,1);
    coordy_mas = 305;
    tipo4_f3 = auxiliarDeElementos2(eleFisura3_ymas,nodes,nnodel,coordy_mas);



end

