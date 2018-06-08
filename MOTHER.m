clc
clearvars
close all
format compact
% format short
format long

tic

for resumirEsto=1
%% Propiedades del fluido y el medio:
ro_0=10^3;%kg/(m^3)
ro=10^3;%kg/(m^3)

mu_0=1.3*10^-3;%Pa*s
mu=1.3*10^-3;%Pa*s

g=9.81;%m/(s^2)

f_0=7.55*10^6;%1/(m*s)
f_0=ro_0*g/mu_0;
f_mu=mu_0/mu;
f=ro*g/mu;

delta=1;%por el momento todavia no se BIEN que es, creo que es un factor de correccion (curve fitting exponent)

transitorio=1;% cero si no es transitorio, 1 si es transitorio
gama=3/9810;
B=1;
S=B*ro*g*gama+1
S=S*transitorio;

t_final=3600*32
delta_t=3600*0.5;
t_final=t_final*transitorio;
porcentajeDeTiempoDeCompresion=0.25;
porcentajeDeCompresion=0.0;
porcentajeDeCompresion=porcentajeDeCompresion*transitorio;

beta=0.5*(0.00477+0.00838);

versorGravedad(:,1)=[0 0 -0];

condicion_de_borde=5;%1 primer patch test, 2 segundo patchtest, 3 tercer patchtest, 4 malla flash
malla_fractura=true;%false;%

aperturaMinima=0.0000;

porosidad=0.000001;%Ignoro que unidadesd son, desp verificar que debe ser 0.0001
% epsilon_e=0.1;%tiene que ser menor a 1, es funcion de la porosidad

PPorosa=6*(10^7);
Pin=20*(10^7);%no poner cero, para convergencia sino queda un 0/0, la maquina piensa que nunca llega a la convergencia
Pout=0;
PComienzo=PPorosa*1;

bomba=1
QMax=3*(10^2)/3;

graficar=true;%false;%

%% Mallado
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


elem=[1 2 6 5
      2 3 7 6
      3 4 8 7
      5 6 10 9
      6 7 11 10
      7 8 12 11];

if condicion_de_borde==4
    nod=load('nodes3d.txt');
    nod=nod(:,[2 3 4]);
    
    
    elem=load('elements3d.txt');
    elem=elem(:,[2 3 4 5]);
end

if malla_fractura==true
nod=load('nodes_M3.txt');
nod=nod(:,[2 3 4]);
% nod=-nod(:,[2 1 3]);
nod=-nod(:,[3 2 1]);
% nod(:,3)=nod(:,3)-nod(604,3)*ones(length(nod),1);

elem8Nod=load('elements_M3.txt');
elem8Nod=elem8Nod(:,2:9);



end
elementsBarra =[604         700
         605         701
         606         702
         607         703
         625         720
         626         721
         627         722
         914        1010
         915        1011
         916        1012
         917        1013
         935        1030
         936        1031
         937        1032
        1224        1320
        1225        1321
        1226        1322
        1227        1323
        1245        1340
        1246        1341
        1247        1342
        1534        1630
        1535        1631
        1536        1632
        1537        1633
        1555        1650
        1556        1651
        1557        1652
         684         775
         685         776
         686         777
         687         778
         705         795
         706         796
         707         797
         994        1085
         995        1086
         996        1087
         997        1088
        1015        1105
        1016        1106
        1017        1107
        1304        1395
        1305        1396
        1306        1397
        1307        1398
        1325        1415
        1326        1416
        1327        1417
        1614        1705
        1615        1706
        1616        1707
        1617        1708
        1635        1725
        1636        1726
        1637        1727
         759         850
         760         851
         761         852
         762         853
         780         870
         781         871
         782         872
        1069        1160
        1070        1161
        1071        1162
        1072        1163
        1090        1180
        1091        1181
        1092        1182
        1379        1470
        1380        1471
        1381        1472
        1382        1473
        1400        1490
        1401        1491
        1402        1492
        1689        1780
        1690        1781
        1691        1782
        1692        1783
        1710        1800
        1711        1801
        1712        1802];
% elementsBarra=importdata('ElementsBarra.mat');
    
%     alargadorElementsBarra=[find(nod(:,1)<-24.95 & nod(:,1)>-44.7 & nod(:,2)<-99 & nod(:,2)>-301 & nod(:,3)<0.1 & nod(:,3)>-0.1) find(nod(:,1)<-24.95 & nod(:,1)>-44.7 & nod(:,2)<-99 & nod(:,2)>-301 & nod(:,3)<0.1 & nod(:,3)>-0.1)]
% for i=1:length(elementsBarra)
% eliminador=find(alargadorElementsBarra(:,1)==elementsBarra(i,1));
% alargadorElementsBarra(eliminador,:)=[];
% end
%     
%     elementsBarraAux=[elementsBarra
%                 alargadorElementsBarra]; 
%             
%             elementsBarra=elementsBarraAux;
    
nod(:,1)= nod(:,1)*1;
nod(:,2)= nod(:,2)*1;
nod(:,3)= nod(:,3)*1;

num_nod=length(nod(:,1));
num_elem=length(elem(:,1));
nod_por_elem=length(elem(1,:));%por ej, nodos en cada elemento






%% Condiciones de borde


if condicion_de_borde==1
    nod_in=[1 5 9]';
    nod_out=[4 8 12]';
