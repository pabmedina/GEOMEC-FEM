function meshplot3D(elements,nodes,edgecolor,facecolor)

% elementos: Matriz de conectividades.
% nodos:     Matriz de coordenadas nodales.
% edgecolor: Color de las aristas
% facecolor: Color de las caras

caras = [1 2 3 4
         5 6 7 8
         2 6 7 3 
         1 4 8 5
         1 2 6 5
         3 4 8 7]; 
     
nel = size(elements,1);

for iele=1:nel
    for icara=1:size(caras,1)
        h = patch(nodes(elements(iele,caras(icara,:)),1),nodes(elements(iele,caras(icara,:)),2),nodes(elements(iele,caras(icara,:)),3),facecolor);
        set(h,'edgecolor',edgecolor)    % le da color al edge del patch
        hold on
    end
end
end