function [estrato5, estrato6, estrato7, estrato8, estrato9, accion2] = func2(accion2,estrato5,estrato6,estrato7,estrato8,estrato9,d_estrato_10,d_estrato_9,d_estrato_8,d_estrato_7,d_estrato_6,d_estrato_5)
        
%%% Es una funcion que sirve para hacerlo propagar en z. 
        switch accion2
            case '0'
                estrato6.contador_2 = estrato6.contador_2  + 1;
                estrato7.contador_2 = estrato7.contador_2 + 1;
%                 f = 0;
            case '1'
                estrato6.contador_2 = estrato6.div;
                estrato7.contador_2 = estrato7.contador_2 + 1;
                estrato5.contador_2 = estrato5.contador_2 + 1;
            case '2'
                estrato6.contador_2 = estrato6.contador_2  + 1;
                estrato7.contador_2 = estrato7.div;
                estrato8.contador_2 = estrato8.contador_2 + 1;
            case '3'
                estrato6.contador_2 = estrato6.div;
                estrato7.contador_2 = estrato7.div;
                estrato8.contador_2 = estrato8.contador_2 + 1;
                estrato5.contador_2 = estrato5.contador_2 + 1;
            case '4'
                estrato6.contador_2 = estrato6.div;
                estrato7.contador_2 = estrato7.div;
                estrato5.contador_2 = estrato5.div;
                estrato8.contador_2 = estrato8.contador_2 + 1;
            case '5'
                estrato6.contador_2 = estrato6.div;
                estrato5.contador_2 = estrato5.contador_2 + 1;
                estrato7.contador_2 = estrato7.div;
                estrato8.contador_2 = estrato8.div;
                estrato9.contador_2 = estrato9.contador_2 + 1;
            case '6'
                estrato6.contador_2 = estrato6.div;
                estrato7.contador_2 = estrato7.div;
                estrato5.contador_2 = estrato5.div;
                estrato8.contador_2 = estrato8.div;
                estrato9.contador_2 = estrato9.contador_2 + 1;
            case '7'
                estrato6.contador_2 = estrato6.div;
                estrato7.contador_2 = estrato7.div;
                estrato5.contador_2 = estrato5.div;
                estrato8.contador_2 = estrato8.div;
                estrato9.contador_2 = estrato9.div;               

        end

        
        if estrato6.contador_2*estrato6.size == (d_estrato_6 - d_estrato_7)
            accion2 = '1';
        end
        if estrato7.contador_2*estrato7.size == (d_estrato_7 - d_estrato_8)
            accion2 = '2';
        end
        if estrato6.contador_2*estrato6.size == (d_estrato_6 - d_estrato_7) && estrato7.contador_2*estrato7.size == (d_estrato_7 - d_estrato_8)
            accion2 = '3';
        end
        
        if estrato5.contador_2*estrato5.size == (d_estrato_5 - d_estrato_6)
            accion2 = '4';
        end
        if estrato8.contador_2*estrato8.size == (d_estrato_8 - d_estrato_9)
            accion2 = '5';
        end
        if estrato5.contador_2*estrato5.size == (d_estrato_5 - d_estrato_6) && estrato8.contador_2*estrato8.size == (d_estrato_8 - d_estrato_9) 
            accion2 = '6';
        end
        
        if estrato9.contador_2*estrato9.size == (d_estrato_9 - d_estrato_10)
            accion2 = '7';
        end
        
        

end
