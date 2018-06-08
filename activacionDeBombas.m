function [TBombas]=activacionDeBombas(tiempoUltimaBomba, nroDeBombas)

TBombas=0:tiempoUltimaBomba/(nroDeBombas-1):tiempoUltimaBomba;

end


%%[TBombas]=activacionDeBombas(10, 200, 3)