function RNACHO = VC_Nacho( GPr,sizeFisu1_1,nodeDofs,ele_fisu1_y1_1,nodes,ndofel,nnodel,ndof,Pressure,ndofel_1,RNACHO,ndoftot,fcn,sizeFisu1_2,ele_fisu1_y1_2,ndofel_2,sizeFisu2_1,ele_fisu2_y2_1,sizeFisu2_2,ele_fisu2_y2_2,sizeFisu3_1,sizeFisu3_2,ele_fisu3_y3_1,ele_fisu3_y3_2 )
 
    upgr1 = [  GPr   1   GPr
              -GPr   1   GPr
               GPr   1  -GPr
              -GPr   1  -GPr];

    npgr = size(upgr1,1);
    wpgr = ones(npgr,1);

    [Row, Col, nodesEle] = get_mapping_el(sizeFisu1_1,nodeDofs,ele_fisu1_y1_1,nodes,ndofel,nnodel,ndof);

    netPressure1_1 = zeros(sizeFisu1_1,nnodel);
    stirr1 = find(Pressure);

    for iele = 1:sizeFisu1_1

        for inod = 1:nnodel

            for conta = 1:length(stirr1)

                if ele_fisu1_y1_1(iele,inod)==stirr1(conta)
                    netPressure1_1(iele,inod) = Pressure(stirr1(conta));

                end           
            end   
        end
    end
    netPressure1_1(:,[3 4 7 8]) = [];

    for iele = 1:sizeFisu1_1
        if length(find(netPressure1_1(iele,:)))==4
        re_f1 = cargas_por_elemento(npgr,upgr1,wpgr,nodesEle(:,:,iele),ndof,nnodel,netPressure1_1(iele,:),ndofel_1);
        RNACHO = fcn(RNACHO,sparse(Col(:,1,iele),Row(:,1,iele)',re_f1,ndoftot,1));
        end
    end
    
    upgr2 = [  GPr  -1   GPr
              -GPr  -1   GPr
               GPr  -1  -GPr
              -GPr  -1  -GPr];

    npgr = size(upgr2,1);
    wpgr = ones(npgr,1);

    [Row, Col, nodesEle] = get_mapping_el(sizeFisu1_2,nodeDofs,ele_fisu1_y1_2,nodes,ndofel,nnodel,ndof);

    netPressure1_2 = zeros(sizeFisu1_2,nnodel);


    for iele = 1:sizeFisu1_2
        for inod = 1:nnodel
            for conta = 1:length(stirr1)
                if ele_fisu1_y1_2(iele,inod)==stirr1(conta)
                    netPressure1_2(iele,inod) = Pressure(stirr1(conta));
                end           
            end   
        end
    end

    netPressure1_2(:,[1 2 5 6]) = [];

    for iele = 1:sizeFisu1_2
        if length(find(netPressure1_2(iele,:)))==4
        re_f2 = cargas_por_elemento(npgr,upgr2,wpgr,nodesEle(:,:,iele),ndof,nnodel,-1*netPressure1_2(iele,:),ndofel_2);
        RNACHO(:) = fcn(RNACHO(:) ,sparse(Col(:,1,iele),Row(:,1,iele)',re_f2,ndoftot,1));
        end
    end

    % Vector de cargas en la fisura 2 en la cara negativa (y-)
    [Row, Col, nodesEle] = get_mapping_el(sizeFisu2_1,nodeDofs,ele_fisu2_y2_1,nodes,ndofel,nnodel,ndof);

    netPressure2_1 = zeros(sizeFisu2_1,nnodel);

    for iele = 1:sizeFisu2_1
        for inod = 1:nnodel
            for conta = 1:length(stirr1)
                if ele_fisu2_y2_1(iele,inod)==stirr1(conta)
                    netPressure2_1(iele,inod) = Pressure(stirr1(conta));
                end           
            end   
        end
    end

    netPressure2_1(:,[3 4 7 8]) = [];

    for iele = 1:sizeFisu2_1
        if length(find(netPressure2_1(iele,:)))==4
        re_f3 = cargas_por_elemento(npgr,upgr1,wpgr,nodesEle(:,:,iele),ndof,nnodel,netPressure2_1(iele,:),ndofel_1);
        RNACHO(:)  = fcn(RNACHO(:) ,sparse(Col(:,1,iele),Row(:,1,iele)',re_f3,ndoftot,1));
        end
    end

    % Vector de cargas en la fisura 2 en la cara positiva (y+)
    [Row, Col, nodesEle] = get_mapping_el(sizeFisu2_2,nodeDofs,ele_fisu2_y2_2,nodes,ndofel,nnodel,ndof);

    netPressure2_2 = zeros(sizeFisu2_2,nnodel);

    for iele = 1:sizeFisu2_2

        for inod = 1:nnodel

            for conta = 1:length(stirr1)

                if ele_fisu2_y2_2(iele,inod)==stirr1(conta)
                    netPressure2_2(iele,inod) = Pressure(stirr1(conta));

                end           
            end   
        end
    end

    netPressure2_2(:,[1 2 5 6]) = [];

    for iele = 1:sizeFisu2_2
        if length(find(netPressure2_2(iele,:)))==4
        re_f4 = cargas_por_elemento(npgr,upgr2,wpgr,nodesEle(:,:,iele),ndof,nnodel,-1*netPressure2_2(iele,:),ndofel_1);
        RNACHO(:)  = fcn(RNACHO(:) ,sparse(Col(:,1,iele),Row(:,1,iele)',re_f4,ndoftot,1));
        end
    end

    % Vector de cargas en la fisura 3 en la cara negativa (y-)

    [Row, Col, nodesEle] = get_mapping_el(sizeFisu3_1,nodeDofs,ele_fisu3_y3_1,nodes,ndofel,nnodel,ndof);

    netPressure3_1 = zeros(sizeFisu3_1,nnodel);

    for iele = 1:sizeFisu3_1

        for inod = 1:nnodel

            for conta = 1:length(stirr1)

                if ele_fisu3_y3_1(iele,inod)==stirr1(conta)
                    netPressure3_1(iele,inod) = Pressure(stirr1(conta));

                end           
            end   
        end
    end

    netPressure3_1(:,[3 4 7 8]) = [];

    for iele = 1:sizeFisu3_1
        if length(find(netPressure3_1(iele,:)))==4
        re_f5 = cargas_por_elemento(npgr,upgr1,wpgr,nodesEle(:,:,iele),ndof,nnodel,netPressure3_1(iele,:),ndofel_1);
        RNACHO(:)  = fcn(RNACHO(:) ,sparse(Col(:,1,iele),Row(:,1,iele)',re_f5,ndoftot,1));
        end
    end

    % Vector de cargas en la fisura 3 en la cara negativa (y+)

    [Row, Col, nodesEle] = get_mapping_el(sizeFisu3_2,nodeDofs,ele_fisu3_y3_2,nodes,ndofel,nnodel,ndof);

    netPressure3_2 = zeros(sizeFisu3_2,nnodel);

    for iele = 1:sizeFisu3_2

        for inod = 1:nnodel

            for conta = 1:length(stirr1)

                if ele_fisu3_y3_2(iele,inod)==stirr1(conta)
                    netPressure3_2(iele,inod) = Pressure(stirr1(conta));

                end           
            end   
        end
    end

    netPressure3_2(:,[1 2 5 6]) = [];

    for iele = 1:sizeFisu3_2
        if length(find(netPressure3_2(iele,:)))==4
        re_f6 = cargas_por_elemento(npgr,upgr2,wpgr,nodesEle(:,:,iele),ndof,nnodel,-1*netPressure3_2(iele,:),ndofel_1);
        RNACHO(:)  = fcn(RNACHO(:) ,sparse(Col(:,1,iele),Row(:,1,iele)',re_f6,ndoftot,1)); 
        end
    end


end

