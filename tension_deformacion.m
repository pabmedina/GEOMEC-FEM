function [S,Def, Ter] = tension_deformacion(nel,unod,elements,nodes,C,nodeDofs,D,ndofel,nnodel,ndof,Time,Presion,Biot,d)

    S = zeros(nel,nnodel,6,length(Time));
    Ter = zeros(nel,nnodel,6,length(Time));
    Def = zeros(nel,nnodel,6,length(Time));
    
    for itime = 1:length(Time)
        for iele = 1:nel
            nodesEle = nodes(elements(iele,:),:);
            for inod = 1:length(nodesEle(:,3))
                knod = nodesEle(inod,3);
                if knod < d.estrato_10
                    caso = 'strat10';
                end
                if knod <= d.estrato_9 && knod >= d.estrato_10
                    caso = 'strat9';
                end
                if knod <= d.estrato_8 && knod >= d.estrato_9
                    caso = 'strat8';
                end
                if knod <= d.estrato_7 && knod >= d.estrato_8
                    caso = 'strat7';
                end
                if knod <= d.estrato_6 && knod >= d.estrato_7
                    caso = 'strat6';
                end
                if knod <= d.estrato_5 && knod >= d.estrato_6
                    caso = 'strat5';
                end
                if knod <= d.estrato_4 && knod >= d.estrato_5
                    caso = 'strat4';
                end
                if knod <= d.estrato_3 && knod >= d.estrato_4
                    caso = 'strat3';
                end
                if knod <= d.estrato_2 && knod >= d.estrato_3
                    caso = 'strat2';
                end
                if knod <= d.estrato_1 && knod >= d.estrato_2
                    caso = 'strat1';
                end
                
            end
            
            switch caso
                case 'strat10'
                    Const = C.estrato_10;
                case 'strat9'
                    Const = C.estrato_9;
                case 'strat8'
                    Const = C.estrato_8;
                case 'strat7'
                    Const = C.estrato_7;
                case 'strat6'
                    Const = C.estrato_6;
                case 'strat5'
                    Const = C.estrato_5;
                case 'strat4'
                    Const = C.estrato_4;
                case 'strat3'
                    Const = C.estrato_3;
                case 'strat2'
                    Const = C.estrato_2;
                case 'strat1'
                    Const = C.estrato_1;

            end

            for npg = 1:size(unod,1)
                % Punto de Gauss
                ksi = unod(npg,1);
                eta = unod(npg,2);
                zeta = unod(npg,3);

                % Funciones de forma
                N = [ (1-ksi)*(1-eta)*(1+zeta)/8, (1-ksi)*(1-eta)*(1-zeta)/8, (1-ksi)*(1+eta)*(1-zeta)/8.... 
                      (1-ksi)*(1+eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1-zeta)/8....
                      (1+ksi)*(1+eta)*(1-zeta)/8, (1+ksi)*(1+eta)*(1+zeta)/8 ];
                   
                N = N(1,[8,4,1,5,7,3,2,6]);   

                % Derivadas de las funciones de forma respecto de ksi, eta, zeta         
                dN = [ ((eta - 1)*(zeta + 1))/8, -((eta - 1)*(zeta - 1))/8, ((eta + 1)*(zeta - 1))/8, -((eta + 1)*(zeta + 1))/8, -((eta - 1)*(zeta + 1))/8, ((eta - 1)*(zeta - 1))/8, -((eta + 1)*(zeta - 1))/8, ((eta + 1)*(zeta + 1))/8
                       ((ksi - 1)*(zeta + 1))/8, -((ksi - 1)*(zeta - 1))/8, ((ksi - 1)*(zeta - 1))/8, -((ksi - 1)*(zeta + 1))/8, -((ksi + 1)*(zeta + 1))/8, ((ksi + 1)*(zeta - 1))/8, -((ksi + 1)*(zeta - 1))/8, ((ksi + 1)*(zeta + 1))/8
                       ((eta - 1)*(ksi - 1))/8,  -((eta - 1)*(ksi - 1))/8,  ((eta + 1)*(ksi - 1))/8,  -((eta + 1)*(ksi - 1))/8,  -((eta - 1)*(ksi + 1))/8,  ((eta - 1)*(ksi + 1))/8,  -((eta + 1)*(ksi + 1))/8,  ((eta + 1)*(ksi + 1))/8 ];

                dN = dN(:,[8,4,1,5,7,3,2,6]);

                jac = dN*nodesEle;  

                % Derivadas de las funciones de forma respecto de x,y,z
                dNxyz = jac\dN;      

                B = zeros(6,ndofel);

                B(1,1:ndof:ndofel) = dNxyz(1,:);
                B(2,2:ndof:ndofel) = dNxyz(2,:); 
                B(3,3:ndof:ndofel) = dNxyz(3,:);
                B(4,1:ndof:ndofel) = dNxyz(2,:);
                B(4,2:ndof:ndofel) = dNxyz(1,:);
                B(5,2:ndof:ndofel) = dNxyz(3,:);
                B(5,3:ndof:ndofel) = dNxyz(2,:);
                B(6,1:ndof:ndofel) = dNxyz(3,:);
                B(6,3:ndof:ndofel) = dNxyz(1,:);

                eleDofs = nodeDofs(elements(iele,:),:);
                eleDofs = reshape(eleDofs',[],1);
                eleDofs2 = elements(iele,:);

                Def(iele,npg,:,itime) = B*D(eleDofs,itime);
                S(iele,npg,:,itime) = Const*B*D(eleDofs,itime) - Biot*N*Presion(eleDofs2,itime);    
                Ter(iele,npg,:,itime) = Const*B*D(eleDofs,itime);

            end
        end

    end



end

