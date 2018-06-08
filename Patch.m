clc
clear all
close all

condicion_de_borde=1;



g=9.81;%m/(s^2)
ro=10^3;%kg/(m^3)
mu=1/12;%Pa*s
transitorio=1;
tInicial=0;
alfaTime=10^5;
% t_final=(10^7)/alfaTime;
t_final=10^6;
delta_t=1*alfaTime;
Pin=1;
bomba=1;
QMax=3*(10^4)/3;
P_old=0;
Pout=P_old;
porosidad=0
S=1*transitorio;
b=0.001;
beta=0
versorGravedad(:,1)=[0 0 -0];
graficar=1;
PPorosa=0*(10^7);

QHistoricoViejo=0;

nod=[0 0 0
     0.3333 0 0
     0.6666 0 0
     1 0 0
     0 0.5 0
     0.3333 0.5 0
     0.6666 0.5 0
     1 0.5 0
     0 1 0
     0.3333 1 0
     0.6666 1 0
     1 1 0];
 
 nod=load('nodesPatch.txt');
 nod=nod(:,[3 4 2]);
 num_nod=length(nod)
elem=[1 2 6 5
      2 3 7 6
      3 4 8 7
      5 6 10 9
      6 7 11 10
      7 8 12 11];
  
  elem=load('elementsPatch.txt');
 elem=elem(:,[2:5]);
elementsBarra(1,:)=[1:num_nod];
 
b=b*ones(length(nod),1);
    
bCorr=b;
 
 
 %% Condiciones de borde

if condicion_de_borde==1
    nod_in(:,1)=find(nod(:,1)==0);%[1 5 9]';
    nod_out(:,1)=find(nod(:,1)==1);%=[4 8 12]';
elseif condicion_de_borde==2
    
    nod_in=[1 2 3 4]';
    nod_out=[9 10 11 12]';
elseif condicion_de_borde==3
    
    nod_in=[1 5 9]';
    nod_out=[];
    

elseif condicion_de_borde==4
    
    nod_in=[]';
    nod_out=[];
end

BC=[nod_in
    nod_out];

BC=[];

elemNew=elem;

nodFisura=nod;
elementsBarra=elementsBarra';

b_old=b;
bOld=b;
bNew=0.001;

Re=zeros(num_nod,1);

iter=0;
t=tInicial;

P_poroso=P_old*ones(num_nod,1);
PinMax=Pin;
PinReal=Pin*ones(num_nod,1)*transitorio+P_poroso*(1-transitorio);
PoutReal=Pout*ones(num_nod,1);
QExt=PoutReal*0;

while t<t_final-(transitorio-1)

    iter=iter+1
    
    t=t+delta_t;
    Tiempo(iter,1)=t;
    
    b=bOld*((t_final-t)/(t_final-tInicial+eps))+bNew*(1-((t_final-t)/(t_final-tInicial+eps)));
    if transitorio==0
        b=bNew;
    end
    
%     if t<3600*24*100*(-1) 
%         BC=[nod_in(1)
%             nod_out];
%     elseif t<3600*24*300*(-1)
%         BC=[nod_in(1:2)
%             nod_out];
%     else
        BC=[nod_in
            nod_out];
%     end

%     for bomba=length(TBombas):-1:1
%         if t<TBombas(bomba)
%             BC(bomba)=0;
%         end
%     end
% find(PAdmitida<P_old(BC))
% find(TBombas>t)

% 
%     BC(find(TBombas>t))=[];
%     
%     BC(find(PAdmitida<P_old(BC)))=[];
        
        
     
    [uno,dos]=condicionDeBorde(elementsBarra,BC);
    
    
    
