clc 
clearvars

nodesload = load('nodes_M333P.txt');
nodes = nodesload(:,[2,3,4]);

elementsload = load('elements_M333P.txt');
elements = elementsload(:,2:9);
 
nNod = size(nodes,1);    % numero de nodos sin considerar los resortes
nel = size(elements,1);

ndof = 3;
nDofTot = nNod*ndof;     % Sin considerar los dof de los resortes que se tienen que adicionar para armar el "flan"
nnodel = 8;
ifis = 3;
ndofel = 24;

%%%% -------------

ycoord_fisu1 = 100;
ycoord_fisu2 = 200;
ycoord_fisu3 = 300;

%% Dividir por estratos

% Input de la profundidad de los 10 estratos

d_estrato_10 = 15;                
d_estrato_9 = 24.98;
d_estrato_8 = 30.78;
d_estrato_7 = 34.89;
d_estrato_6 = 44.64;
d_estrato_5 = 54.55;
d_estrato_4 = 56.78;
d_estrato_3 = 61.56;
d_estrato_2 = 64.15;
d_estrato_1 = 80;

% Estos valores se sacan de ADINA

estrato10.div = 1;
estrato9.div = 5;
estrato8.div = 3;
estrato7.div = 2;
estrato6.div = 5;
estrato5.div = 5;
estrato4.div = 1;
estrato3.div = 1;
estrato2.div = 1;
estrato1.div = 1;

estrato10.size = (d_estrato_10)/estrato10.div;
estrato9.size = (d_estrato_9 - d_estrato_10)/estrato9.div;
estrato8.size = (d_estrato_8 - d_estrato_9)/estrato8.div;
estrato7.size = (d_estrato_7 - d_estrato_8)/estrato7.div;
estrato6.size = (d_estrato_6 - d_estrato_7)/estrato6.div;
estrato5.size = (d_estrato_5 - d_estrato_6)/estrato5.div;
estrato4.size = (d_estrato_4 - d_estrato_5)/estrato4.div;
estrato3.size = (d_estrato_3 - d_estrato_4)/estrato3.div;
estrato2.size = (d_estrato_2 - d_estrato_3)/estrato2.div;
estrato1.size = (d_estrato_1 - d_estrato_2)/estrato1.div;


%% Nuevas areas de fractura

ele_fisu1_1 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    k = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if j(inod) == 99.9750 %&& k(inod) == d_estrato_7
            if k(inod) == d_estrato_7
                ele_fisu1_1(iele) = true;
            end
        end
    end
end

ele_fisu1_y1_1 = elements(ele_fisu1_1,:);
sizeFisu1_1 = size(ele_fisu1_y1_1,1);

ele_fisu1_2 = false(nel,1);

for iele = 1:nel
    j = nodes(elements(iele,:),2);
    k = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if j(inod) == 100.0250
            if k(inod) == d_estrato_7
                ele_fisu1_2(iele) = true;
            end          
        end
    end
end

ele_fisu1_y1_2 = elements(ele_fisu1_2,:);
sizeFisu1_2 = size(ele_fisu1_y1_2,1);

fisura1.auxiliar1 = reshape(ele_fisu1_y1_1,1,[])';
fisura1.nodoPosicion1 = fisura1.auxiliar1(nodes(fisura1.auxiliar1,2)>99.95);
nodos1_fisu1 = unique(fisura1.nodoPosicion1);             %% Me daría los nodos 1 de todas las barras que van en la fisura 1 del lado negativo (y-)

fisura1.auxiliar2 = reshape(ele_fisu1_y1_2,1,[])';        
fisura1.nodoPosicion2 = fisura1.auxiliar2(nodes(fisura1.auxiliar2,2)<100.05);
nodos2_fisu1 = unique(fisura1.nodoPosicion2);  

n=0;
estrato6.contador = 0;
estrato5.contador = 0;
estrato7.contador = 0;
estrato8.contador = 0;
estrato9.contador = 0;


accion = '0';




for contador = 1:10
    
%     disp(nodes(nodos1_fisu1,:))
    size(nodos1_fisu1)
    
    
    if 2>1
        
        [estrato5, estrato6, estrato7, estrato8, estrato9, accion] = count(accion,estrato5,estrato6,estrato7,estrato8,estrato9,d_estrato_10,d_estrato_9,d_estrato_8,d_estrato_7,d_estrato_6,d_estrato_5);


        n = n+1;
        tol_malla =  abs(nodes(ele_fisu1_y1_1(2,1),1) - nodes(ele_fisu1_y1_1(1,1),1));
        if tol_malla<= 0.1
            disp('Cuidado, la malla es muy chica')
        end
        
        tol_malla = tol_malla + 0.1;
        clear ele_fisu1_1 ele_fisu1_y1_1 sizeFisu1_1 ele_fisu1_2 ele_fisu1_y1_2 sizeFisu1_2

        ele_fisu1_1 = false(nel,1);

        for iele = 1:nel
            i = nodes(elements(iele,:),1);
            j = nodes(elements(iele,:),2);
            z = nodes(elements(iele,:),3);
            for inod = 1:nnodel
                if i(inod) >= 200 - n*tol_malla && i(inod) <= 200 + n*tol_malla && j(inod) < 100  && j(inod) > 99.95
                    if z(inod) < d_estrato_7 + estrato6.size*estrato6.contador  + estrato5.size*estrato5.contador + 0.01
                        if z(inod) > d_estrato_7 - estrato7.size*(estrato7.contador) - estrato8.size*estrato8.contador - estrato9.size*estrato9.contador - 0.01
                            ele_fisu1_1(iele) = true;                            
                        end
                    end
                end
            end
        end
        
        aaa = d_estrato_7 + estrato6.size*(estrato6.contador) + estrato5.size*estrato5.contador + 0.01;
        bbb = d_estrato_7 - estrato7.size*(estrato7.contador) - estrato8.size*estrato8.contador - estrato9.size*estrato9.contador - 0.01;
        
%         disp(aaa)
%         disp(bbb)
%         
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


        ele_fisu1_2 = false(nel,1);

        for iele = 1:nel
            i = nodes(elements(iele,:),1);
            j = nodes(elements(iele,:),2);
            for inod = 1:nnodel
                if i(inod) >= 200 - n*tol_malla && i(inod) <= 200 + n*tol_malla && j(inod) > 100  && j(inod) < 100.1
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

    end
end
