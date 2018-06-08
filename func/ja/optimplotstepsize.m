% OPTIMPLOTSTEPSIZE  各繰り返しでステップサイズをプロット
%
%   STOP = OPTIMPLOTSTEPSIZE(X,OPTIMVALUES,STATE) は、OPTIMVALUES.stepsize 
%   をプロットします。
%
%   例:
%   プロット関数として OPTIMPLOTSTEPSIZE を使用するオプション構造体を
%   作成します。
%     options = optimset('PlotFcns',@optimplotstepsize);
%
%   プロットを表示するために options を最適化問題に渡します。
%      fmincon(@(x) 3*sin(x(1))+exp(x(2)),[1;1],[],[],[],[],[0 0],[],[],options)


%   Copyright 2006-2008 The MathWorks, Inc.
