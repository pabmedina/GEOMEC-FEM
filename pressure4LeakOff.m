function [Qfisuras,Desplazamientos,PorePressure,nodePosition,error,iter]=pressure4LeakOff(vars4solve)

    campos = fieldnames(vars4solve);

    % Unzip de vars4solve
    for icampo = 1 : length(campos)
        eval( sprintf('%s = vars4solve.%s;',campos{icampo},campos{icampo}) )
    end
    
    Pressure(elements_Barra(:,1),itime) = 10*pBC(:,1); 
    Pressure(elements_Barra(:,2),itime) = 10*pBC(:,2);
    
    GPr   = 1/sqrt(3);
    RNACHO(:,itime) = VC_Nacho(GPr,sizeFisu1_1,nodeDofs,ele_fisu1_y1_1,nodes,ndofel,nnodel,ndof,Pressure(:,itime),ndofel_1,RNACHO(:,itime),ndoftot,fcn,sizeFisu1_2,ele_fisu1_y1_2,ndofel_2,sizeFisu2_1,ele_fisu2_y2_1,sizeFisu2_2,ele_fisu2_y2_2,sizeFisu3_1,sizeFisu3_2,ele_fisu3_y3_1,ele_fisu3_y3_2);

    R = RTOT(:,itime) + RNACHO(:,itime);
    Rr = reshape(R',[],1);
    
    
    error=1;
    factor=200;
    iter =1;
    
    while error>5e-3
            Jacobo = sparse(ndoftot,ndoftot);
            Kbarra = sparse(ndoftot,ndoftot);
            [row, col] = get_mapping_barra(nelSpringFisura,nodeDofs,elements_Barra,ndofel_b);

            if iteracionError<2

                for iele = 1:nelSpringFisura
                    [ke_Barra, kBarra_Mod]  =  k_barra(iele,nodes,elements_Barra,E_variable(iele),A_Barra(iele));
                    k_barras(:,:,iele)      =  kBarra_Mod;                      %#ok<AGROW>
                    [ROW, COL]              =  get_map(row(:,:,iele),col(:,:,iele));
                    dof_barras(:,iele)      =  COL(:,1);                        %#ok<AGROW>
                    Kbarra                  =  fcn(Kbarra,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
                end 
                Knew = K + Kbarra;

                K_GLOBAL = [   Knew          -C_g
                               C_g'      (S + (tita*deltaT)*KC)  ];

                if itime == 1
                    D_P(1:nnod*ndof,itime)   = zeros(nnod*ndof,1);%#ok<AGROW>
                    D_P(ndoftot+1:end,itime) = PresionPoralInicial;  %#ok<AGROW>
                else
                    D_P(1:ndoftot,itime)     = Desplazamientos(:,itime-1);%#ok<AGROW>
                    D_P(ndoftot+1:end,itime) = PorePressure(:,itime-1);%#ok<AGROW>
                end

            %     Def_Inicial = K*D_P(1:ndoftot,itime);

                D_P(isFixedp,itime) = PresionPoralInicial;%#ok<AGROW>

                Rq = C_g'*D_P(1:nnod*ndof,itime) + (S - (1-tita)*deltaT*KC)*D_P((nnod*ndof+1):end,itime) + deltaT*Q;

                VC = [ Rr
                       Rq ];

                Campos = K_GLOBAL(free_g,free_g)\(VC(free_g) - K_GLOBAL(free_g,isFixed)*(D_P(isFixed,itime))); 
                RQincog = K_GLOBAL(isFixed,free_g)*Campos + K_GLOBAL(isFixed,isFixed)*D_P(isFixed,itime);

                %%%% Reconstrucción del vector de cargas, lo llamo RQ
                RQ = zeros(ndoftot+nNod,1);    
                RQ(free_g) = RQ(free_g) + VC(free_g);
                RQ(isFixed) = RQ(isFixed) + RQincog;

                %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
                CamposDP = zeros(ndoftot+nNod,1); 
                CamposDP(free_g) = CamposDP(free_g) + Campos;
                CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

                %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
            %     CamposDP(ndoftot+1:end)
                D_P(:,itime+1) = CamposDP; %#ok<AGROW>
                RQ_hist(:,itime) = RQ;     %#ok<AGROW>          

                %%%% Historia de los desplazamientos y la presión
                Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);%#ok<AGROW>
                PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);%#ok<AGROW>

                %%%% Historia del vector de cargas y los caudales
                Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);%#ok<AGROW>
                Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);%#ok<AGROW>



                % %% Configuracion deformada
                D_1 = (reshape(Desplazamientos(:,itime),ndof,[]))';   %% en end deberia ser itime, que es time step que estoy analizando
                nodePosition(:,:,itime) = nodes_tot + D_1*factor;%#ok<AGROW>


                gap_fisu  = zeros(nelSpringFisura,1);

            end


            for ispring = 1:length(gap_fisu)
                gap_fisu(ispring) = norm(D_1(elements_Barra(ispring,1),2) - D_1(elements_Barra(ispring,2),2));
            end



            Kbarra = sparse(ndoftot,ndoftot);

            %% Solver con resortes

            for ispring = 1:length(gap_fisu)

                if gap_fisu(ispring)>=gapViejo(ispring,itime)
                    count2(ispring)=0;%#ok<AGROW>
                    E_BB(ispring,itime+1)=E_BB(ispring,itime);%#ok<AGROW>
                end

                if gap_fisu(ispring)<desp_1Variable(ispring) && gap_fisu(ispring)>=0
                    E_variable(ispring) = E_BB(ispring,itime);%#ok<AGROW>
                end

                if gap_fisu(ispring)>=desp_1Variable(ispring) && gap_fisu(ispring)>=gapViejo(ispring,itime)
                    if gap_fisu(ispring)<=despRot
                        E_variable(ispring) = (((gap_fisu(ispring)-desp_1Variable(ispring))*(-desp_1Variable(ispring)*E_BB(ispring,itime)))/(despRot-desp_1Variable(ispring))+desp_1Variable(ispring)*E_BB(ispring,itime))/gap_fisu(ispring);%#ok<AGROW>
                        Ediff_d1 = (E_BB(ispring,itime)*desp_1Variable(ispring) - (E_BB(ispring,itime)*desp_1Variable(ispring)*(-gap_fisu(ispring) + desp_1Variable(ispring)))/(desp_1Variable(ispring) - despRot))/gap_fisu(ispring)^2 + (E_BB(ispring,itime)*desp_1Variable(ispring))/((-gap_fisu(ispring))*(desp_1Variable(ispring) - despRot));
                        Ediff_d2 = -(E_BB(ispring,itime)*desp_1Variable(ispring) - (E_BB(ispring,itime)*desp_1Variable(ispring)*(-gap_fisu(ispring) + desp_1Variable(ispring)))/(desp_1Variable(ispring) - despRot))/(-gap_fisu(ispring))^2 - (E_BB(ispring,itime)*desp_1Variable(ispring))/((-gap_fisu(ispring))*(desp_1Variable(ispring) - despRot));   
                    else
                        E_variable(ispring)=0;%#ok<AGROW>
                        E_BB(ispring,itime+1)=E_variable(ispring);%#ok<AGROW>
                    end
                end

                if gapViejo(ispring,itime)>=0 && gap_fisu(ispring)<=gapViejo(ispring,itime)

                    if count2(ispring)==0
                        E_BB(ispring,itime+1)=E_variable(ispring);%#ok<AGROW>
                        E_BB(ispring,itime)=E_variable(ispring);%#ok<AGROW>
                        if desp_1Variable(ispring)<gap_fisu(ispring);
                            desp_1Variable(ispring)=gap_fisu(ispring);%#ok<AGROW>
                        end
                        count2(ispring)=1;%#ok<AGROW>
                    else
                        E_BB(ispring,itime+1)=E_BB(ispring,itime);%#ok<AGROW>
                    end
                    E_variable(ispring)=E_BB(ispring,itime);%#ok<AGROW>
                end

                if gap_fisu(ispring)<0
                    E_variable(ispring) = E_B*10; %#ok<AGROW>
                    E_BB(ispring,itime+1)=E_BB(ispring,itime);%#ok<AGROW>
                end

                if gap_fisu(ispring)>desp_1Variable(ispring) && gap_fisu(ispring)>=gapViejo(ispring,itime) && gap_fisu(ispring)<=despRot

                    dir = nodes(elements_Barra(ispring,2),1:2) - nodes(elements_Barra(ispring,1),1:2);
                    le = norm(dir);

                    jac11 = (Ediff_d1*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,1),2) - (Ediff_d1*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,2),2) + E_variable(ispring)*A_Barra(ispring)/le;
                    jac12 = (Ediff_d2*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,1),2) - ((Ediff_d2*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,2),2) + E_variable(ispring)*A_Barra(ispring)/le);
                    jac21 = -((Ediff_d1*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,1),2) + E_variable(ispring)*A_Barra(ispring)/le) + (Ediff_d1*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,2),2);
                    jac22 = -(Ediff_d2*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,1),2) + (Ediff_d2*A_Barra(ispring)/le)*D_1(elements_Barra(ispring,2),2) + E_variable(ispring)*A_Barra(ispring)/le;

                    jaca = [jac11 jac12
                            jac21 jac22];

                    dir = dir / le;

                    T = [ dir 0 0
                          0 0 dir ];

                    jaca = T' * jaca * T; 

                    [ROW, COL]     =  get_map(row(:,:,ispring),col(:,:,ispring));   
                    Jacobo         =  fcn(Jacobo,sparse(ROW,COL,jaca,ndoftot,ndoftot));                  
                end   

                 ke_Barra              =  k_barra(ispring,nodes,elements_Barra,E_variable(ispring),A_Barra(ispring));
                 k_barras(:,:,ispring) =  ke_Barra;
                 [ROW, COL]            =  get_map(row(:,:,ispring),col(:,:,ispring));
                 dof_barras(:,ispring) =  COL(:,1);
                 Kbarra                =  fcn(Kbarra,sparse(ROW,COL,ke_Barra,ndoftot,ndoftot));
            end

            Jacobiano = Jacobo + K;
            Knew = K + Kbarra;

            K_GLOBAL = [  Knew          -C_g
                          C_g'      (S + (tita*deltaT)*KC) ];

            JacobianoGlobal = [ Jacobiano         -C_g
                                C_g'        (S + (tita*deltaT)*KC) ];

            D_P(isFixedp,itime) = PresionPoralInicial;%#ok<AGROW>

            Rq = C_g'*D_P(1:nnod*ndof,itime) + (S - (1-tita)*deltaT*KC)*D_P((nnod*ndof+1):end,itime) + deltaT*Q;

            VC = [ Rr
                   Rq ];

            Campos=Campos-1*(JacobianoGlobal(free_g,free_g)\(K_GLOBAL(free_g,free_g)*Campos-(VC(free_g) - K_GLOBAL(free_g,isFixed)*(D_P(isFixed,itime)))));   % Newton Raphson

            RQincog = K_GLOBAL(isFixed,free_g)*Campos + K_GLOBAL(isFixed,isFixed)*D_P(isFixed,itime);

            error=norm((K_GLOBAL(free_g,free_g)*Campos-(VC(free_g) - K_GLOBAL(free_g,isFixed)*(D_P(isFixed,itime)))));

            %%%% Reconstrucción del vector de cargas, lo llamo RQ
            RQ = zeros(ndoftot+nNod,1);    
            RQ(free_g) = RQ(free_g) + VC(free_g);
            RQ(isFixed) = RQ(isFixed) + RQincog;

            %%%% Reconstrucción de los campos de desplazamiento y presión, los llamo CamposDP
            CamposDP = zeros(ndoftot+nNod,1); 
            CamposDP(free_g) = CamposDP(free_g) + Campos;
            CamposDP(isFixed) = CamposDP(isFixed) + D_P(isFixed,itime);

            %%%% Guardo la historia de los campos de presión y desplazamiento  y también la historia del vector de cargas y del caudal
            D_P(:,itime+1) = CamposDP;%#ok<AGROW>
            RQ_hist(:,itime) = RQ;               %#ok<AGROW>

            %%%% Historia de los desplazamientos y la presión
            Desplazamientos(:,itime) = D_P(1:ndoftot,itime+1);%#ok<AGROW>
            PorePressure(:,itime) = D_P(ndoftot+1:end,itime+1);%#ok<AGROW>

            %%%% Historia del vector de cargas y los caudales
            Reaccion(:,itime) = RQ_hist(1:ndoftot,itime);%#ok<AGROW>
            Qq(:,itime) = RQ_hist(ndoftot+1:end,itime);%#ok<AGROW>
            iteracionError=iteracionError+1;

            Qneto= -(Qq(:,itime)-Rq)/deltaT;
            Qneto=abs(Qneto);
            Qfisuras = Qneto([elements_Barra_fisu1(:,1) elements_Barra_fisu1(:,2); elements_Barra_fisu2(:,1) elements_Barra_fisu2(:,2); elements_Barra_fisu3(:,1) elements_Barra_fisu3(:,2)]);
            
            iter=iter+1;
    end


end

