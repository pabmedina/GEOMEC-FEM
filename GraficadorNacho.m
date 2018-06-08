%% Graficador Nacho
clc
clearvars
close all
nodesload = load('nodes_M22.txt');
nodes = nodesload(:,[2,3]);

PorePressure=importdata('PresionData.mat');


tiempoMaximo=inf;
deltaT  = 3600*24*300;      % Salto temporal
nTiempo = 3600*24*300*250;

Time = 0:deltaT:nTiempo;
aux_elim=find(Time>tiempoMaximo);

Time(aux_elim)=[];

PorePressure(:,aux_elim)=[];

XXX=0:2.5:10;
for aux=1:5
X=XXX(aux);



filas=find(nodes(:,1)==X);


XX=nodes(filas,2);
figure(1)
surf(Time,XX,PorePressure(filas,:),'linestyle',':')

hold on
end
Z=0:0.1:10; %Vectorizar
p=importdata('PAnalitico.mat');
t=importdata('TiempoAnalitico.mat');

aux_elim=find(t>tiempoMaximo);
t(aux_elim)=[];
p(:,aux_elim)=[];

surf(t,Z,p,'linestyle','none')
xlabel('Tiempo')
ylabel('profundidad')
zlabel('Presion')

set(gcf,'color','w');

view([1 1 1])
% camroll(270)
% 
figure(2)
% contour3(1:tMax,XX,PorePressure(filas,1:tMax)-max(max(PorePressure)))


for aux=1:5
X=XXX(aux);



filas=find(nodes(:,1)==X);



XX=nodes(filas,2);
figure(2)
contour3(Time,XX,PorePressure(filas,:),'linestyle','-.')



hold on
end
Z=0:0.1:10; %Vectorizar
p=importdata('PAnalitico.mat');

t=importdata('TiempoAnalitico.mat');

aux_elim=find(t>tiempoMaximo);
t(aux_elim)=[];
p(:,aux_elim)=[];
  

contour3(t,Z,p,'linestyle','-')
xlabel('Tiempo')
ylabel('profundidad')
zlabel('Presion')

set(gcf,'color','w');

jojo=length(t);
c_v=importdata('c_v.mat');

for i=1:round(jojo/5):jojo
    figure(2)
plot3(t(i)*ones(length(Z),1),Z,p(:,i),'k')
% figure(3)
% plot3(((c_v*t(i))/max(abs(Z)))*ones(length(Z),1),Z,p(:,i),'k')
% hold on
end


for i=1:jojo

figure(3)
plot3(((c_v*t(i))/max(abs(Z)))*ones(length(Z),1),Z,p(:,i),'k')
hold on
end
grid on

view([-1 0 0])
camroll(270)
jojo=length(Time);
for i=1:round(jojo/5):jojo
    
    X=XXX(aux);



filas=find(nodes(:,1)==X);



XX=nodes(filas,2);
figure(2)
plot3(Time(i)*ones(length(XX),1),XX,PorePressure(filas,i),'r-.')
end

view([1 1 1])

w=importdata('wAnalitico.mat');

% 
% view([1 0 0])
% camroll(270)