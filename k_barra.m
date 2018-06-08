function [ke, keM] = k_barra(iele,nodes,elements,E,A)

dir = nodes(elements(iele,2),1:2) - nodes(elements(iele,1),1:2);
L = norm(dir);
dir = dir / L;
k = E*A / L;
ke_B  = [ k -k
         -k  k ];   
                 
T = [ dir 0 0
      0 0 dir ];
              
ke = T' * ke_B * T; 

keM = ke*L;

end

