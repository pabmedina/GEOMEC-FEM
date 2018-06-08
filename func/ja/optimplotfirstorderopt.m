% OPTIMPLOTFIRSTORDEROPT  各繰り返しで 1 次の最適性をプロット
%
%   STOP = OPTIMPLOTFIRSTORDEROPT(X,OPTIMVALUES,STATE) は、
%   OPTIMVALUES.firstorderopt をプロットします。
%
%   例:
%   プロット関数として OPTIMPLOTFIRSTORDEROPT を使用するオプション構造体を
%   作成します。
%     options = optimset('PlotFcns',@optimplotfirstorderopt);
%
%   プロットを表示するために options を最適化問題に渡します。
%      fmincon(@(x) 3*sin(x(1))+exp(x(2)),[1;1],[],[],[],[],[0 0],[],[],options)


%   Copyright 2006-2008 The MathWorks, Inc.
