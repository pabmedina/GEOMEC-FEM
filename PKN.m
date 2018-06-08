clc
clearvars

p_net = 2e6;          % PAscales
nu    = 0.27;         
G     = 5183.7e6;      % Pascales
h     = 54.55-15;      % metros
E     = 13204.79e6;

w = (1-nu)*h*p_net/G;

E_p = E/(1-nu^2);
% w_0 = 2*h*p_net/E_p;