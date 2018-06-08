function vector_cargas = cargas_por_elemento(npg,upg,wpg,nodesEle,ndof,nnodel,Presion,ndofel_1)

vector_cargas = sparse(ndof*nnodel,1); 
for ipg = 1:npg
        % Punto de Gauss
        ksi = upg(ipg,1);
        eta = upg(ipg,2);  
        zeta = upg(ipg,3);
        p = Presion(1,ipg);
        % Funciones de forma
        N = [ (1-ksi)*(1-eta)*(1+zeta)/8, (1-ksi)*(1-eta)*(1-zeta)/8, (1-ksi)*(1+eta)*(1-zeta)/8.... 
              (1-ksi)*(1+eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1-zeta)/8....
              (1+ksi)*(1+eta)*(1-zeta)/8, (1+ksi)*(1+eta)*(1+zeta)/8 ];
          
        N = N(1,[8,4,1,5,7,3,2,6]);   
        
        % Derivadas de las funciones de forma respecto de ksi, eta, zeta         
        dN = [ ((eta - 1)*(zeta + 1))/8, -((eta - 1)*(zeta - 1))/8, ((eta + 1)*(zeta - 1))/8, -((eta + 1)*(zeta + 1))/8, -((eta - 1)*(zeta + 1))/8, ((eta - 1)*(zeta - 1))/8, -((eta + 1)*(zeta - 1))/8, ((eta + 1)*(zeta + 1))/8
               ((ksi - 1)*(zeta + 1))/8, -((ksi - 1)*(zeta - 1))/8, ((ksi - 1)*(zeta - 1))/8, -((ksi - 1)*(zeta + 1))/8, -((ksi + 1)*(zeta + 1))/8, ((ksi + 1)*(zeta - 1))/8, -((ksi + 1)*(zeta - 1))/8, ((ksi + 1)*(zeta + 1))/8
               ((eta - 1)*(ksi - 1))/8,  -((eta - 1)*(ksi - 1))/8,  ((eta + 1)*(ksi - 1))/8,  -((eta + 1)*(ksi - 1))/8,  -((eta - 1)*(ksi + 1))/8,  ((eta - 1)*(ksi + 1))/8,  -((eta + 1)*(ksi + 1))/8,  ((eta + 1)*(ksi + 1))/8 ];
        
        dN = dN(:,[8,4,1,5,7,3,2,6]);

        jac = dN*nodesEle;                
           
        Jacobiano = [jac(1,2)*jac(3,3) - jac(1,3)*jac(3,2)
                     jac(3,1)*jac(1,3) - jac(1,1)*jac(3,3)
                     jac(1,1)*jac(3,2) - jac(3,1)*jac(1,2)];
                 
        Nr = zeros(ndof,ndof*nnodel);
        Nr(1,1:ndof:ndofel_1) = N(1,1:8);
        Nr(2,2:ndof:ndofel_1) = N(1,1:8);        
        Nr(3,3:ndof:ndofel_1) = N(1,1:8);
        
        vector_cargas = vector_cargas + Nr'*(p)*Jacobiano*wpg(ipg);  
        
end

end