%     b_old=b;
%     [bCorr,b]=aperturaDeGrietaConCorreccion(nod,elementsBarra,f,f_0);
% 
%     if t<t_final*porcentajeDeTiempoDeCompresion
%     b=0.005*ones(length(b),1)*(1-(t*porcentajeDeCompresion)/(t_final*porcentajeDeTiempoDeCompresion));
%     
%     bCorr=0.005*ones(length(b),1)*(1-(t*porcentajeDeCompresion)/(t_final*porcentajeDeTiempoDeCompresion));
%     else
%         b=0.005*ones(length(b),1)*(1-porcentajeDeCompresion);
%         bCorr=0.005*ones(length(b),1)*(1-porcentajeDeCompresion);
%     end
    selectorLogico=true(num_nod,1);
%     selectorLogico=seleccionDeElementosDeFisura(elementsBarra,elemNew,aperturaMinima,b);
      
    [K,KTemporal, KAlmacenamiento]=ensambleKGlobalYKConvGlobal(ro,mu,nodFisura,elemNew,bCorr,porosidad,selectorLogico,num_nod,b,S,delta_t,Re,beta);
    
    [P,P_old,Q]=resolucionDeEcuaciones(uno,dos,nod_in,nod_out,nodFisura,versorGravedad,K,P_poroso,P_old,PinReal,PoutReal,ro,g,S,delta_t,PinMax,QMax,t,KTemporal, KAlmacenamiento, b_old,b,Re,beta,mu,elemNew,bCorr,porosidad,selectorLogico,bomba, elementsBarra, QExt);      
    
    
    if isempty(dos)
    else
    PHistorico(iter,1:3)=P(nod_in(1:3));
    
    QHistoricoBomba(iter,1)=(sum(Q(dos)));
    
    QHistoricoPermeable(iter,1)=(sum(Q(uno)));
    end
    
    b_old=b;
    
end


[Velocidad,Re]=calculoDeVelocidad(ro, mu,nodFisura,elemNew, bCorr, b, P,selectorLogico, num_nod, versorGravedad, g);
PRESIONPAPAAAAA=P;
maxRe=max(Re);
if graficar == true
    hold on
figure(1)
ax1=subplot(2,3,1);
hold off
graficador(nodFisura,elemNew,Q,graficar,selectorLogico,1,-1)
title('Q')     
% figure(3)
hold on
ax2=subplot(2,3,2);
hold off
graficador(nodFisura,elemNew,P,graficar,selectorLogico,Pin+0.9,PPorosa) 

title('P')
% figure(2)
hold on
ax4=subplot(2,3,4);

plot3(Tiempo/(3600*24),1*ones(length(Tiempo),1),PHistorico(:,1))
hold on
plot3(Tiempo/(3600*24),2*ones(length(Tiempo),1),PHistorico(:,2))
plot3(Tiempo/(3600*24),3*ones(length(Tiempo),1),PHistorico(:,3))

title('Iteraciones')
% figure(4)
hold on
ax5=subplot(2,3,5);
hold off
graficador(nodFisura,elemNew,Re,graficar,selectorLogico,Pin+0.9,PPorosa) 

caxis([0 1000])

title('Re')

% figure(2)
hold on
ax3=subplot(2,3,3);

plot(Tiempo/(3600*24),QHistoricoBomba,'k')
hold on
plot(Tiempo/(3600*24),QHistoricoPermeable,'b')
title('Negro bomba, Azul flujo por pared (Kg/s)')
hold on
ax6=subplot(2,3,6);
QHistoricoBombaAcumulado=QHistoricoBomba;
QHistoricoBombaAcumulado(1)=+QHistoricoBomba(1)*delta_t+QHistoricoViejo;
if iter>1
for i=2:iter
    QHistoricoBombaAcumulado(i)=QHistoricoBombaAcumulado(i-1)+QHistoricoBomba(i)*delta_t;
end
end
QHistoricoViejo=QHistoricoBombaAcumulado(end);
colormap(ax5,jet)
    
plot(Tiempo/(3600*24),[ QHistoricoBombaAcumulado'],'k')
title('fluido inyectado/obtenido (Kg)')
drawnow

else
    QHistoricoViejo=0;
end












