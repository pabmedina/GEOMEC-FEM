function [ke, keM,ke_prima] = k_barra(iele,nodes,elements,E,A,E_b,Length,nFisuras)

dir = nodes(elements(iele,2),1:2) - nodes(elements(iele,1),1:2);
L = norm(dir);
dir = dir / L;

k = E*A /Length/nFisuras;
% k = k/nFisuras;
kprima = E_b*A/Length/nFisuras;  % faltaría multiplicar por algún factor que escale el problema. (Divido por la cantidad de fisuras)
% kprima = kprima/nFisuras;
kmod = E_b*A/Length/nFisuras;
% kmod = kmod/nFisuras;

ke_B  = [ k -k
         -k  k ];   
     
ke_prima  = [ kprima -kprima
             -kprima  kprima ];  
                 
T = [ dir 0 0
      0 0 dir ];
              
ke = T' * ke_B * T; 
ke_prima = T'*ke_prima*T;
kmod = T'*kmod*T;
% ke([2 4],[2 4]) =  0.5*ke_B;

keM = kmod*Length;

end

