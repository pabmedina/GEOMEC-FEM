function [nodFisura,num_nod]=posicionFisura(nod,elementsBarra)
nod(elementsBarra(:,1),:)=(nod(elementsBarra(:,1),:)+nod(elementsBarra(:,2),:))*0.5;
nodFisura=nod;
num_nod=length(nodFisura);
end