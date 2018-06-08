clc
clear all
close all

%% Testeo

nod3 = [1 1 1
        0 1 1
        1 0 1 
        0 0 1
        1 1 0
        0 1 0 
        1 0 0
        0 0 0];
    
%     nod3=nod3+0.3*(rand([8,3])-0.5);

elem3Entrada(1,:)=[1 2 4 3 5 6 8 7];

elemARefinar=1;






% [nod3, elem3DSalida]=Refinamiento3DeDosPasos(nod3,elem3Entrada,elemARefinar)

[nod3, elem3DSalida]=Refinamiento3DeDosPasosTop(nod3,elem3Entrada,elemARefinar)

% [nod3, elem3DSalida]=Refinamiento2(nod3,elem3Entrada,elemARefinar)

    
%     plot3(nod3(:,1),nod3(:,2),nod3(:,3),'*')
    hold on
    for i=1:length(nod3)
        text(nod3(i,1),nod3(i,2),nod3(i,3),num2str(i))
    end
    
    hold on
    
%     plot3(nod3(1:8,1),nod3(1:8,2),nod3(1:8,3),'*')
    
    axis equal
%     xlim([0.9 1])
% ylim([0 0.1])
% zlim([0 .01])
axis off


figure

    hold on
    graficadorMalladorH8(nod3, elem3DSalida, nod3(:,3))
    axis equal

    % elements(1,:)=[1 2 4 3 5 6 8 7]
    %
    %       Z
    %       [
    %       [
    %       4----------2
    %      /[         /[
    %     / [        / [
    %    /  [       /  [
    %   3----------1   [
    %   [   [      [   [
    %   [   8------[---6---Y
    %   [  /       [  /
    %   [ /        [ /
    %   [/         [/
    %   7----------5
    %  /
    % X
    %
    %
    %12 32 4  48 9  29 8  45
    %11 31 32 12 10 30 29 9 
    %47 2  31 11 46 6  30 10
    %31 2  4  32 30 6  8  29
    %28 44 48 3  13 33 45 7 
    %27 43 44 28 14 34 33 13
    %26 12 43 27 15 9  34 14
    %43 12 48 44 34 9  45 33
    %25 42 12 26 16 35 9  15
    %24 41 42 25 17 36 35 16
    %23 11 41 24 18 10 36 17
    %41 11 12 42 36 10 9  35
    %22 40 11 23 19 37 10 18
    %21 39 40 22 20 38 37 19
    %1  47 39 21 5  46 38 20 
    %39 47 11 40 38 46 10 37
    %
    %
    
    
    
    
    
    
    
    