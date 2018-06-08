function [h_poroso, h_old]=hInicial(PPorosa, ro, g,nodFisura,versorGravedad,PComienzo)
num_nod=length(nodFisura);
h_poroso=PPorosa/(ro*g)*ones(num_nod,1)+versorGravedad(1)*nodFisura(:,1)+versorGravedad(2)*nodFisura(:,2)+versorGravedad(3)*nodFisura(:,3);

h_old=PComienzo/(ro*g)*ones(num_nod,1)+versorGravedad(1)*nodFisura(:,1)+versorGravedad(2)*nodFisura(:,2)+versorGravedad(3)*nodFisura(:,3);

end