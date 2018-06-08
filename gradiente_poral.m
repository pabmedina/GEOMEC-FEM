function KC_elemento = gradiente_poral(npg,upg,wpg,nodesEle,nnodel,Kperm)

KC_elemento = sparse(nnodel,nnodel);
    
    for ipg = 1:npg
        % Punto de Gauss
        ksi = upg(ipg,1);
        eta = upg(ipg,2);  
        zeta = upg(ipg,3);
        
%         Funciones de forma
%         N = [ (1-ksi)*(1-eta)*(1+zeta)/8, (1-ksi)*(1-eta)*(1-zeta)/8, (1-ksi)*(1+eta)*(1-zeta)/8.... 
%               (1-ksi)*(1+eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1-zeta)/8....
%               (1+ksi)*(1+eta)*(1-zeta)/8, (1+ksi)*(1+eta)*(1+zeta)/8 ];
% %           
%         N = N(1,[8,4,1,5,7,3,2,6]);   
        
        % Derivadas de las funciones de forma respecto de ksi, eta, zeta         
        dN = [ ((eta - 1)*(zeta + 1))/8, -((eta - 1)*(zeta - 1))/8, ((eta + 1)*(zeta - 1))/8, -((eta + 1)*(zeta + 1))/8, -((eta - 1)*(zeta + 1))/8, ((eta - 1)*(zeta - 1))/8, -((eta + 1)*(zeta - 1))/8, ((eta + 1)*(zeta + 1))/8
               ((ksi - 1)*(zeta + 1))/8, -((ksi - 1)*(zeta - 1))/8, ((ksi - 1)*(zeta - 1))/8, -((ksi - 1)*(zeta + 1))/8, -((ksi + 1)*(zeta + 1))/8, ((ksi + 1)*(zeta - 1))/8, -((ksi + 1)*(zeta - 1))/8, ((ksi + 1)*(zeta + 1))/8
               ((eta - 1)*(ksi - 1))/8,  -((eta - 1)*(ksi - 1))/8,  ((eta + 1)*(ksi - 1))/8,  -((eta + 1)*(ksi - 1))/8,  -((eta - 1)*(ksi + 1))/8,  ((eta - 1)*(ksi + 1))/8,  -((eta + 1)*(ksi + 1))/8,  ((eta + 1)*(ksi + 1))/8 ];
        
        dN = dN(:,[8,4,1,5,7,3,2,6]);

        jac = dN*nodesEle;                

        % Derivadas de las funciones de forma respecto de x,y,z
% %         dNxyz = jac\dN;          % dNxyz = inv(jac)*dN
% %         
% %         B = zeros(6,24);
% % 
% %         B(1,1:ndof:ndofel) = dNxyz(1,:);
% %         B(2,2:ndof:ndofel) = dNxyz(2,:); 
% %         B(3,3:ndof:ndofel) = dNxyz(3,:);
% %         B(4,1:ndof:ndofel) = dNxyz(2,:);
% %         B(4,2:ndof:ndofel) = dNxyz(1,:);
% %         B(5,2:ndof:ndofel) = dNxyz(3,:);
% %         B(5,3:ndof:ndofel) = dNxyz(2,:);
% %         B(6,1:ndof:ndofel) = dNxyz(3,:);
% %         B(6,3:ndof:ndofel) = dNxyz(1,:);
 
        KC_elemento = KC_elemento + dN'*Kperm*dN*wpg(ipg)*det(jac);
                    
    end
    
end

