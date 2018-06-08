function E=ecuacionAResolverBarrasMultilinealesCompleto(gap,q,desp1,despRot,gapViejo,E)
% @gap;

A = 4000;  % Area de cada elemento 

L = 1000;

E_0 = 210E3;

KViejo = A*E_0/L * [ 1 -1   0   0 
                    -1  1   0   0 
                     0  0   1  -1
                     0  0  -1   1];

if gap>desp1 && gap>=gapViejo
    if gap<=despRot
        
        E = (((gap-desp1)*(-desp1*E_0))/(despRot-desp1)+desp1*E_0)/gap;
        
    else
        
        E = 0;
        
    end
    
elseif gap<0
    
    E = E_0*10;
      
end

KResorte = A*E/L * [ 0  0   0   0 
                     0  1  -1   0 
                     0 -1   1   0
                     0  0   0   0];

K = KViejo+KResorte;

D = [-0.5*gap 0.5*gap]';

R(1,1) = -q; 
R(2,1) = q;

% cero=K(2:3,2:3)*D-R;

Tension = KResorte(2:3,2:3)*[0 gap]';

figure(11)
plot(gap,q,'b.')
hold on
plot(gap,Tension(2),'r.')
figure(12)
plot(gap,E,'k.')
hold on
end



