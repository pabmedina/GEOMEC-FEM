%QUADPROG  二次計画法
%
%   X = QUADPROG(H,f,A,b) は、以下の形式の二次計画問題を解きます。
%
%            A*x <=  b のもとで、0.5*x'*H*x + f'*x を x に関して最小化します。
%
%   X = QUADPROG(H,f,A,b,Aeq,beq) は、等式制約 Aeq*x = beq を満たしながら、
%   上述の問題を解きます。
%
%   X = QUADPROG(H,f,A,b,Aeq,beq,LB,UB) は、設計変数 X の上下限の範囲を与える
%   ことが可能です。この場合、LB <= X <= UB の範囲内で最適解が探索されます。
%   範囲の制約がない場合、LB と UB に空行列を設定してください。X(i) に下限が
%   ない場合、LB(i) = -Inf と設定し、X(i) に上限がない場合、UB(i) = Inf と
%   設定してください。
%
%   X = QUADPROG(H,f,A,b,Aeq,beq,LB,UB,X0) は、X0 を開始点として設定します。
%
%   X = QUADPROG(H,f,A,b,Aeq,beq,LB,UB,X0,OPTIONS) は、デフォルトの最適化
%   パラメータの代わりに、関数 OPTIMSET で作成された OPTIONS 構造体の値を
%   使って最小化を行います。詳細は、OPTIMSET を参照してください。Display, 
%   Diagnostics, TolX, TolFun, HessMult, LargeScale, MaxIter, PrecondBandWidth, 
%   TypicalX, TolPCG, MaxPCGIter のオプションを使用することができます。
%   'final' と 'off' のみが Display に対して使われます ('iter' は使用できません)。
%
%   X = QUADPROG(PROBLEM) は、PROBLEM に対する最小値を求めます。PROBLEM は、
%   PROBLEM.H に行列 'H'、PROBLEM.f にベクトル 'f'、PROBLEM.Aineq と 
%   PROBLEM.bineq に線形不等式制約、PROBLEM.Aeq と PROBLEM.beq に線形等式制約、
%   PROBLEM.lb に下限、PROBLEM.ub に上限、PROBLEM.x0 に開始点、PROBLEM.options に
%   オプション構造体、PROBLEM.solver にソルバ名 'quadprog' を持つ構造体です。
%   OPTIMTOOL からエクスポートした問題をコマンドラインで解くには、この
%   シンタックスを使用してください。構造体 PROBLEM には、これらのすべての
%   フィールドがなければなりません。
%
%   [X,FVAL] = QUADPROG(H,f,A,b) は、X での目的関数 FVAL = 0.5*X'*H*X + f'*X 
%   の値を返します。
%
%   [X,FVAL,EXITFLAG] = QUADPROG(H,f,A,b) は、QUADPROG の終了状況を示す文字列 
%   EXITFLAG を返します。EXITFLAG の可能な値と対応する終了状況は、以下の
%   とおりです。
%
%     1  QUADPROG は、解 X に収束したことを示します。
%     3  目的関数値の変化が指定した許容範囲より小さいことを示します。
%     4  局所最小値が見つかったことを示します。
%     0  最大繰り返し回数を超えたことを示します。
%    -2  可解が見つからなかったことを示します。
%    -3  問題に制約がないことを示します。
%    -4  現在の探索方向は、降下の方向ではなく、さらに探索が行われないことを
%        示します。
%    -7  探索方向の大きさが小さくなりすぎていることを示します。
%        これ以上計算を行なうことができません。問題は、不良設定か悪条件です。
%
%   [X,FVAL,EXITFLAG,OUTPUT] = QUADPROG(H,f,A,b) は、繰り返し回数 
%   OUTPUT.iterations、使用したアルゴリズム OUTPUT.algorithm、(使用した場合) 
%   共役勾配繰り返し回数 OUTPUT.cgiterations 、(大規模なアルゴリズムのみ) 1 次の最適値 
%   OUTPUT.firstorderopt、終了メッセージがある場合は OUTPUT.message を持つ
%   構造体 OUTPUT を返します。
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = QUADPROG(H,f,A,b) は、解 X での
%   ラグランジュ乗数 LAMBDA を返します。LAMBDA 構造体は、LAMBDA.ineqyalities 
%   に線形不等式 A を、LAMBDA.eqlin に線形等式 Aeq を、LAMBDA.lower に LB を、
%   LAMBDA.upper に UB を設定します。
%
%   参考 LINPROG, LSQLIN.


%   Copyright 1990-2008 The MathWorks, Inc.
