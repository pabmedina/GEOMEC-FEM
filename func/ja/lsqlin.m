%LSQLIN  制約付き線形最小二乗問題
%
%   X = LSQLIN(C,d,A,b) は、以下の形式の不等号の制約条件付き最小二乗問題を
%   解きます。
%
%           A*x <=  b のもとで 0.5*(NORM(C*x-d)).^2 を x に関して、最小化します。
%
%   ここで、C は m x n です。
%
%   X = LSQLIN(C,d,A,b,Aeq,beq) は、以下の形式の (等号の制約付き) 最小二乗
%   問題を解きます。
%
%           A*x <=  b と Aeq*X = Beq のもとで 0.5*(NORM(C*x-d)).^2 を 
%           x に関して、最小化します。
%
%   X = LSQLIN(C,d,A,b,Aeq,beq,LB,UB) は、設計変数 X の上下限の範囲を与える
%   ことが可能です。この場合、LB <= X <= UB の範囲内で最適解が探索されます。
%   範囲の制約がない場合、LB と UB に空行列を設定してください。X(i) に下限が
%   ない場合、LB(i) = -Inf と設定し、X(i) に上限がない場合、UB(i) = Inf と
%   設定してください。
%
%   X = LSQLIN(C,d,A,b,Aeq,beq,LB,UB,X0) は、X0 を開始点として設定します。
%
%   X = LSQLIN(C,d,A,b,Aeq,beq,LB,UB,X0,OPTIONS) は、デフォルトの最適化
%   パラメータの代わりに、関数 OPTIMSET で作成された OPTIONS 構造体の値を
%   使って最小化を行います。詳細は、OPTIMSET を参照してください。Display, 
%   Diagnostics, TolFun, LargeScale, MaxIter, JacobMult, PrecondBandWidth, 
%   TypicalX, TolPCG, MaxPCGIter のオプションを使用することができます。
%   'final' と 'off' のみが Display に対して使われます ('iter' は使用できません)。
%
%   X = LSQLIN(PROBLEM) は、PROBLEM で定義された最小二乗問題を解きます。
%   PROBLEM は、PROBLEM.C に行列 'C'、PROBLEM.d にベクトル 'd'、PROBLEM.Aineq 
%   と PROBLEM.bineq に線形不等式制約、PROBLEM.Aeq と PROBLEM.beq に線形等式制約、
%   PROBLEM.lb に下限、PROBLEM.ub に上限、PROBLEM.x0 に開始点、PROBLEM.options に
%   オプション構造体、PROBLEM.solver にソルバ名 'lsqlin' を持つ構造体です。
%   OPTIMTOOL からエクスポートした問題をコマンドラインで解くには、この
%   シンタックスを使用してください。構造体 PROBLEM には、これらのすべての
%   フィールドがなければなりません。
%
%   [X,RESNORM] = LSQLIN(C,d,A,b) は、残差の二乗 2 ノルム値 norm(C*X-d)^2 を
%   返します。
%
%   [X,RESNORM,RESIDUAL] = LSQLIN(C,d,A,b) は、残差 C*X-d を返します。
%
%   [X,RESNORM,RESIDUAL,EXITFLAG] = LSQLIN(C,d,A,b) は、LSQLIN の終了状況を
%   示す文字列 EXITFLAG を返します。EXITFLAG の可能な値と対応する終了状況は、
%   以下のとおりです。
%
%     1  LSQLIN は、解 X に収束したことを示します。
%     3  残差の変化が指定した許容範囲より小さいことを示します。
%     0  最大繰り返し回数を超えたことを示します。
%    -2  問題が不可解であることを示します。
%    -4  悪条件のため、最適化を中断したことを示します。
%    -7  探索方向の大きさが小さくなりすぎていることを示します。
%        これ以上計算を行なうことができません。問題は、不良設定か
%        悪条件です。
%
%   [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT] = LSQLIN(C,d,A,b) は、繰り返し 
%   OUTPUT.iterations、使用したアルゴリズム OUTPUT.algorithm、(使用した場合) 
%   共役勾配繰り返し回数 OUTPUT.cgiterations、(大規模問題のみ) 1 次の最適性 
%   OUTPUT.firstorderopt、終了メッセージ OUTPUT.message を持つ構造体 OUTPUT を
%   返します。
%
%   [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = LSQLIN(C,d,A,b) は、
%   解 X でのラグランジュ乗数 LAMBDA を返します。LAMBDA 構造体は、
%   LAMBDA.ineqyalities に線形不等式 C を、LAMBDA.eqlin に線形等式 Ceq を、
%   LAMBDA.lower に LB を、LAMBDA.upper に UB を設定します。
%
%   参考 QUADPROG.


%   Copyright 1990-2008 The MathWorks, Inc.
