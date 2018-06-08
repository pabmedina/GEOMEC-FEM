function Ke=element_stiffness(npg,upg,nodesEle,C,ndofel,wpg,ndof,eleType)

Ke = sparse(ndofel,ndofel);
    for ipg = 1:npg
        % Punto de Gauss
        ksi = upg(ipg,1);
        eta = upg(ipg,2);  

%         N  = shapefuns([ksi,eta],eleType);
        dN = shapefunsder([ksi,eta],eleType);
        % Funciones de forma
%         N = [ (1-ksi)*(1-eta)*(1+zeta)/8, (1-ksi)*(1-eta)*(1-zeta)/8, (1-ksi)*(1+eta)*(1-zeta)/8.... 
%               (1-ksi)*(1+eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1+zeta)/8, (1+ksi)*(1-eta)*(1-zeta)/8....
%               (1+ksi)*(1+eta)*(1-zeta)/8, (1+ksi)*(1+eta)*(1+zeta)/8 ];
%           
%         N = N(1,[8,4,1,5,7,3,2,6]);   
        
        % Derivadas de las funciones de forma respecto de ksi, eta, zeta         
%         dN = [ ((eta - 1)*(zeta + 1))/8, -((eta - 1)*(zeta - 1))/8, ((eta + 1)*(zeta - 1))/8, -((eta + 1)*(zeta + 1))/8, -((eta - 1)*(zeta + 1))/8, ((eta - 1)*(zeta - 1))/8, -((eta + 1)*(zeta - 1))/8, ((eta + 1)*(zeta + 1))/8
%                ((ksi - 1)*(zeta + 1))/8, -((ksi - 1)*(zeta - 1))/8, ((ksi - 1)*(zeta - 1))/8, -((ksi - 1)*(zeta + 1))/8, -((ksi + 1)*(zeta + 1))/8, ((ksi + 1)*(zeta - 1))/8, -((ksi + 1)*(zeta - 1))/8, ((ksi + 1)*(zeta + 1))/8
%                ((eta - 1)*(ksi - 1))/8,  -((eta - 1)*(ksi - 1))/8,  ((eta + 1)*(ksi - 1))/8,  -((eta + 1)*(ksi - 1))/8,  -((eta - 1)*(ksi + 1))/8,  ((eta - 1)*(ksi + 1))/8,  -((eta + 1)*(ksi + 1))/8,  ((eta + 1)*(ksi + 1))/8 ];
%         
%         dN = dN(:,[8,4,1,5,7,3,2,6]);

        jac = dN*nodesEle;                

        % Derivadas de las funciones de forma respecto de x,y,z
        dNxy = jac\dN;          % dNxyz = inv(jac)*dN
        
        B = zeros(size(C,1),ndofel);

        B(1,1:ndof:ndofel) = dNxy(1,:);
        B(2,2:ndof:ndofel) = dNxy(2,:); 
        B(3,1:ndof:ndofel) = dNxy(2,:);
        B(3,2:ndof:ndofel) = dNxy(1,:);

%         B(4,1:ndof:ndofel) = dNxy(2,:);
%         B(4,2:ndof:ndofel) = dNxy(1,:);
%         B(5,2:ndof:ndofel) = dNxy(3,:);
%         B(5,3:ndof:ndofel) = dNxy(2,:);
%         B(6,1:ndof:ndofel) = dNxy(3,:);
%         B(6,3:ndof:ndofel) = dNxy(1,:);

        Ke = Ke + B'*C*B*wpg(ipg)*det(jac);             
    end


end

