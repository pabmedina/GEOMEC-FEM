clc
clear vars 

nodes = [0 0
         1 0
         1 1
         0 1];
     
elements = [1 2 3 4];

ndof = 2;
nNod = size(nodes,1);
nel = size(elements,1);
ndoftot = nNod*ndof;
ndofel = 8;
nnodel = 4;

%% Constitutivo Plane stress

E = 170E3;
NU = 0.33;

C = E/(1-NU^2)*[1  NU  0
                NU  1  0
                0   0 (1-NU)/2];
            
            

%% Funciones de forma
% syms e n
% X = [ 1 e n e*n n^2 e^2 n*e^2 e*n^2 ];
% A = [ subs(X,{e,n},{-1,-1})
%       subs(X,{e,n},{1,-1})
%       subs(X,{e,n},{1,1})
%       subs(X,{e,n},{-1,1})
%       subs(X,{e,n},{0,-1})
%       subs(X,{e,n},{1,0})
%       subs(X,{e,n},{0,1})
%       subs(X,{e,n},{-1,0}) ];
%   
% N = X/A;
%% Matriz de rigidez

PG = [ -1/sqrt(3) -1/sqrt(3)
        1/sqrt(3) -1/sqrt(3)
        1/sqrt(3)  1/sqrt(3)
       -1/sqrt(3)  1/sqrt(3) ];
   
   
V = reshape(1:ndoftot,ndof,[])';

K = zeros(ndoftot);

% dN = [ diff(N,e); diff(N,n) ];
B = zeros(3,8);
area=0;
for iele = 1:nel
    valnod = nodes(elements(iele,:),:);
    ke = zeros(ndofel);
    for ipg = 1:4
        
        ksi = PG(ipg,1);
        eta = PG(ipg,2);  
        
        N4 = 0.25*(1 - ksi)*(1 + eta);
        N3 = 0.25*(1 + ksi)*(1 + eta);
        N2 = 0.25*(1 + ksi)*(1 - eta);
        N1 = 0.25*(1 - ksi)*(1 - eta);
        
        N = [N1 N2 N3 N4];
        
        dN = [ -0.25*(1 - eta),  0.25*(1 - eta), 0.25*(1 + eta), -0.25*(1 + eta)
               -0.25*(1 - ksi), -0.25*(1 + ksi), 0.25*(1 + ksi),  0.25*(1 - ksi) ];
        
        
%         dNval = subs(dN,{e,n},{PG(ipg,:)});
        J = dN*valnod;
        detJ = det(J);
        DN = J\dN;
        B(1,1:2:end) = DN(1,:);
        B(2,2:2:end) = DN(2,:);
        B(3,1:2:end) = DN(2,:);
        B(3,2:2:end) = DN(1,:);
        ke = ke + detJ.*(B.'*C*B);
        area = area + detJ;
    end
    nodedof = reshape(V(elements(iele,:),:)',1,[])';
    K(nodedof,nodedof) = K(nodedof,nodedof) + ke;
end