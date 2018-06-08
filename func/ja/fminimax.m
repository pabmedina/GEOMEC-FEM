%FMINIMAX  多変数関数のミニマックス問題
%
%   FMINIMAX は、以下の形式の問題を解きます。
%   {FUN(X)} を X に関して最小化します。ここで、FUN と X は、ベクトル、
%   または行列です。
%
%   X = FMINIMAX(FUN,X0) は、X0 を初期値として、関数 FUN のミニマックス解 
%   X を求めます。FUN は、X を入力として、X で計算されるベクトル (行列) の
%   関数値 F を返します。X0 は、スカラ、ベクトル、または、行列です。
%
%   X = FMINIMAX(FUN,X0,A,B) は、線形不等式制約 A*X <= B のもとでミニマックス
%   問題を解きます。
%
%   X = FMINIMAX(FUN,X0,A,B,Aeq,Beq) は、線形等式制約 Aeq*X = Beq を考慮して
%   ミニマックス問題を解きます (不等式が存在しない場合、A = [] と B = [] を
%   設定してください)。
%
%   X = FMINIMAX(FUN,X0,A,B,Aeq,Beq,LB,UB) は、設計変数 X の上下限の範囲を
%   与えることが可能です。ここで、LB <= X <= UB 範囲内で最適解が探索されます。
%   範囲の制約がない場合、LB と UB に空行列を設定してください。X(i) に
%   下限がない場合、LB(i) = -Inf と設定し、X(i) に上限がない場合、UB(i) = Inf 
%   と設定してください。
%
%   X = FMINIMAX(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON) は、NONLCON (通常は、
%   M-ファイル NONLCON.m) で定義した制約のもとで、ゴール到達問題を解きます。
%   ここで関数 NONLCON は、feval: [C, Ceq] = feval(NONLCON,X) のように呼び
%   出される場合、それぞれ、非線形の不等式制約と等式制約を表わす C と 
%   Ceq ベクトルを返します。FGOALATTAIN は、C(X)< = 0 と Ceq(X) = 0 に
%   なるように最適化します。
%
%   X = FMINIMAX(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON,OPTIONS) は、オプション 
%   (OPTIONS) を設定して実行できます。ここで、OPTIONS は OPTIMSET 関数で
%   設定できる構造体です。詳細は、OPTIMSET を参照してください。Display, TolX, 
%   TolFun, TolCon, DerivativeCheck, FunValCheck, GradObj, GradConstr, 
%   MaxFunEvals, MaxIter, MeritFunction, MinAbsMax, Diagnostics, DiffMinChange, 
%   DiffMaxChange, PlotFcns, OutputFcn, TypicalX のオプションを使用できます。
%   オプション GradObj を使って、FUN を呼び出し、2 番目の出力引数 G に点 
%   X での偏微分係数 df/dX を設定できます。 [F,G] = feval(FUN,X).GradConstr 
%   オプションを使って、次のように、4 つの出力引数で呼び出される NONLCON を
%   指定できます。[C,Ceq,G,C,GCeq] = feval(NONLINCON,X) の形式で呼び出します。
%   ここで、GC は、不等号制約ベクトル C の偏微分係数、GCeq は、等式制約
%   ベクトル Ceq の偏微分係数です。オプションを設定しない場合は、
%   OPTIONS = [] を使用してください。
%
%   X = FMINIMAX(PROBLEM) は、PROBLEM に対するミニマックス解を求めます。
%   PROBLEM は、PROBLEM.objective に関数 FUN、PROBLEM.x0 に開始点、
%   PROBLEM.Aineq と PROBLEM.bineq に線形不等式制約、PROBLEM.Aeq と 
%   PROBLEM.beq に線形等式制約、PROBLEM.lb に下限、PROBLEM.ub に上限、
%   PROBLEM.nonlcon に非線形制約関数、PROBLEM.options にオプション構造体、
%   PROBLEM.solver にソルバ名 'fminimax' を持つ構造体です。OPTIMTOOL から
%   エクスポートした問題をコマンドラインで解くには、このシンタックスを
%   使用してください。構造体 PROBLEM は、これらのすべてのフィールドを
%   持たなければなりません。
%
%   [X,FVAL] = FMINIMAX(FUN,X0,...) は、解 X での目的関数 
%   FVAL = feval(FUN,X) の値を返します。
%
%   [X,FVAL,MAXFVAL] = FMINIMAX(FUN,X0,...) は、解 X での 
%   MAXFVAL = max { FUN(X) } を返します。
%
%   [X,FVAL,MAXFVAL,EXITFLAG] = FMINIMAX(FUN,X0,...) は、FMINIMAX の終了
%   状況を示す文字列 EXITFLAG を返します。EXITFLAG の可能な値と対応する
%   終了状況は、次のとおりです。
%
%     1  1 次の最適条件が指定した許容範囲を満足していることを示します。
%     4  探索方向の大きさが指定した許容誤差より小さく、制約違反が 
%        options.TolCon より小さいことを示します。
%     5  探索方向に沿った関数の勾配の大きさが許容範囲より小さく、制約違反が 
%        options.TolCon より小さいことを示します。
%     0  関数計算の回数、あるいは繰り返し回数が最大回数に達していることを
%        示します。
%    -1  最適化が、出力関数で終了していることを示します。
%    -2  可解が見つからなかったことを示します。
%
%   [X,FVAL,MAXFVAL,EXITFLAG,OUTPUT] = FMINIMAX(FUN,X0,...) は、実行した
%   繰り返し数 OUTPUT.iterations、関数の評価回数 OUTPUT.funcCount、最終
%   ステップのノルム OUTPUT.stepsize、最終のライン探索のステップ長 
%   OUTPUT.lssteplength、使用したアルゴリズム OUTPUT.algorithm、1 次の最適性 
%   OUTPUT.firstorderopt、終了メッセージ OUTPUT.message を持つ構造体 
%   OUTPUT を返します。
%
%   [X,FVAL,MAXFVAL,EXITFLAG,OUTPUT,LAMBDA] = FMINIMAX(FUN,X0,...) は、
%   解でのラグランジェ乗数 LAMBDA を返します。LAMBDA 構造体は、LAMBDA.lower 
%   に LB を、LAMBDA.upper に UB を、LAMBDA.ineqlin に線形不等式を、
%   LAMBDA.eqlin に線形等式を、LAMBDA.ineqnonlin に非線形不等式を、
%   LAMBDA.eqnonlin に非線形等式を設定します。
%
%   例
%     FUN は、@ を使って指定することができます。
%        x = fminimax(@myfun,[2 3 4])
%
%   ここで、myfun は、以下のように表される MATLAB 関数です。
%
%       function F = myfun(x)
%       F = cos(x);
%
%   FUN は、無名関数にすることもできます。
%
%       x = fminimax(@(x) sin(3*x),[2 5])
%
%   FUN がパラメータ化された場合、問題に依存したパラメータを指定して無名関数
%   を使用できます。2 番目の引数 c でパラメータ化された関数 myfun を最小化
%   すると仮定します。ここで、mfun は以下のような M-ファイル関数です。
%
%       function F = myfun(x,c)
%       F = [x(1)^2 + c*x(2)^2;
%            x(2) - x(1)];
%
%   c の指定値に対して最適化するためには、最初に c に設定します。その後、
%   c の値を捉える 1 つの引数を持つ無名関数を作成し、2 つの引数を持つ
%   無名関数を呼び出します。最後に、この無名関数を FMINIMAX に渡します。
%
%       c = 2; % 最初にパラメータを定義します。
%       x = fminimax(@(x) myfun(x,c),[1;1])
%
%   参考 OPTIMSET, @, INLINE, FGOALATTAIN, LSQNONLIN.


%   Copyright 1990-2008 The MathWorks, Inc.
