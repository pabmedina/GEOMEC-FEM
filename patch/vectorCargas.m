function Rr = vectorCargas(nodes,eleCargados1,eleCargados2,nnodel,ndof,nodeDofs,nNod,eleType,sig)

    %% Vector de cargas
    % % Ubicaciones puntos de Gauss
    GPr   = 1/sqrt(3);

    upgr1 = [ 1  -GPr
              1   GPr ];

    npgr = size(upgr1,1);
    wpgr = ones(npgr,1);

    R = zeros(nNod,ndof);
    Rr = reshape(R',[],1);
%     sig = -100;

    tau = 0;
    t=1;

    for iele = 1:size(eleCargados1,1)
        re = zeros(ndof*nnodel,1);         % 24 sería la cantidad de componentes en x y z que tendría el vector de cargas en un solo elemento H8
        nodesEle = nodes(eleCargados1(iele,:),:);
%         nodesEle=[ 0 0.5
%                    2 0.5
%                    1 1
%                    0 1];
        for ipg = 1:npgr
            % Punto de Gauss
            ksi = upgr1(ipg,1);
            eta = upgr1(ipg,2);  

            N  = shapefuns([ksi,eta],eleType);
            dN = shapefunsder([ksi,eta],eleType);
            jac = dN*nodesEle;              

            Ne = [N(1) 0  N(2) 0  N(3) 0  N(4) 0
                  0  N(1) 0  N(2) 0  N(3) 0  N(4)];

            fi = [ tau*t*jac(2,1) - sig*t*jac(2,2)
                   sig*t*jac(2,1) - tau*t*jac(2,2)];

            re = re + Ne'*fi*wpgr(ipg);
        end
%         re
        eleDofs = nodeDofs(eleCargados1(iele,:),:);
        eleDofs = reshape(eleDofs',[],1);
        Rr(eleDofs,1) = Rr(eleDofs,1) + re;
    end
    


    upgr2 = [ -1  -GPr
              -1   GPr ];
    npgr2 = size(upgr2,1);
    wpgr2 = ones(npgr2,1);
    
    for iele = 1:size(eleCargados2,1)
        re = zeros(ndof*nnodel,1);         % 24 sería la cantidad de componentes en x y z que tendría el vector de cargas en un solo elemento H8
        nodesEle = nodes(eleCargados2(iele,:),:);
%         nodesEle=[ 2 0.5
%                    4 0.5
%                    4 1
%                    2 1];
        for ipg = 1:npgr2
            % Punto de Gauss
            ksi = upgr2(ipg,1);
            eta = upgr2(ipg,2);  

            N  = shapefuns([ksi,eta],eleType);
            dN = shapefunsder([ksi,eta],eleType);
            jac = dN*nodesEle;                

            Ne = [N(1) 0  N(2) 0  N(3) 0  N(4) 0
                  0  N(1) 0  N(2) 0  N(3) 0  N(4)];

            fi = [ tau*t*jac(2,1) + sig*t*jac(2,2)
                   -sig*t*jac(2,1) - tau*t*jac(2,2)];

            re = re + Ne'*fi*wpgr2(ipg);
        end

        eleDofs = nodeDofs(eleCargados2(iele,:),:);
        eleDofs = reshape(eleDofs',[],1);
        Rr(eleDofs,1) = Rr(eleDofs,1) + re;
    end

end

