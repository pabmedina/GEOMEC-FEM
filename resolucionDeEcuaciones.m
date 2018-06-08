function [P,P_old,Q]=resolucionDeEcuaciones(uno,dos,nod_in,nod_out,nodFisura,versorGravedad,K,P_poroso,P_old,Pin,Pout,ro,g,S,delta_t,PinMax,QMax,t,KTemporal, KAlmacenamiento, b_old,b,Re,beta,mu,elemNew,bCorr,porosidad,selectorLogico,bomba, elementsBarra, QExt)
if bomba==0
    Pin=ones(length(Pin),1)*PinMax;
else
    PinAux=Pin;
end

% P_poroso=P_poroso-(versorGravedad(1)*nodFisura(:,1)+versorGravedad(2)*nodFisura(:,2)+versorGravedad(3)*nodFisura(:,3))*(ro*g);

P_porosoPostProcesado=P_poroso;

P_poroso(elementsBarra(:,1))=(P_poroso(elementsBarra(:,1))+P_poroso(elementsBarra(:,2)))*0.5;%promedia la presion externa a ambos lados de la fisura

P_old=P_old-(versorGravedad(1)*nodFisura(:,1)+versorGravedad(2)*nodFisura(:,2)+versorGravedad(3)*nodFisura(:,3))*(ro*g);% considera la columna hidrostatica en la fisura

num_nod=length(nodFisura(:,1));

Q=sparse(num_nod,1);

temporalQ=KTemporal*P_old; %cuando resolves la parte temporal tenes KTemporal* delta P/delta tiempo, para resolver el sist de ecuaciones delta P es Pnew-Pold entonces la parte de POld lo llevas del otro lado sumando la Q

% conveccionQ=KConv*(P_poroso-P_old);

temporalK=KTemporal;

almacenamiento=KAlmacenamiento*(b_old-b);%Como esto no depende de la presion lo pasas entero del otro lado
   
Q=zeros(num_nod,1);

Q(uno)=+temporalQ(uno)+almacenamiento(uno);

% alfa=0.0001;

for iteradorDeRe=1:3
    
    [K,KTemporal, KAlmacenamiento, KConv]=ensambleKGlobalYKConvGlobal(ro,mu,nodFisura,elemNew,bCorr,porosidad,selectorLogico,num_nod,b,S,delta_t,Re,beta);
    
%     KConv(dos,dos)=zeros(length(dos),length(dos));
    
%     KConv(uno,dos)=zeros(length(uno),length(dos));
    
%     KConv(dos,uno)=zeros(length(dos),length(uno));
    KK = -K-temporalK+KConv;%
    KKK=KK+temporalK;%Le resta el temporal k para poder calcular el caudal de la bomba
    
    diff=1;%para inicializar la iteracion
    iterBomba=0;
        
    P=P_old-(versorGravedad(1)*nodFisura(:,1)+versorGravedad(2)*nodFisura(:,2)+versorGravedad(3)*nodFisura(:,3))*(ro*g);
    count=0;
    alfa=0.001;%coeficientes turbios a manopla para que no diverja
    
    CaudalBomba=inf;
    while diff>alfa*0.001 && count<2000
        count=count+1;
        
        if count==2000
            
%             disp('ERROR: Sin convergencia de bomba, Sugerencia: aumentar caudal maximo de bomba')
            
        end
        
        if count==700
            alfa=alfa*0.01;
        end
        
        if count==1000
            alfa=alfa*0.5;
        end
        
        if count==1300
            alfa=alfa*0.1;
        end
        if count==1700
            alfa=alfa*0.1;
        end
        
%         conveccionQ=KConv*(P_poroso);
        
        Q(uno)=-temporalQ(uno)-almacenamiento(uno)+QExt(uno);
        
%         Q(uno)=-temporalQ(uno)-almacenamiento(uno)+conveccionQ(uno);
        
        iterBomba=iterBomba+1;
        
        P=sparse(num_nod,1);
        
        P(nod_in)=Pin(nod_in);
        
        P(nod_out)=Pout(nod_out);
        
