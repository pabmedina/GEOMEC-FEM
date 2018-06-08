function graficador(nodFisura, elemNew, P, plot,selectorLogico,Pin,PPorosa)
if plot==true
ploter=[1 2 3 4];
num_elem=length(elemNew);

for i=1:num_elem
    if selectorLogico(i)==true
        axis equal
        fill3([nodFisura(elemNew(i,ploter),1)], ...
            [nodFisura(elemNew(i,ploter),2)],[nodFisura(elemNew(i,ploter),3)],P(elemNew(i,ploter)),'LineStyle',':')
        hold on
    end
end

colorbar

set(gcf,'color','w');

axis off

drawnow

end