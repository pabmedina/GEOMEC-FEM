figure(35)
for i=1:length(elements_Barra)
    plot3(nodes(elements_Barra(i,1),1),nodes(elements_Barra(i,1),2),nodes(elements_Barra(i,1),3),'+')
    hold on
end

figure(36)
for i=1:length(elements_Barra)
    plot3([nodes(elements_Barra(i,1),1) nodes(elements_Barra(i,2),1)]...
        ,[nodes(elements_Barra(i,1),2) nodes(elements_Barra(i,2),2)]...
        ,[nodes(elements_Barra(i,1),3) nodes(elements_Barra(i,2),3)],'r')
    hold on
end