%         P=P+(versorGravedad(1)*nodFisura(:,1)+versorGravedad(2)*nodFisura(:,2)+versorGravedad(3)*nodFisura(:,3))*(ro*g);
% eigs(KK([uno' dos'],[uno' dos']),20,'SM')
% condest(KK([uno' dos'],[uno' dos']))
% KK([uno' dos'],[uno' dos'])
        if isempty(dos)
            P(uno)=KK(uno,uno)\(Q(uno));%-(KK(uno,dos)*(P(dos))));
        else
        
            P(uno)=KK(uno,uno)\(Q(uno)-(KK(uno,dos)*(P(dos))));
        
            Q(dos)=KK(dos,uno)*(P(uno))+KK(dos,dos)*(P(dos))-QExt(dos);%el QExt esta restando para tener en cuenta el caudal que se va por permeabilidad en el nodo
        end
        
        if isempty(dos)
        else
        
%         Q_bomba(dos)=KKK(dos,uno)*(P(uno)-P_poroso(uno))+KKK(dos,dos)*(P(dos)-P_poroso(dos));
        Q_bomba(dos)=KKK(dos,uno)*(P(uno))+KKK(dos,dos)*(P(dos))-QExt(dos);%%para eliminar los caudales a causa de los transitorios, sino ves el efecto del storativity que te jode
        
        aux=Q_bomba(dos)';
        
        PinNew=simuladorBomba(PinMax,-Q_bomba,QMax,dos,num_nod);
        
        PIter(count,:)=PinNew(dos);
        
        
        
%         PinNew=PinNew*(bomba)+ones(length(PinNew),1)*PinMax*(1-bomba);
        
        PinOld=Pin;
        
%         Pin=Pin*PinMax;
        if bomba==1
            if count<100
%         Pin=Pin*0.925+PinNew*(0.075);
        Pin=Pin*0.9+PinNew*(0.1); %Para no enchufar de una la presion nueva calculada de bomba para que "amortigue" y no diverja 
%         if isempty(find(Pin>PinMax))
%         else
%                 disp('AUCH')
%         end
%         Pin(find(Pin>PinMax))=PinMax;
        
                
            else
                
                PProm=sum(sum(PIter))/(count*length(PIter(1,:)));
                Pin=PinNew*alfa+PProm*0.0000+Pin*(1-alfa);
%                 if isempty(find(Pin>PinMax))
%         else
%                 disp('AUCH')
%         end
                Pin(find(Pin>PinMax))=PinMax;
                
            end
       
        end
        
        diff=max(abs(1-max(PinOld)/(max(Pin(nod_in)))));
        diff=abs((1-CaudalBomba)/sum(Q_bomba));
        CaudalBomba=sum(Q_bomba);
        
        if count<5
            diff=10;
        end
        
        if bomba==0
            diff=0;
        end
        
        
        end
        
        
    end
%     
%     disp(['CONVERCENGICA DE BOMBA EN ' num2str(count) ' ITERACIONES'])
    
    conveccionQ=0*(P);
    
    Q(uno)=QExt(uno);
    
    KK=KK+temporalK;
    
    if isempty(dos)
    else
    
    Q(dos)=KK(dos,uno)*(P(uno)-P_poroso(uno))+KK(dos,dos)*(P(dos)-P_poroso(dos));
    Q(dos)=KK(dos,uno)*(P(uno))+KK(dos,dos)*(P(dos));
    end
    P=P+(versorGravedad(1)*nodFisura(:,1)+versorGravedad(2)*nodFisura(:,2)+versorGravedad(3)*nodFisura(:,3))*(ro*g);
    
    [Velocidad,Re]=calculoDeVelocidad(ro, mu,nodFisura,elemNew, bCorr, b, P,selectorLogico, num_nod, versorGravedad,g);
    
    P_old(uno)=P(uno);
    
end

end