elseif condicion_de_borde==2
    
    nod_in=[1 2 3 4]';
    nod_out=[9 10 11 12]';
elseif condicion_de_borde==3
    
    nod_in=[1 5 9]';
    nod_out=[];
    
elseif condicion_de_borde==4
    nod_in=[105];% 200 310 400];%105 200 310]';
    nod_out=[];%200
elseif condicion_de_borde==5
%     nod_out(:,1)=1:num_nod;
%     nod_in=[604 914 1224 1534 684 994 1304 1614 759 1069 1379 1689]';
%     nod_in=[604 684 759]';
    nod_in=[914 994 1069]';
%     nod_in=[172 196 217]';
    nod_out=[];%200
%     nod_out=[604 914 1224 1534 684 994 1304 1614 759 1069 1379 1689]'+3;%200
end

BC=[nod_in
    nod_out];
end


elemNew=generadorElementosQ4(elem8Nod);

[nodFisura,num_nod]=posicionFisura(nod,elementsBarra);

[P_poroso, P_old]=PInicial(PPorosa,ro,g,nodFisura,versorGravedad);

[uno,dos]=condicionDeBorde(elementsBarra,BC);

t=0;

PinMax=Pin;
PinReal=Pin*ones(num_nod,1)*transitorio+P_poroso*(1-transitorio);
% PinReal=0.5*(P_poroso+Pin*ones(num_nod,1));
PoutReal=Pout*ones(num_nod,1);

iter=0;
toc
[bCorr,b]=aperturaDeGrietaConCorreccion(nod,elementsBarra,f,f_0);

b=0.005*ones(length(b),1);
    
bCorr=0.005*ones(length(b),1);

b_old=b;
Re=zeros(num_nod,1);
tic

while t<t_final-(transitorio-1)

    iter=iter+1;
    t=t+delta_t;
    b_old=b;
    [bCorr,b]=aperturaDeGrietaConCorreccion(nod,elementsBarra,f,f_0);

    if t<t_final*porcentajeDeTiempoDeCompresion
    b=0.005*ones(length(b),1)*(1-(t*porcentajeDeCompresion)/(t_final*porcentajeDeTiempoDeCompresion));
    
    bCorr=0.005*ones(length(b),1)*(1-(t*porcentajeDeCompresion)/(t_final*porcentajeDeTiempoDeCompresion));
    else
        b=0.005*ones(length(b),1)*(1-porcentajeDeCompresion);
        bCorr=0.005*ones(length(b),1)*(1-porcentajeDeCompresion);
    end
    
    selectorLogico=seleccionDeElementosDeFisura(elementsBarra,elemNew,aperturaMinima,b);
      
    [K,KConv,KTemporal, KAlmacenamiento]=ensambleKGlobalYKConvGlobal(ro,mu,nodFisura,elemNew,bCorr,porosidad,selectorLogico,num_nod,b,S,delta_t,Re,beta);
    
    [P,P_old,Q]=resolucionDeEcuaciones(uno,dos,nod_in,nod_out,nodFisura,versorGravedad,K,KConv,P_poroso,P_old,PinReal,PoutReal,ro,g,S,delta_t,PinMax,QMax,t,KTemporal, KAlmacenamiento, b_old,b,Re,beta,mu,elemNew,bCorr,porosidad,selectorLogico,bomba);      
    
    
    
    PHistorico(iter,1)=P(dos(1));
    
    QHistoricoBomba(iter,1)=(sum(Q(dos)));
    
    QHistoricoPermeable(iter,1)=(sum(Q(uno)));
    
    b_old=b;
    
end
toc
[Velocidad,Re]=calculoDeVelocidad(ro, mu,nodFisura,elemNew, bCorr, b, P,selectorLogico, num_nod, versorGravedad, g);
figure(1)
ax1=subplot(2,3,1);

graficador(nodFisura,elemNew,Q,graficar,selectorLogico,1,-1)
title('Q')     
% figure(3)
ax2=subplot(2,3,2);

graficador(nodFisura,elemNew,P,graficar,selectorLogico,Pin+0.9,PPorosa) 

title('P')
% figure(2)
ax4=subplot(2,3,4);

plot([delta_t:delta_t:t+0.5*delta_t]/3600,PHistorico)

title('Iteraciones')
% figure(4)
ax5=subplot(2,3,5);

graficador(nodFisura,elemNew,Re,graficar,selectorLogico,Pin+0.9,PPorosa) 

caxis([0 1000])

title('Re')

% figure(2)
ax3=subplot(2,3,3);

plot([delta_t:delta_t:t+0.5*delta_t]/3600,abs(QHistoricoBomba),'k')
hold on
plot([delta_t:delta_t:t+0.5*delta_t]/3600,abs(QHistoricoPermeable),'b')
title('Negro bomba, Azul flujo por pared (Kg/s)')

ax6=subplot(2,3,6);
QHistoricoBombaAcumulado=QHistoricoBomba;
QHistoricoBombaAcumulado(1)=+QHistoricoBomba(1)*delta_t;
if iter>1
for i=2:iter
    QHistoricoBombaAcumulado(i)=QHistoricoBombaAcumulado(i-1)+QHistoricoBomba(i)*delta_t;
end
end

colormap(ax5,jet)
    
plot([0:delta_t:t+0.5*delta_t]/3600,[0 QHistoricoBombaAcumulado'],'k')
title('fluido inyectado/obtenido (Kg)')









