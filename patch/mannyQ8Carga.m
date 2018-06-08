clc
clear

%% Discretizacion 

nodes = [1 0
         2 0
         0 2
         0 1
         1.5 0
         2/sqrt(2) 2/sqrt(2)
         0   1.5
         1/sqrt(2) 1/sqrt(2)];

elements = [1 2 3 4 5 6 7 8];
t = 1;

nDofNod = 2;
nNodEle = 8;
nNod = size(nodes,1);
nEle = size(elements,1);

%% Condiciones de Borde

bc = false(nNod,nDofNod);
bc([1 5 2 4 7 3],:) = true;

%% Cargas

R = zeros(nNod,nDofNod);

sigma = 10;
tau = 0;

ksi = 1;
loadedNodes = [3 6 2];
a = 1/sqrt(3);
PG = [-a a];                                                                % Integracion numerica 2 Ptos de Gauss
wPG = [1 1];                                                                % Pesos

for iEle = 1: nEle
    
    nodeDofs = nodes(elements(iEle,:),:);
    
    for iNod = 1:3 
        
        for iPG = 1:length(PG)

            eta = PG(iPG);
            N = [(eta/4 - 1/4)*(ksi - 1) - ((eta^2 - 1)*(ksi/2 - 1/2))/2 - ((ksi^2/2 - 1/2)*(eta - 1))/2
                 ((eta^2 - 1)*(ksi/2 + 1/2))/2 - (ksi/4 + 1/4)*(eta - 1) - ((ksi^2/2 - 1/2)*(eta - 1))/2
                 1/4*(1+ksi)*(1+eta)-1/2*(1/2*(1-ksi^2)*(1-eta)+1/2*(1+ksi)*(1-eta^2))
                 - (ksi/4 - 1/4)*(eta + 1) - ((eta^2 - 1)*(ksi/2 - 1/2))/2 - ((ksi^2/2 + 1/2)*(eta + 1))/2
                                                                     (ksi^2/2 - 1/2)*(eta - 1)
                                                                    -(eta^2 - 1)*(ksi/2 + 1/2)
                                                                     (ksi^2/2 + 1/2)*(eta + 1)
                                                                     (eta^2 - 1)*(ksi/2 - 1/2)];

            dNksi =  [eta/4 - (ksi*(eta - 1))/2 - eta^2/4
                     eta^2/4 - (ksi*(eta - 1))/2 - eta/4
                     eta/4 + (ksi*(eta + 1))/2 + eta^2/4
                     (ksi*(eta + 1))/2 - eta/4 - eta^2/4
                      ksi*(eta - 1)
                      1/2 - eta^2/2
                      -ksi*(eta + 1)
                       eta^2/2 - 1/2];

            dNeta =     [ksi/4 - ksi^2/4 - eta*(ksi/2 - 1/2)
                        eta*(ksi/2 + 1/2) - ksi^2/4 - ksi/4
                        ksi/4 + ksi^2/4 + eta*(ksi/2 + 1/2)
                        ksi^2/4 - ksi/4 - eta*(ksi/2 - 1/2)
                        ksi^2/2 - 1/2
                        -2*eta*(ksi/2 + 1/2)
                        1/2 - ksi^2/2
                        2*eta*(ksi/2 - 1/2)];

             jac =       [dNksi'
                          dNeta'] * nodeDofs;
                      
             R(loadedNodes(iNod),1) = R(loadedNodes(iNod),1) +  N(loadedNodes(iNod)) * (+tau*jac(2,1) - sigma*jac(2,2)) * t;         % El peso siempre es 1 
             R(loadedNodes(iNod),2) = R(loadedNodes(iNod),2) +  N(loadedNodes(iNod)) * (+sigma*jac(2,1) - tau*jac(2,2)) * t; 


        end
    
    end
    
   
end

