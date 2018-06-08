function vectorReLoco=miLinspace(puntoInicio, puntoFin, n)

factor=2/3;

vectorReLoco(1,:)=puntoInicio;

vectorReLoco(n,:)=puntoFin;

for i=2:n-1
    vectorReLoco(i,:)=vectorReLoco(i-1,:)*(1-factor)+vectorReLoco(n,:)*factor;
end
end