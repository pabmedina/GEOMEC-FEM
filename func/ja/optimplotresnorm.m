% OPTIMPLOTRESNORM  各繰り返しで残差のノルムの値をプロット
%
%   STOP = OPTIMPLOTRESNORM(X,OPTIMVALUES,STATE) は、OPTIMVALUES.resnorm を
%   プロットします。
%
%   例:
%   プロット関数として OPTIMPLOTRESNORM を使用するオプション構造体を
%   作成します。
%     options = optimset('PlotFcns',@optimplotresnorm);
%
%   プロットを表示するために options を最適化問題に渡します。
%     lsqnonlin(@(x) sin(3*x),[1 4],[],[],options);


%   Copyright 2006-2008 The MathWorks, Inc.
