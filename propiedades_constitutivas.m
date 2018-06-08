function [ C_1, C_2, C_3, C_4, C_5, C_6, C_7, C_8, C_9, C_10] = propiedades_constitutivas

EV_10 = 7.6599E9;
EH_10 = 12.128E9;

NuV_10 = 0.18;
NuH_10 = 0.27;

A_10 = EH_10/((1 + NuH_10)*((EH_10/EV_10)*(1 - NuH_10) - (2*NuV_10^2)));

A11_10 = A_10*((EH_10/EV_10) - NuV_10^2);
A22_10 = A11_10;

A12_10 = A_10*((EH_10/EV_10)*NuH_10 + NuV_10^2);
A21_10 = A12_10;

A13_10 = A_10*NuV_10*(1 + NuH_10);
A23_10 = A13_10;
A31_10 = A13_10;
A32_10 = A13_10;

A33_10 = A_10*(1 - NuH_10^2);

Gv_10 = EV_10/(2*(1 + NuV_10));

Gh_10 = EH_10/(2*(1 + NuH_10));


%% Tensor Constitutivo Estrato 10 [C] 6x6
% Material transversalmente isotrópico

C_10 = [ A11_10 A12_10 A13_10 0      0      0
         A21_10 A22_10 A23_10 0      0      0
         A31_10 A32_10 A33_10 0      0      0
         0      0      0      Gv_10  0      0
         0      0      0      0      Gv_10  0
         0      0      0      0      0      Gh_10];
     
     
     
%% Propiedades constitutivas del estrato 9

EV_9 = 7.959E9;
EH_9 = 12.4598E9;

NuV_9 = 0.19;
NuH_9 = 0.27;

A_9 = EH_9/((1 + NuH_9)*((EH_9/EV_9)*(1 - NuH_9) - (2*NuV_9^2)));

A11_9 = A_9*((EH_9/EV_9) - NuV_9^2);
A22_9 = A11_9;

A12_9 = A_9*((EH_9/EV_9)*NuH_9 + NuV_9^2);
A21_9 = A12_9;

A13_9 = A_9*NuV_9*(1 + NuH_9);
A23_9 = A13_9;
A31_9 = A13_9;
A32_9 = A13_9;

A33_9 = A_9*(1 - NuH_9^2);

Gv_9 = EV_9/(2*(1 + NuV_9));

Gh_9 = EH_9/(2*(1 + NuH_9));


%% Tensor Constitutivo Estrato 9 [C] 6x6
% Material transversalmente isotrópico

C_9 = [ A11_9 A12_9 A13_9    0      0      0
        A21_9 A22_9 A23_9    0      0      0
        A31_9 A32_9 A33_9    0      0      0
        0      0      0      Gv_9   0      0
        0      0      0      0      Gv_9   0
        0      0      0      0      0      Gh_9];
    

%% Propiedades constitutivas del estrato 8

EV_8 = 9.7153E9;
EH_8 = 14.5632E9;

NuV_8 = 0.19;
NuH_8 = 0.28;

A_8 = EH_8/((1 + NuH_8)*((EH_8/EV_8)*(1 - NuH_8) - (2*NuV_8^2)));

A11_8 = A_8*((EH_8/EV_8) - NuV_8^2);
A22_8 = A11_8;

A12_8 = A_8*((EH_8/EV_8)*NuH_8 + NuV_8^2);
A21_8 = A12_8;

A13_8 = A_8*NuV_8*(1 + NuH_8);
A23_8 = A13_8;
A31_8 = A13_8;
A32_8 = A13_8;

A33_8 = A_8*(1 - NuH_8^2);

Gv_8 = EV_8/(2*(1 + NuV_8));

Gh_8 = EH_8/(2*(1 + NuH_8));


%% Tensor Constitutivo Estrato 8 [C] 6x6
% Material transversalmente isotrópico

C_8 = [ A11_8 A12_8 A13_8    0      0      0
        A21_8 A22_8 A23_8    0      0      0
        A31_8 A32_8 A33_8    0      0      0
        0      0      0      Gv_8   0      0
        0      0      0      0      Gv_8   0
        0      0      0      0      0      Gh_8];
    
    
%% Propiedades constitutivas del estrato 7

EV_7 = 8.521E9;
EH_7 = 13.031E9;

NuV_7 = 0.19;
NuH_7 = 0.28;

A_7 = EH_7/((1 + NuH_7)*((EH_7/EV_7)*(1 - NuH_7) - (2*NuV_7^2)));

