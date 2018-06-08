clear all
close all
clc
ro=10^3;%kg/(m^3)
mu=1.3*10^-3;%Pa*s
transitorio=1;
gama=1/9810;
tInicial=0;
alfaTime=24*1
t_final=3600*24*alfaTime;
delta_t=3600*alfaTime;
Pin=11e3;
bomba=1
QMax=3*(10^1)/3;
graficar=true;%false;%
nod=load('nodes_M22.txt');
nod=nod(:,[2 3 4]);
elem8Nod=load('elements_M22.txt');

elem8Nod=elem8Nod(:,2:9);
elementsBarra=importdata('ElementsBarra.mat');

P_old=6e3*ones(length(nod),1);
QExt=1e-1*ones(length(nod),1);
QHistoricoViejo=0

[TBombas]=activacionDeBombas(3600*24*300, 3)


[PRESURE,QHistoricoViejo,bNew]=MOTHERFUNCTION(ro, mu, transitorio, gama, tInicial, t_final, delta_t, Pin, bomba, QMax, graficar, nod*1, elem8Nod, elementsBarra, P_old,nod,QExt,QHistoricoViejo,TBombas);
% function [PRESIONPAPAAAAA,b,bNew,bOld,maxRe]=MOTHERFUNCTION(ro, mu, transitorio, gama, tInicial, t_final, delta_t, Pin, bomba, QMax, graficar, nod, elem8Nod, elementsBarra, P_old,nodOld)
% QHistoricoViejo=0;
% Pin=7e3;
% bomba=1
for reloco=2:10
% ro=10^3;%kg/(m^3)
% mu=1.3*10^-3;%Pa*s
% transitorio=1;
% gama=1/9810;
tInicial=t_final;
t_final=tInicial+3600*24*alfaTime;
% delta_t=3600*1;
% Pin=0e0;
% bomba=1
% QMax=3*(10^4)/3;
graficar=true;%false;%
hold on
% nod=load('nodes_M22.txt');
% nod=nod(:,[2 3 4]);
% elem8Nod=load('elements_M22.txt');
% 
% elem8Nod=elem8Nod(:,2:9);
% elementsBarra=importdata('ElementsBarra.mat');

% P_old=0e3*ones(length(nod),1);
P_old=PRESURE;
[PRESURE,QHistoricoViejo,bNew]=MOTHERFUNCTION(ro, mu, transitorio, gama, tInicial, t_final, delta_t, Pin, bomba, QMax, graficar, nod*1, elem8Nod, elementsBarra, P_old,nod,QExt,QHistoricoViejo,TBombas);

end
% QHistoricoViejo=0;
% Pin=7e3;
% bomba=1
QExt=0e-1*ones(length(nod),1);
for reloco=1:30
% ro=10^3;%kg/(m^3)
% mu=1.3*10^-3;%Pa*s
% transitorio=1;
% gama=1/9810;
tInicial=t_final;
t_final=tInicial+3600*24*alfaTime;
% delta_t=3600*1;
% Pin=0e0;
% bomba=1
% QMax=3*(10^4)/3;
graficar=true;%false;%
hold on
% nod=load('nodes_M22.txt');
% nod=nod(:,[2 3 4]);
% elem8Nod=load('elements_M22.txt');
% 
% elem8Nod=elem8Nod(:,2:9);
% elementsBarra=importdata('ElementsBarra.mat');

% P_old=0e3*ones(length(nod),1);
P_old=PRESURE;
[PRESURE,QHistoricoViejo,bNew]=MOTHERFUNCTION(ro, mu, transitorio, gama, tInicial, t_final, delta_t, Pin, bomba, QMax, graficar, nod*1, elem8Nod, elementsBarra, P_old,nod,QExt,QHistoricoViejo,TBombas);

end
