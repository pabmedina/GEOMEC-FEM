function [ele_strat10,ele_strat9,ele_strat8,ele_strat7,ele_strat6,ele_strat5,ele_strat4,ele_strat3,ele_strat2,ele_strat1] = elementsEstratos(nel,nodes,elements,nnodel,d_estrato_10,d_estrato_9,d_estrato_8,d_estrato_7,d_estrato_6,d_estrato_5,d_estrato_4,d_estrato_3,d_estrato_2,d_estrato_1,setting)
tol = 0.01;
% Elementos del Estrato 10

ele_estrato10 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        if i(inod) < d_estrato_10
           ele_estrato10(iele) = true;
        end
    end
end
    
ele_strat10 = elements(ele_estrato10,:);
    
% Elementos del Estrato 9

ele_estrato9 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        switch setting
            case '1'
                if i(inod) < d_estrato_9 && i(inod) > d_estrato_10
                    ele_estrato9(iele) = true;
                end
            case '2'
                if i(inod) < d_estrato_10 + tol && i(inod) > d_estrato_10 - tol
                   ele_estrato9(iele) = true;     
                elseif i(inod) < d_estrato_9
                   ele_estrato9(iele) = false;
                end
        end

    end
end
  
ele_strat9 = elements(ele_estrato9,:);    

% Elementos del Estrato 8

ele_estrato8 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        switch setting
            case '1'
                if i(inod)< d_estrato_8 && i(inod)>d_estrato_9
                    ele_estrato8(iele) = true;
                end
            case '2'
                if i(inod) < d_estrato_9 + tol && i(inod) > d_estrato_9 - tol
                   ele_estrato8(iele) = true;     
                elseif i(inod) < d_estrato_8
                   ele_estrato8(iele) = false;
                end
        end

    end
end
   
ele_strat8 = elements(ele_estrato8,:);

% Elementos del Estrato 7

ele_estrato7 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        switch setting
            case '1'
                if i(inod) < d_estrato_7 && i(inod)>d_estrato_8
                    ele_estrato7(iele) = true;
                end
            case '2'
         
                if i(inod) < d_estrato_8 + tol && i(inod) > d_estrato_8 - tol
                   ele_estrato7(iele) = true;     
                elseif i(inod) < d_estrato_7
                   ele_estrato7(iele) = false;
                end
        end
    end
end
   
ele_strat7 = elements(ele_estrato7,:);
                
% Elementos del Estrato 6

ele_estrato6 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        switch setting
            case '1'
                if i(inod)<d_estrato_6 && i(inod)> d_estrato_7
                    ele_estrato6(iele) = true;
                end
            case '2'
                
                if i(inod) < d_estrato_7 + tol && i(inod) > d_estrato_7 - tol
                   ele_estrato6(iele) = true;     
                elseif i(inod) < d_estrato_6
                   ele_estrato6(iele) = false;
                end
        end

    end
end
   
ele_strat6 = elements(ele_estrato6,:);

% Elementos del Estrato 5

ele_estrato5 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
        switch setting
            case '1'
                if i(inod)<d_estrato_5 && i(inod)> d_estrato_6
                    ele_estrato5(iele) = true;
                end
            case '2'
                if i(inod) < d_estrato_6 + tol && i(inod) > d_estrato_6 - tol
                   ele_estrato5(iele) = true;     
                elseif i(inod) < d_estrato_5
                   ele_estrato5(iele) = false;
                end
        end

    end
end
   
ele_strat5 = elements(ele_estrato5,:);   


% Elementos del Estrato 4

ele_estrato4 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel 

%         if i(inod)<d_estrato_4 && i(inod)> d_estrato_5
%             ele_estrato4(iele) = true;
%         end

        if i(inod) < d_estrato_5 + tol && i(inod) > d_estrato_5 - tol
           ele_estrato4(iele) = true;     
        elseif i(inod) < d_estrato_4
           ele_estrato4(iele) = false;
        end
 

    end
end
   
ele_strat4 = elements(ele_estrato4,:);

% Elementos del Estrato 3

ele_estrato3 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
%         if i(inod)<d_estrato_3 && i(inod)> d_estrato_4
%             ele_estrato3(iele) = true;
%         end
        if i(inod) < d_estrato_4 + tol && i(inod) > d_estrato_4 - tol
           ele_estrato3(iele) = true;     
        elseif i(inod) < d_estrato_3
           ele_estrato3(iele) = false;
        end

    end
end
   
ele_strat3 = elements(ele_estrato3,:);

% Elementos del Estrato 2

ele_estrato2 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel  
%         if i(inod)<d_estrato_2 && i(inod)> d_estrato_3
%             ele_estrato2(iele) = true;
%         end
        if i(inod) < d_estrato_3 + tol && i(inod) > d_estrato_3 - tol
           ele_estrato2(iele) = true;     
        elseif i(inod) < d_estrato_2
           ele_estrato2(iele) = false;
        end

    end
end
   
ele_strat2 = elements(ele_estrato2,:);


% Elementos del Estrato 1

ele_estrato1 = false(nel,1);

for iele = 1:nel
    i = nodes(elements(iele,:),3);
    for inod = 1:nnodel
%         if i(inod)<d_estrato_1 && i(inod)> d_estrato_2
%             ele_estrato1(iele) = true;
%         end
        if i(inod) < d_estrato_2 + tol && i(inod) > d_estrato_2 - tol
           ele_estrato1(iele) = true;     
        elseif i(inod) < d_estrato_1
           ele_estrato1(iele) = false;
        end

    end
end
   
ele_strat1 = elements(ele_estrato1,:);


end