A11_7 = A_7*((EH_7/EV_7) - NuV_7^2);
A22_7 = A11_7;

A12_7 = A_7*((EH_7/EV_7)*NuH_7 + NuV_7^2);
A21_7 = A12_7;

A13_7 = A_7*NuV_7*(1 + NuH_7);
A23_7 = A13_7;
A31_7 = A13_7;
A32_7 = A13_7;

A33_7 = A_7*(1 - NuH_7^2);

Gv_7 = EV_7/(2*(1 + NuV_7));

Gh_7 = EH_7/(2*(1 + NuH_7));


%% Tensor Constitutivo Estrato 7 [C] 6x6
% Material transversalmente isotrópico

C_7 = [ A11_7 A12_7 A13_7    0      0      0
        A21_7 A22_7 A23_7    0      0      0
        A31_7 A32_7 A33_7    0      0      0
        0      0      0      Gv_7   0      0
        0      0      0      0      Gv_7   0
        0      0      0      0      0      Gh_7];
    
    
%% Propiedades constitutivas del estrato 6

EV_6 = 8.3308E9;
EH_6 = 12.939E9;

NuV_6 = 0.19;
NuH_6 = 0.27;

A_6 = EH_6/((1 + NuH_6)*((EH_6/EV_6)*(1 - NuH_6) - (2*NuV_6^2)));

A11_6 = A_6*((EH_6/EV_6) - NuV_6^2);
A22_6 = A11_6;

A12_6 = A_6*((EH_6/EV_6)*NuH_6 + NuV_6^2);
A21_6 = A12_6;

A13_6 = A_6*NuV_6*(1 + NuH_6);
A23_6 = A13_6;
A31_6 = A13_6;
A32_6 = A13_6;

A33_6 = A_6*(1 - NuH_6^2);

Gv_6 = EV_6/(2*(1 + NuV_6));

Gh_6 = EH_6/(2*(1 + NuH_6));


%% Tensor Constitutivo Estrato 6 [C] 6x6
% Material transversalmente isotrópico

C_6 = [ A11_6 A12_6 A13_6    0      0      0
        A21_6 A22_6 A23_6    0      0      0
        A31_6 A32_6 A33_6    0      0      0
        0      0      0      Gv_6   0      0
        0      0      0      0      Gv_6   0
        0      0      0      0      0      Gh_6];
    
%% Propiedades constitutivas del estrato 5

EV_5 = 8.4458E9;
EH_5 = 13.0310E9;

NuV_5 = 0.19;
NuH_5 = 0.27;

A_5 = EH_5/((1 + NuH_5)*((EH_5/EV_5)*(1 - NuH_5) - (2*NuV_5^2)));

A11_5 = A_5*((EH_5/EV_5) - NuV_5^2);
A22_5 = A11_5;

A12_5 = A_5*((EH_5/EV_5)*NuH_5 + NuV_5^2);
A21_5 = A12_5;

A13_5 = A_5*NuV_5*(1 + NuH_5);
A23_5 = A13_5;
A31_5 = A13_5;
A32_5 = A13_5;

A33_5 = A_5*(1 - NuH_5^2);

Gv_5 = EV_5/(2*(1 + NuV_5));

Gh_5 = EH_5/(2*(1 + NuH_5));


%% Tensor Constitutivo Estrato 5 [C] 6x6
% Material transversalmente isotrópico

C_5 = [ A11_5 A12_5 A13_5    0      0      0
        A21_5 A22_5 A23_5    0      0      0
        A31_5 A32_5 A33_5    0      0      0
        0      0      0      Gv_5   0      0
        0      0      0      0      Gv_5   0
        0      0      0      0      0      Gh_5];
     
%% Propiedades constitutivas del estrato 4

EV_4 = 13.5839E9;
EH_4 = 18.5185E9;

NuV_4 = 0.21;
NuH_4 = 0.30;

A_4 = EH_4/((1 + NuH_4)*((EH_4/EV_4)*(1 - NuH_4) - (2*NuV_4^2)));

A11_4 = A_4*((EH_4/EV_4) - NuV_4^2);
A22_4 = A11_4;

A12_4 = A_4*((EH_4/EV_4)*NuH_4 + NuV_4^2);
A21_4 = A12_4;

A13_4 = A_4*NuV_4*(1 + NuH_4);
A23_4 = A13_4;
A31_4 = A13_4;
A32_4 = A13_4;

A33_4 = A_4*(1 - NuH_4^2);

Gv_4 = EV_4/(2*(1 + NuV_4));

