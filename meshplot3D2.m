function meshplot3D(elements1,elements2,elements3,nodes,edgecolor,facecolor,edgecolor2,facecolor2,edgecolor3,facecolor3)

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
     
nel1 = size(elements1,1);
nel2 = size(elements2,1);
nel3 = size(elements3,1);

for iele=1:nel1
    for icara=1:size(caras,1)
        h = patch(nodes(elements1(iele,caras(icara,:)),1),nodes(elements1(iele,caras(icara,:)),2),nodes(elements1(iele,caras(icara,:)),3),facecolor);
        set(h,'edgecolor',edgecolor)    % le da color al edge del patch
        hold on
    end
end

for iele=1:nel2
    for icara=1:size(caras,1)
        h = patch(nodes(elements2(iele,caras(icara,:)),1),nodes(elements2(iele,caras(icara,:)),2),nodes(elements2(iele,caras(icara,:)),3),facecolor2);
        set(h,'edgecolor',edgecolor2)    % le da color al edge del patch
        hold on
    end
end

for iele=1:nel3
    for icara=1:size(caras,1)
        h = patch(nodes(elements3(iele,caras(icara,:)),1),nodes(elements3(iele,caras(icara,:)),2),nodes(elements3(iele,caras(icara,:)),3),facecolor3);
        set(h,'edgecolor',edgecolor3)    % le da color al edge del patch
        hold on
    end
end
end