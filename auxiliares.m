function [ aux1, aux2, aux3, aux4, aux5, aux6, aux7, aux8, aux9, aux10] = auxiliares(nnod,d_estrato_10,d_estrato_9,d_estrato_8,d_estrato_7, d_estrato_6, d_estrato_5, d_estrato_4, d_estrato_3, d_estrato_2,d_estrato_1, nodes)

aux10                                  =  false(nnod,1);
aux10(nodes(:,3)<d_estrato_10+0.01,1)  =  true;

aux9                                   =  false(nnod,1);
aux9(nodes(:,3)<d_estrato_9 + 0.01,1)  =  true;
aux9(nodes(:,3)==0,1)                  =  false;

aux8                                   =  false(nnod,1);
aux8(nodes(:,3)<d_estrato_8 + 0.01,1)  =  true;
aux8(nodes(:,3)==0,1)                  =  false;
aux8(nodes(:,3)==d_estrato_10,1)       =  false;

aux7                                   =  false(nnod,1);
aux7(nodes(:,3)<d_estrato_7 + 0.01,1)  =  true;
aux7(nodes(:,3)==0,1)                  =  false;
aux7(nodes(:,3)==d_estrato_10,1)       =  false;
aux7(nodes(:,3)==d_estrato_9,1)        =  false;

aux6                                   =  false(nnod,1);
aux6(nodes(:,3)<d_estrato_6 + 0.01,1)  =  true;
aux6(nodes(:,3)==0,1)                  =  false;
aux6(nodes(:,3)==d_estrato_10,1)       =  false;
aux6(nodes(:,3)==d_estrato_8,1)        =  false;
aux6(nodes(:,3)==d_estrato_9,1)        =  false;

aux5                                   =  false(nnod,1);
aux5(nodes(:,3)<d_estrato_5 + 0.01,1)  =  true;
aux5(nodes(:,3)==0,1)                  =  false;
aux5(nodes(:,3)==d_estrato_10,1)       =  false;
aux5(nodes(:,3)==d_estrato_9,1)        =  false;
aux5(nodes(:,3)==d_estrato_8,1)        =  false;
aux5(nodes(:,3)==d_estrato_7,1)        =  false;

aux4                                   =  false(nnod,1);
aux4(nodes(:,3)<d_estrato_4 + 0.01,1)  =  true;
aux4(nodes(:,3)==0,1)                  =  false;
aux4(nodes(:,3)==d_estrato_10,1)       =  false;
aux4(nodes(:,3)==d_estrato_9,1)        =  false;
aux4(nodes(:,3)==d_estrato_8,1)        =  false;
aux4(nodes(:,3)==d_estrato_7,1)        =  false;
aux4(nodes(:,3)==d_estrato_6,1)        =  false;

aux3                                   =  false(nnod,1);
aux3(nodes(:,3)<d_estrato_3 + 0.01,1)  =  true;
aux3(nodes(:,3)==0,1)                  =  false;
aux3(nodes(:,3)==d_estrato_10,1)       =  false;
aux3(nodes(:,3)==d_estrato_9,1)        =  false;
aux3(nodes(:,3)==d_estrato_8,1)        =  false;
aux3(nodes(:,3)==d_estrato_7,1)        =  false;
aux3(nodes(:,3)==d_estrato_6,1)        =  false;
aux3(nodes(:,3)==d_estrato_5,1)        =  false;

aux2                                   =  false(nnod,1);
aux2(nodes(:,3)<d_estrato_2 + 0.01,1)  =  true;
aux2(nodes(:,3)==0,1)                  =  false;
aux2(nodes(:,3)==d_estrato_10,1)       =  false;
aux2(nodes(:,3)==d_estrato_9,1)        =  false;
aux2(nodes(:,3)==d_estrato_8,1)        =  false;
aux2(nodes(:,3)==d_estrato_7,1)        =  false;
aux2(nodes(:,3)==d_estrato_6,1)        =  false;
aux2(nodes(:,3)==d_estrato_5,1)        =  false;
aux2(nodes(:,3)==d_estrato_4,1)        =  false;

aux1                                   =  false(nnod,1);
aux1(nodes(:,3)<d_estrato_1 + 0.01,1)  =  true;
aux1(nodes(:,3)==0,1)                  =  false;
aux1(nodes(:,3)==d_estrato_10,1)       =  false;
aux1(nodes(:,3)==d_estrato_9,1)        =  false;
aux1(nodes(:,3)==d_estrato_8,1)        =  false;
aux1(nodes(:,3)==d_estrato_7,1)        =  false;
aux1(nodes(:,3)==d_estrato_6,1)        =  false;
aux1(nodes(:,3)==d_estrato_5,1)        =  false;
aux1(nodes(:,3)==d_estrato_4,1)        =  false;
aux1(nodes(:,3)==d_estrato_3,1)        =  false;

end

