Optimization Toolbox 
%
% 大規模なアルゴリズムのデモ
%   circustent   - サーカスのテントの型を検出する二次計画法
%   molecule     - 制約なし非線形最小化を使った分子構造の決定
%   optdeblur    - 範囲の制約付き線形最小二乗法を使ったイメージの明瞭化
%   symbolic_optim_demo - Symbolic Toolbox の関数を使った勾配とヘッセ行列の計算
%
% 中規模法のデモ
%   tutdemo      - チュートリアルの手引き
%   goaldemo     - ゴール到達法
%   dfildemo     - 有限精度でのフィルタ設計 (Signal Processing Toolbox が必要)
%   datdemo      - データを曲線に近似
%   officeassign - オフィス割り当て問題を解く 0-1 整数計画問題
%   bandem       - バナナ関数最小化のデモンストレーション
%   airpollution - 半無限プログラミングを使った不確かさの影響の解析
% 
% ユーザーズガイドからの中規模法の例
%   objfun       - 非線形な目的関数
%   confun       - 非線形な制約関数
%   objfungrad   - 勾配を持つ非線形な目的関数
%   confungrad   - 勾配を持つ非線形な制約関数
%   confuneq     - 非線形等式の制約関数
%   optsim.mdl   - 非線形のプラントプロセスの Simulink モデル
%   optsiminit   - optsim.mdl に対する初期設定ファイル
%   runtracklsq  - LSQNONLIN を使った多目的関数のデモ
%   runtrackmm   - FMINIMAX を使った多目的関数のデモ
%   bowlpeakfun  - パラメータを渡す目的関数
%   nestedbowlpeak - パラメータを渡す入れ子形式の目的関数
%
% ユーザー ガイドの大規模なアルゴリズムの例
%   nlsf1         - ヤコビ行列を持つ非線形等式の目的関数
%   nlsf1a        - 非線形等式の目的関数
%   nlsdat1       - ヤコビ行列のスパースパターンの MAT-ファイル (nlsf1a を参照)
%   brownfgh      - 勾配とヘッセ行列を持つ非線形最小化の目的関数
%   brownfg       - 勾配を持つ非線形最小化の目的関数
%   brownhstr     - ヘッセ行列のスパースパターンの MAT-ファイル (brownfg を参照)
%   browneq       - Aeq と beq のスパースな線形等式制約を持つ MAT-ファイル
%   runfleq1      - 等式を使った FMINCON に対する 'HessMult' オプションのデモ
%   brownvv       - 密な行列 (非スパース) の構造化されたへシアンの非線形最小化
%   hmfleq1       - brownvv 目的関数に対するヘッセ行列積
%   fleq1         - brownvv と hmfleq1 に対する V, Aeq, beq の MAT-ファイル
%   qpbox1        - 2 次の目的関数のヘッセスパース行列の MAT-ファイル
%   runqpbox4     - 境界を持つ QUADPROG に対する 'HessMult' のデモ
%   runqpbox4prec - QUADPROG に対する 'HessMult' と TolPCG オプションのデモ
%   qpbox4        - 二次計画法行列の MAT-ファイル
%   runnls3       - LSQNONLIN に対する 'JacobMult' オプションのデモ
%   nlsmm3        - runnls3/nlsf3a 目的関数に対するヤコビ行列乗算関数
%   nlsdat3       - runnls3/nlsf3a 目的関数に対する問題の行列の MAT-ファイル
%   runqpeq5      - 等式を使った QUADPROG に対する 'HessMult' オプションのデモ
%   qpeq5         - runqpeq5 に対する二次計画法の行列の MAT-ファイル
%   particle      - 線形最小二乗法 C と d のスパース行列の MAT-ファイル
%   sc50b         - 線形計画法の例の MAT-ファイル
%   densecolumns  - 線形計画法の例の MAT-ファイル

%   Copyright 1990-2010 The MathWorks, Inc.

