% OPTIMPLOTCONSTRVIOLATION  各繰り返しで最大の制約違反をプロット
%
%   STOP = OPTIMPLOTCONSTRVIOLATION(X,OPTIMVALUES,STATE) は、
%   OPTIMVALUES.constrviolation をプロットします。
%
%   例:
%   プロット関数として OPTIMPLOTCONSTRVIOLATION を使用するオプション
%   構造体を作成します。
%     options = optimset('PlotFcns',@optimplotconstrviolation);
%
%   プロットを表示するために options を最適化問題に渡します。
%      fmincon(@(x) 3*sin(x(1))+exp(x(2)),[1;1],[],[],[],[],[0 0],[],[],options)


%   Copyright 2006-2008 The MathWorks, Inc.
