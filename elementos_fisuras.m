function [ele_fisu1_y1_1, ele_fisu1_y1_2, ele_fisu2_y2_1, ele_fisu2_y2_2, ele_fisu3_y3_1,ele_fisu3_y3_2] = elementos_fisuras(nel,elements,nodes,nnodel)
% Nos devuelve los elementos que estan en la coordenada y = 100-

ele_fisu1_1 = false(nel,1);


for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) < 100  && j(inod) > 99.9
           ele_fisu1_1(iele) = true;
        end
    end
end

ele_fisu1_y1_1 = elements(ele_fisu1_1,:);

% Nos devuelve los elementos que estan en la coordenada y = 100+

ele_fisu1_2 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) > 100  && j(inod) < 100.1
           ele_fisu1_2(iele) = true;
        end
    end
end

ele_fisu1_y1_2 = elements(ele_fisu1_2,:);
% Nos devuelve los elementos que estan en la coordenada y = 200-

ele_fisu2_1 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) < 200  && j(inod) > 199.9
           ele_fisu2_1(iele) = true;
        end
    end
end

ele_fisu2_y2_1 = elements(ele_fisu2_1,:);
% Nos devuelve los elementos que estan en la coordenada y = 200+
ele_fisu2_2 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) > 200  && j(inod) < 200.1
           ele_fisu2_2(iele) = true;
        end
    end
end

ele_fisu2_y2_2 = elements(ele_fisu2_2,:);
% Nos devuelve los elementos que estan en la coordenada y = 300-

ele_fisu3_1 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) < 300  && j(inod) > 299.9
           ele_fisu3_1(iele) = true;
        end
    end
end

ele_fisu3_y3_1 = elements(ele_fisu3_1,:);
% Nos devuelve los elementos que estan en la coordenada y = 300+

ele_fisu3_2 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    for inod = 1:nnodel
        if j(inod) > 300  && j(inod) < 300.1
           ele_fisu3_2(iele) = true;
        end
    end
end

ele_fisu3_y3_2 = elements(ele_fisu3_2,:);
end

