%FSOLVE  最小二乗法を使った多変数非線形方程式の求解
%
%   FSOLVE は、以下の形式の問題を解きます。
%
%   F(X) = 0    ここで、F と X は、ベクトルまたは行列です。
%
%   X = FSOLVE(FUN,X0) は、初期値を行列 X0 として、関数 FUN で表される方程式
%   を解きます。関数 FUN は、X を入力として、X で計算されるベクトル (行列) の
%   関数値 F を返します。
%
%   X = FSOLVE(FUN,X0,OPTIONS) は、デフォルトの最適化パラメータを持つ式の代わり
%   に、OPTIMSET 関数で作成された OPTIONS 構造体の値を使って解を求めます。
%   詳細は、OPTIMSET を参照してください。Display, TolX, TolFun, DerivativeCheck, 
%   Diagnostics, FunValCheck, Jacobian, JacobMult, JacobPattern, 
%   LineSearchType, NonlEqnAlgorithm, MaxFunEvals, MaxIter, PlotFcns, 
%   OutputFcn, DiffMinChange, DiffMaxChange, LargeScale, MaxPCGIter, 
%   PrecondBandWidth, TolPCG, TypicalX のオプションが使用できます。
%   オプション Jacobian を使って、FUN を呼び出し、2 番目の出力引数 J に、
%   点 X でのヤコビ行列を設定できます。FUN は、X が長さ n のときに、m 要素の
%   ベクトル F が返される場合、J は、m 行 n 列の行列になります。ここで、
%   J(i,j) は、F(i) の x(j) による偏微分係数です (ヤコビ行列 J は、F の勾配を
%   転置したものです)。
%
%   X = FSOLVE(PROBLEM) は、PROBLEM で定義されたシステムを解きます。
%   PROBLEM は、PROBLEM.objective に関数 FUN、PROBLEM.x0 に開始点、
%   PROBLEM.options にオプション構造体、PROBLEM.solver にソルバ名 'fsolve' 
%   を持つ構造体です。OPTIMTOOL からエクスポートした問題をコマンドラインで
%   解くには、このシンタックスを使用してください。構造体 PROBLEM は、
%   これらのすべてのフィールドを持たなければなりません。
%
%   [X,FVAL] = FSOLVE(FUN,X0,...) は、X での方程式 FUN の値を返します。
%
%   [X,FVAL,EXITFLAG] = FSOLVE(FUN,X0,...) は、FSOLVE の終了状況を示す文字列 
%   EXITFLAG を返します。EXITFLAG の可能な値と対応する終了状況は、次のとおりです。
%
%     1  FSOLVE は、解 X に収束したことを示します。
%     2  X の変化が指定した許容範囲より小さいことを示します。
%     3  目的関数値の変化が指定した許容範囲より小さいことを示します。
%     4  探索方向の大きさが指定した許容誤差より小さいことを示します。
%     0  関数計算の回数、あるいは繰り返し回数が最大回数に達していることを示します。
%    -1  最適化が、出力関数で終了していることを示します。
%    -2  アルゴリズムが解でない点に収束していることを示します。
%    -3  信頼領域半径が小さくなりすぎていることを示します。
%    -4  ライン探索は、現在の探索方向に沿って十分に残差を減少できないことを示します。
%
%   [X,FVAL,EXITFLAG,OUTPUT] = FSOLVE(FUN,X0,...) は、繰り返し回数 
%   OUTPUT.iterations、関数の評価回数 OUTPUT.funcCount、使用したアルゴリズム 
%   OUTPUT.algorithm、(使用した場合) 共役勾配繰り返し回数 OUTPUT.cgiterations、
%   (使用した場合) 1 次の最適性 OUTPUT.firstorderopt、終了メッセージ 
%   OUTPUT.message を持つ構造体 OUTPUT を返します。
%
%   [X,FVAL,EXITFLAG,OUTPUT,JACOB] = FSOLVE(FUN,X0,...)  は、X での関数 FUN 
%   のヤコビ行列を返します。
%
%   例
%     FUN は、@ を使って指定することができます。
%        x = fsolve(@myfun,[2 3 4],optimset('Display','iter'))
%
%   ここで、myfun は、以下のように表される MATLAB 関数です。
%
%       function F = myfun(x)
%       F = sin(x);
%
%   FUN は、無名関数にすることもできます。
%
%       x = fsolve(@(x) sin(3*x),[1 4],optimset('Display','off'))
%
%   FUN がパラメータ化された場合、問題に依存したパラメータを指定して無名関数
%   を使用できます。2 番目の引数 c でパラメータ化された関数 myfun を最小化
%   すると仮定します。ここで、myfun は以下のような M-ファイル関数です。
%
%       function F = myfun(x,c)
%       F = [ 2*x(1) - x(2) - exp(c*x(1))
%             -x(1) + 2*x(2) - exp(c*x(2))];
%
%   c の指定値に対して最適化するには、最初に c に設定します。その後、c の値を
%   捉える 1 つの引数を持つ無名関数を作成し、2 つの引数を持つ無名関数を呼び
%   出します。最後に、この無名関数を FSOLVE に渡します。
%
%       c = -1; % 最初にパラメータを定義します。
%       x = fsolve(@(x) myfun(x,c),[-5;-5])
%
%   参考 OPTIMSET, LSQNONLIN, @, INLINE.


%   Copyright 1990-2008 The MathWorks, Inc.
