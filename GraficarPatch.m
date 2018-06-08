figure(1)
nodos=[];
for i=1:num_nod
    if nod(i,2)==0.5
        nodos=[nodos
               i];
    end
end

plot(nod(nodos,1),P(nodos),'b','linewidth',3)
title('Presion Vs. Distancia','fontsize',24)

xlabel('[m]','fontsize',24)
ylabel('Presion [Pa]','fontsize',24)

set(gcf,'color','w');
set(gca,'fontsize',25)
hold on
drawnow
Sol=importdata('Solucion.mat');

a=0

% single(Sol);
L=1;

for i=7
    i-1
plot(0:L/(length(Sol(i,:))-1):L,Sol(i,:),'r-.','linewidth',2)
drawnow
hold on
end

title('Presion Vs. Distancia','fontsize',24)

xlabel('[m]','fontsize',24)
ylabel('Presion [Pa]','fontsize',24)

set(gcf,'color','w');
set(gca,'fontsize',25);

text(0.06,0.1797,'10^3 seg','fontsize',16)
text(0.12,0.3961,'10^4 seg','fontsize',16)
text(0.38,0.3952,'10^5 seg','fontsize',16)
text(0.6,0.4,'10^6 seg','fontsize',16)