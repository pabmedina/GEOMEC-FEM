%FGOALATTAIN  多目的ゴール到達最適化問題
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT) は、X を変化させることにより、
%   関数 FUN で設定される目的関数 (F) を、ゴール （GOAL） に到達させます。
%   ゴールは、WEIGHT に従って、重み付けられます。これを行なうときに、
%   以下の形式の非線形計画問題を解きます。
%
%       LAMBDA : F(X)-WEIGHT.*LAMBDA<=GOAL を X, LAMBDA に関して最小化します。
%
%   FUN は、X を入力として、X で計算されるベクトル (行列) の関数値 F を
%   返します。X0 は、スカラ、ベクトル、または、行列です。
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT,A,B) は、線形不等式制約 A*X <= B の
%   もとで、ゴール到達問題を解きます。
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT,A,B,Aeq,Beq) は、同様に線形方程式 
%   Aeq*X = Beq の制約のもとでゴール到達問題を解きます。
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT,A,B,Aeq,Beq,LB,UB) は、設計変数 
%   X の上下限を与えることが可能です。この場合、LB <= X <= UB の範囲内で
%   最適解が探索されます。範囲の制約がない場合、LB と UB に空行列を設定
%   してください。X(i) に 下限がない場合、LB(i) = -Inf と設定し、X(i) に
%   上限がない場合、UB(i) = Inf と設定してください。
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT,A,B,Aeq,Beq,LB,UB,NONLCON) は、
%   NONLCON (通常は、M-ファイル NONLCON.m) で定義した制約のもとで、ゴール
%   到達問題を解きます。ここで関数 NONLCON は、
%   feval: [C, Ceq] = feval(NONLCON,X) 
%   のように呼び出される場合、それぞれ、非線形の不等式制約と等式制約を
%   表わす C と Ceq ベクトルを返します。FGOALATTAIN は、C(X)< = 0 と 
%   Ceq(X) = 0 になるように最適化します。
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT,A,B,Aeq,Beq,LB,UB,NONLCON,OPTIONS) 
%   は、オプション (OPTIONS) を設定して実行できます。ここで、OPTIONS は、
%   OPTIMSET 関数で設定できる構造体です。詳細は、OPTIMSET を参照してください。
%   Display, TolX, TolFun, TolCon, DerivativeCheck, FunValCheck, GradObj, 
%   GradConstr, MaxFunEvals, MaxIter, MeritFunction, GoalsExactAchieve, 
%   Diagnostics, DiffMinChange, DiffMaxChange, PlotFcns, OutputFcn, TypicalX 
%   のオプションを使用できます。オプション GradObj を使って、FUN を呼び出し、
%   2 番目の出力引数 G に点 X での偏微分係数 df/dX を設定できます。 
%   [F,G] = feval(FUN,X).GradConstr オプションを使って、次のように、4 つの
%   出力引数で呼び出される NONLCON を指定できます。
%   [C,Ceq,G,C,GCeq] = feval(NONLINCON,X) の形式で呼び出します。ここで、
%   GC は、不等号制約ベクトル C の偏微分係数、GCeq は、等式制約ベクトル 
%   Ceq の偏微分係数です。オプションを設定しない場合は、OPTIONS = [] を
%   使用してください。
%
%   X = FGOALATTAIN(PROBLEM) は、PROBLEM に定義されたゴール到達問題を
%   解きます。PROBLEM は、PROBLEM.objective に関数 FUN、PROBLEM.x0 に開始点、
%   PROBLEM.goal に 'goal' ベクトル、PROBLEM.weight に 'weight' ベクトル、
%   PROBLEM.Aineq と PROBLEM.bineq に線形不等式制約、PROBLEM.Aeq と PROBLEM.beq 
%   に線形等式制約、PROBLEM.lb に下限、PROBLEM.ub に上限、PROBLEM.nonlcon に
%   非線形制約関数、PROBLEM.options にオプション構造体、PROBLEM.solver に
%   ソルバ名 'fgoalattain' を持つ構造体です。OPTIMTOOL からエクスポートした
%   問題をコマンドラインで解くには、このシンタックスを使用してください。
%   構造体 PROBLEM は、これらのすべてのフィールドを持たなければなりません。
%
%   [X,FVAL] = FGOALATTAIN(FUN,X0,...) は、解 X での目的関数 FUN の値を
%   返します。
%
%   [X,FVAL,ATTAINFACTOR] = FGOALATTAIN(FUN,X0,...) は、解 X での到達因子を
%   返します。ATTAINFACTOR が負の場合、ゴールは過到達になります。また、
%   正の場合、欠到達になります。
%
%   [X,FVAL,ATTAINFACTOR,EXITFLAG] = FGOALATTAIN(FUN,X0,...) は、FGOALATTAIN 
%   の終了状況を示す文字列 EXITFLAG を返します。EXITFLAG の可能な値と対応する
%   終了状況は、次のとおりです。
%
%     1  FGOALATTAIN は、解 X に収束していることを示します。
%     4  探索方向の大きさが指定した許容誤差より小さく、制約違反が 
%        options.TolCon より小さいことを示します。
%     5  探索方向に沿った関数の勾配の大きさが許容範囲より小さく、
%        制約違反が options.TolCon より小さいことを示します。
%     0  関数計算の回数、あるいは繰り返し回数が最大回数に達していることを
%        示します。
%    -1  最適化が、出力関数で終了していることを示します。
%    -2  可解が見つからなかったことを示します。
%
%   [X,FVAL,ATTAINFACTOR,EXITFLAG,OUTPUT] = FGOALATTAIN(FUN,X0,...) は、
%   繰り返し数 OUTPUT.iterations、関数の評価回数 OUTPUT.funcCount、最終ステップの
%   ノルム OUTPUT.stepsize、最終のライン探索のステップ長 OUTPUT.lssteplength、
%   使用したアルゴリズム OUTPUT.algorithm、1 次の最適性 OUTPUT.firstorderopt、
%   終了メッセージ OUTPUT.message を持つ構造体 OUTPUT を返します。
%
%   [X,FVAL,ATTAINFACTOR,EXITFLAG,OUTPUT,LAMBDA] = FGOALATTAIN(FUN,X0,...) 
%   は、解でのラグランジェ乗数 LAMBDA を返します。LAMBDA 構造体は、LAMBDA.lower 
%   に LB を、LAMBDA.upper に UB を、LAMBDA.ineqlin に線形不等式を、
%   LAMBDA.eqlin に線形等式を、LAMBDA.ineqnonlin に非線形不等式を、
%   LAMBDA.eqnonlin に非線形等式を設定します。
%
%   詳細は、M-ファイル FGOALATTAIN.M を参照してください。
%
%   参考 OPTIMSET, OPTIMGET.


%   Copyright 1990-2008 The MathWorks, Inc.
