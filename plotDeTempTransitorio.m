%% analitico tansitorio
clear all


syms x t

L=1;

uo=1

uL=0

ul=uo-(uo-uL)*(x/L)

vi=0-ul;

sum=uo+(uL-uo)*(x/L);

K=10^-6;

S=1;

c=sqrt((K)/S)

for n=1:100

    integrando=vi*sin((n*pi*x)/L);
    
    bn=(2/L)*int(integrando,0,L);
    
    sum=sum+bn*sin((n*pi*x)/L)*exp(-(t*(((n*pi*c)/L)^2)));
    
end

clear Sol


jmax=51;
for i=1:9
    for j=1:jmax
        t=10^(i-1);
        x=(j-1)*(L/(jmax-1));
        Sol(i,j)=subs(sum);
    end
    plot(0:L/(length(Sol(i,:))-1):L,Sol(i,:))
    drawnow
    hold on
end
    save('Solucion','Sol')