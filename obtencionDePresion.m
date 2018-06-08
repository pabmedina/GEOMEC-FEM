function P=obtencionDePresion(h_new,versorGravedad,nodFisura,ro,g)
P=(h_new-(versorGravedad(1)*nodFisura(:,1)+versorGravedad(2)*nodFisura(:,2)+versorGravedad(3)*nodFisura(:,3)))*ro*g;
end