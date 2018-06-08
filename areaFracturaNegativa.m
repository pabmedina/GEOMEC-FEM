function area = areaFracturaNegativa(elements,nodes)

GP = 1/sqrt(3);
upg = [  GP   1   GP 
        -GP   1   GP   
        -GP   1  -GP     
         GP   1  -GP];     
     
npg = size(upg,1);

area = zeros(length(elements),1);
for iele = 1:length(elements)
    nodesEle = nodes(elements(iele,:),:);   
    for ipg = 1:npg
        % Punto de Gauss
        ksi = upg(ipg,1);
        eta = upg(ipg,2);  
        zeta = upg(ipg,3);
        % Derivadas de las funciones de forma respecto de ksi, eta, zeta         
        dN = [ ((eta - 1)*(zeta + 1))/8, -((eta - 1)*(zeta - 1))/8, ((eta + 1)*(zeta - 1))/8, -((eta + 1)*(zeta + 1))/8, -((eta - 1)*(zeta + 1))/8, ((eta - 1)*(zeta - 1))/8, -((eta + 1)*(zeta - 1))/8, ((eta + 1)*(zeta + 1))/8
               ((ksi - 1)*(zeta + 1))/8, -((ksi - 1)*(zeta - 1))/8, ((ksi - 1)*(zeta - 1))/8, -((ksi - 1)*(zeta + 1))/8, -((ksi + 1)*(zeta + 1))/8, ((ksi + 1)*(zeta - 1))/8, -((ksi + 1)*(zeta - 1))/8, ((ksi + 1)*(zeta + 1))/8
               ((eta - 1)*(ksi - 1))/8,  -((eta - 1)*(ksi - 1))/8,  ((eta + 1)*(ksi - 1))/8,  -((eta + 1)*(ksi - 1))/8,  -((eta - 1)*(ksi + 1))/8,  ((eta - 1)*(ksi + 1))/8,  -((eta + 1)*(ksi + 1))/8,  ((eta + 1)*(ksi + 1))/8 ];
   
        dN = dN(:,[8,4,1,5,7,3,2,6]);
        dN = dN([1 3],[1 2 5 6]);
        
        nodesElements = nodesEle([1 2 5 6],[1 3]);
        jac = dN*nodesElements;                
        area(iele) = area(iele) + det(jac);
    end
end

end

