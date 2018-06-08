function [ke_resorte, ke_s] = k_spring(iele,nodes_tot,elements_resortes,E,A)
    
    dir = nodes_tot(elements_resortes(iele,2),:) - nodes_tot(elements_resortes(iele,1),:);
    L = norm(dir);
    dir = dir / L;
    k = E*A/ L;
    ke_s  = [ k -k
             -k  k ];   
                 
    T = [ dir 0 0 0
          0 0 0 dir ];
      
              
    ke_resorte = T' * ke_s * T;

end

