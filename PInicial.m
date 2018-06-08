function [P_poroso, P_old]=PInicial(PPorosa, ro, g,nodFisura,versorGravedad)
num_nod=length(nodFisura);
P_poroso=PPorosa*ones(num_nod,1)+(ro*g)*(versorGravedad(1)*nodFisura(:,1)+versorGravedad(2)*nodFisura(:,2)+versorGravedad(3)*nodFisura(:,3));

P_old=PPorosa*ones(num_nod,1)+(ro*g)*(versorGravedad(1)*nodFisura(:,1)+versorGravedad(2)*nodFisura(:,2)+versorGravedad(3)*nodFisura(:,3));

end