Gh_4 = EH_4/(2*(1 + NuH_4));


%% Tensor Constitutivo Estrato 4 [C] 6x6
% Material transversalmente isotrópico

C_4 = [ A11_4 A12_4 A13_4    0      0      0
        A21_4 A22_4 A23_4    0      0      0
        A31_4 A32_4 A33_4    0      0      0
        0      0      0      Gv_4   0      0
        0      0      0      0      Gv_4   0
        0      0      0      0      0      Gh_4];
    
    
%% Propiedades constitutivas del estrato 3

EV_3 = 7.9927E9;
EH_3 = 12.6116E9;

NuV_3 = 0.18;
NuH_3 = 0.26;

A_3 = EH_3/((1 + NuH_3)*((EH_3/EV_3)*(1 - NuH_3) - (2*NuV_3^2)));

A11_3 = A_3*((EH_3/EV_3) - NuV_3^2);
A22_3 = A11_3;

A12_3 = A_3*((EH_3/EV_3)*NuH_3 + NuV_3^2);
A21_3 = A12_3;

A13_3 = A_3*NuV_3*(1 + NuH_3);
A23_3 = A13_3;
A31_3 = A13_3;
A32_3 = A13_3;

A33_3 = A_3*(1 - NuH_3^2);

Gv_3 = EV_3/(2*(1 + NuV_3));

Gh_3 = EH_3/(2*(1 + NuH_3));


%% Tensor Constitutivo Estrato 3 [C] 6x6
% Material transversalmente isotrópico

C_3 = [ A11_3 A12_3 A13_3    0      0      0
        A21_3 A22_3 A23_3    0      0      0
        A31_3 A32_3 A33_3    0      0      0
        0      0      0      Gv_3   0      0
        0      0      0      0      Gv_3   0
        0      0      0      0      0      Gh_3];
    
    
%% Propiedades constitutivas del estrato 2

EV_2 = 14.4852E9;
EH_2 = 17.8683E9;

NuV_2 = 0.21;
NuH_2 = 0.30;

A_2 = EH_2/((1 + NuH_2)*((EH_2/EV_2)*(1 - NuH_2) - (2*NuV_2^2)));

A11_2 = A_2*((EH_2/EV_2) - NuV_2^2);
A22_2 = A11_2;

A12_2 = A_2*((EH_2/EV_2)*NuH_2 + NuV_2^2);
A21_2 = A12_2;

A13_2 = A_2*NuV_2*(1 + NuH_2);
A23_2 = A13_2;
A31_2 = A13_2;
A32_2 = A13_2;

A33_2 = A_2*(1 - NuH_2^2);

Gv_2 = EV_2/(2*(1 + NuV_2));

Gh_2 = EH_2/(2*(1 + NuH_2));


%% Tensor Constitutivo Estrato 2 [C] 6x6
% Material transversalmente isotrópico

C_2 = [ A11_2 A12_2 A13_2    0      0      0
        A21_2 A22_2 A23_2    0      0      0
        A31_2 A32_2 A33_2    0      0      0
        0      0      0      Gv_2   0      0
        0      0      0      0      Gv_2   0
        0      0      0      0      0      Gh_2];
    
    
%% Propiedades constitutivas del estrato 1

EV_1 = 9.3285E9;
EH_1 = 14.43307E9;

NuV_1 = 0.18;
NuH_1 = 0.26;

A_1 = EH_1/((1 + NuH_1)*((EH_1/EV_1)*(1 - NuH_1) - (2*NuV_1^2)));

A11_1 = A_1*((EH_1/EV_1) - NuV_1^2);
A22_1 = A11_1;

A12_1 = A_1*((EH_1/EV_1)*NuH_1 + NuV_1^2);
A21_1 = A12_1;

A13_1 = A_1*NuV_1*(1 + NuH_1);
A23_1 = A13_1;
A31_1 = A13_1;
A32_1 = A13_1;

A33_1 = A_1*(1 - NuH_1^2);

Gv_1 = EV_1/(2*(1 + NuV_1));

Gh_1 = EH_1/(2*(1 + NuH_1));


%% Tensor Constitutivo Estrato 1 [C] 6x6
% Material transversalmente isotrópico

C_1 = [ A11_1 A12_1 A13_1    0      0      0
        A21_1 A22_1 A23_1    0      0      0
        A31_1 A32_1 A33_1    0      0      0
        0      0      0      Gv_1   0      0
        0      0      0      0      Gv_1   0
        0      0      0      0      0      Gh_1];
                  

end

