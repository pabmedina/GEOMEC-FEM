function chequeoFisura(nodFisura, elemNew)
figure(36)
ploter=[1 2 3 4];
num_elem=length(elemNew(:,1));

for i=1:num_elem
        axis equal
        fill3([nodFisura(elemNew(i,ploter),1)], ...
            [nodFisura(elemNew(i,ploter),2)],[nodFisura(elemNew(i,ploter),3)],[nodFisura(elemNew(i,ploter),3)],'LineStyle',':')
        hold on
end

colorbar

set(gcf,'color','w');

axis off

drawnow

end