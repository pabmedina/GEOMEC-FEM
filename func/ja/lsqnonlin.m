%LSQNONLIN  非線形最小二乗問題
%
%   LSQNONLIN は、以下の形式の問題を解きます。
%   sum {FUN(X).^2} を、X に関して最小化します。
%   ここで、X と関数 FUN で返される値は、X のベクトルまたは行列です。
%
%   X = LSQNONLIN(FUN,X0) は、X0 を初期値として、関数 FUN に記述される関数の
%   二乗和を最小化する X を求めます。関数 FUN は、X を入力として、X で計算
%   されるベクトル (または行列) の関数値 F を返します。
%   注意：FUN は、FUN(X) を返し、sum(FUN(X).^2)) で表される二乗和ではありません。
%   (FUN(X) は、アルゴリズム内で暗黙的に二乗和を行います。)
%
%   X = LSQNONLIN(FUN,X0,LB,UB) は、設計変数 X の上下限の範囲を与えることが
%   可能です。この場合、LB <= X <= UB の範囲で最適解が探索されます。範囲の
%   制約がない場合、LB と UB に空行列を設定してください。X(i) に下限がない場合、
%   LB(i) = -Inf と設定し、X(i) に上限がない場合、UB(i) = Inf と設定してください。
%
%   X = LSQNONLIN(FUN,X0,LB,UB,OPTIONS) は、オプション (OPTIONS) を設定して
%   実行できます。ここで OPTIONS は OPTIMSET 関数で設定できる構造体です。
%   詳細は、OPTIMSET を参照してください。Display, TolX, TolFun, DerivativeCheck, 
%   Diagnostics, FunValCheck, Jacobian, JacobMult, JacobPattern, 
%   LineSearchType, LevenbergMarquardt, MaxFunEvals, MaxIter, DiffMinChange, 
%   DiffMaxChange, LargeScale, MaxPCGIter, PrecondBandWidth, TolPCG, TypicalX, 
%   PlotFcns, OutputFcn のオプションが使用できます。オプション Jacobian を
%   使って FUN を呼び出し、2 番目の出力引数 J に、点 X でのヤコビ行列を設定
%   できます。FUN は、X が長さ n のときに、m 要素のベクトル F が返される場合、
%   J は、m 行 n 列の行列になります。ここで、J(i,j) は、F(i) の x(j) による
%   偏微分係数です (ヤコビ行列 J は、F の勾配を転置したものです)。
%
%   X = LSQNONLIN(PROBLEM) は、PROBLEM で定義された非線形最小二乗問題を解きます。
%   PROBLEM は、PROBLEM.objective に関数 FUN、PROBLEM.x0 に開始点、PROBLEM.lb に
%   下限、PROBLEM.ub に上限、PROBLEM.options にオプション構造体、PROBLEM.solver 
%   にソルバ名 'lsqnonlin' を持つ構造体です。OPTIMTOOL からエクスポートした
%   問題をコマンドラインで解くには、このシンタックスを使用してください。
%   構造体 PROBLEM は、これらのすべてのフィールドを持たなければなりません。
%
%   [X,RESNORM] = LSQNONLIN(FUN,X0,...) は、X での残差の 2 ノルム 
%   sum(FUN(X).^2) を返します。
%
%   [X,RESNORM,RESIDUAL] = LSQNONLIN(FUN,X0,...) は、解 X での残差値 
%   RESIDUAL = FUN(X) を返します。
%
%   [X,RESNORM,RESIDUAL,EXITFLAG] = LSQNONLIN(FUN,X0,...) は、LSQNONLIN の
%   終了状況を示す文字列 EXITFLAG を返します。EXITFLAG の可能な値と対応する
%   終了状況は、次のとおりです。
%
%     1  LSQNONLIN は、解 X に収束したことを示します。
%     2  X の変化が指定した許容範囲より小さいことを示します。
%     3  目的関数値の変化が指定した許容範囲より小さいことを示します。
%     4  探索方向の大きさが指定した許容誤差より小さいことを示します。
%     0  関数計算の回数、あるいは繰り返し回数が最大回数に達していることを
%        示します。
%    -1  最適化が、出力関数で終了していることを示します。
%    -2  境界が矛盾していることを示します。
%    -4  ライン探索は、現在の探索方向に沿って十分に残差を減少できないことを
%        示します。
%
%   [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT] = LSQNONLIN(FUN,X0,...) は、繰り返し
%   回数 OUTPUT.iterations、関数の評価回数 OUTPUT.funcCount、使用したアルゴリズム 
%   OUTPUT.algorithm、(使用した場合) 共役勾配繰り返し回数 OUTPUT.cgiterations、
%   (使用した場合) 1 次の最適性 OUTPUT.firstorderopt、終了メッセージ 
%   OUTPUT.message を持つ構造体 OUTPUT を返します。
%
%   [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = LSQNONLIN(FUN,X0,...) は、
%   解でのラグランジェ乗数 LAMBDA を返します。LAMBDA.lower に LB を、
%   LAMBDA.upper に UB を設定しています。
%
%   [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN] = LSQNONLIN(FUN,X0,...) 
%   は、X での関数 FUN のヤコビ行列を返します。
%
%   例
%     FUN は、@ を使って指定することができます。
%        x = lsqnonlin(@myfun,[2 3 4])
%
%   ここで、myfun は、以下のように表される MATLAB 関数です。
%
%       function F = myfun(x)
%       F = sin(x);
%
%   FUN は、無名関数にすることもできます。
%
%       x = lsqnonlin(@(x) sin(3*x),[1 4])
%
%   FUN がパラメータ化された場合、問題に依存したパラメータを指定して無名関数
%   を使用できます。2 番目の引数 c でパラメータ化された関数 myfun を最小化
%   すると仮定します。ここで、mfun は以下のような M-ファイル関数です。
%
%       function F = myfun(x,c)
%       F = [ 2*x(1) - exp(c*x(1))
%             -x(1) - exp(c*x(2))
%             x(1) - x(2) ];
%
%   c の指定値に対して最適化するには、最初に c に設定します。その後、c の値を
%   捉える 1 つの引数を持つ無名関数を作成し、2 つの引数を持つ無名関数を呼び出し
%   ます。最後に、この無名関数を LSQNONLIN に渡します。
%
%       c = -1; % 最初にパラメータを定義します。
%       x = lsqnonlin(@(x) myfun(x,c),[1;1])
%
%   参考 OPTIMSET, LSQCURVEFIT, FSOLVE, @, INLINE.


%   Copyright 1990-2008 The MathWorks, Inc.
