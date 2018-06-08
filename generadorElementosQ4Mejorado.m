function [elem]=generadorElementosQ4Mejorado(elem8Nod)
    for e=1:length(elem8Nod(:,1))
        elem((6*e)-5:(6*e),:)=[elem8Nod(e,1) elem8Nod(e,5) elem8Nod(e,8) elem8Nod(e,4)
                               elem8Nod(e,5) elem8Nod(e,6) elem8Nod(e,7) elem8Nod(e,8)
                               elem8Nod(e,6) elem8Nod(e,2) elem8Nod(e,3) elem8Nod(e,7)
                               elem8Nod(e,2) elem8Nod(e,1) elem8Nod(e,4) elem8Nod(e,3)
                               elem8Nod(e,1) elem8Nod(e,5) elem8Nod(e,6) elem8Nod(e,2)
                               elem8Nod(e,4) elem8Nod(e,8) elem8Nod(e,7) elem8Nod(e,3) ];
    end
end