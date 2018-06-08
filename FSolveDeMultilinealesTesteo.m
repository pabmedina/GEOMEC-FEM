%% FSolveDeMultilinealesTesteo
clc
clearvars
close all

qPaso = 50;

q= qPaso;

desp1=0.008;

despRot=6*desp1;

gapViejo=0;

direccion=1;

E=210E3;

options = optimset('Display','off');

tic

while 1<2
    
    if gapViejo>(desp1+despRot)*0.5
        
        direccion=-1;
    
    end
    
    q = q+qPaso*direccion;
    
    gapInicio = gapViejo;
    
    
    gap = fsolve(@(g) ecuacionAResolverBarrasMultilineales(g,q,desp1,despRot,gapViejo,E),gapInicio,options);
    
    E = ecuacionAResolverBarrasMultilinealesCompleto(gap,q,desp1,despRot,gapViejo,E);
    
    gapViejo=gap;
    
    
    if abs(gap) > 3*despRot
        
        break
    
    elseif gap < -0.5*desp1
        
        break
    
    end
    
end

toc
    