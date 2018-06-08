%FMINCON  多変数関数の極小化
%
%   X = FMINUNC(FUN,X0) は、X0 で始まり、関数 FUN の局所的な最小点 X を
%   見つけようとします。FUN は、X を入力として、X で計算されるスカラの
%   関数値 F を返します。X0 は、スカラ、ベクトル、または、行列です。
%
%   X = FMINUNC(FUN,X0,OPTIONS) は、オプション (OPTIONS) を設定して実行
%   できます。ここで OPTIONS は OPTIMSET 関数で設定できる構造体です。
%   詳細は、OPTIMSET を参照してください。Display, TolX, TolFun, DerivativeCheck, 
%   Diagnostics, FunValCheck, GradObj, HessPattern, Hessian, HessMult, 
%   HessUpdate, InitialHessType, InitialHessMatrix, MaxFunEvals, MaxIter, 
%   DiffMinChange, DiffMaxChange, LargeScale, MaxPCGIter, PrecondBandWidth, 
%   TolPCG, PlotFcns, OutputFcn, TypicalX のオプションが使用できます。
%   GradObj オプションを使って、FUN を呼び出し、2 番目の出力引数 G に点 
%   X での偏微分係数 df/dX を設定できます。オプション Hessian を使って、
%   FUN を呼び出し、3 番目の引数 H に点 X でのヘッセ行列 (2 階微分) を
%   設定できます。Hessian は、大規模問題でのみ使われ、ライン探索法では
%   使われません。
%
%   X = FMINUNC(PROBLEM) は、PROBLEM に対する最小値を求めます。PROBLEM は、
%   PROBLEM.objective に関数 FUN、PROBLEM.x0 に開始点、PROBLEM.options に
%   オプション構造体、PROBLEM.solver にソルバ名 'fminunc' を持つ構造体です。
%   OPTIMTOOL からエクスポートした問題をコマンドラインで解くには、このシンタックス
%   を使用してください。構造体 PROBLEM は、これらのすべてのフィールドを
%   持たなければなりません。
%
%   [X,FVAL] = FMINUNC(FUN,X0,...) は、解 X での目的関数 FUN の値を返します。
%
%   [X,FVAL,EXITFLAG] = FMINUNC(FUN,X0,...) は、FMINUNC の終了状況を示す文字
%   列  EXITFLAG を返します。EXITFLAG の可能な値と対応する終了状況は、
%   次のとおりです。
%
%     1  勾配の大きさが指定した許容範囲より小さいことを示します。
%     2  X の変化が指定した許容範囲より小さいことを示します。
%     3  目的関数値の変化が指定した許容範囲より小さいことを示します 
%        (大規模問題のみ)。
%     0  関数計算の回数、あるいは繰り返し回数が最大回数に達していることを
%        示します。
%    -1  最適化が、出力関数で終了していることを示します。
%    -2  ライン探索が、現在の探索方向に沿って受け入れ可能な点を見つけ
%        られないことを示します (中規模問題のみ)。
%
%   [X,FVAL,EXITFLAG,OUTPUT] = FMINUNC(FUN,X0,...) は、繰り返し回数 
%   OUTPUT.iterations、関数の評価回数 OUTPUT.funcCount、使用したアルゴリズム 
%   OUTPUT.algorithm、(使用した場合) 共役勾配繰り返し回数 OUTPUT.cgiterations、
%   (使用した場合) 1 次の最適性 OUTPUT.firstorderopt、終了メッセージ 
%   OUTPUT.message を持つ構造体 OUTPUT を返します。
%
%   [X,FVAL,EXITFLAG,OUTPUT,GRAD] = FMINUNC(FUN,X0,...) は、解 X での関数 
%   FUN の勾配値を返します。
%
%   [X,FVAL,EXITFLAG,OUTPUT,GRAD,HESSIAN] = FMINUNC(FUN,X0,...) は、
%   解 X での目的関数 FUN のヘッセ行列を返します。
%
%   例
%     FUN は、@ を使って指定することができます。
%        X = fminunc(@myfun,2)
%
%   ここで、myfun は、以下のように表される MATLAB 関数です。
%
%       function F = myfun(x)
%       F = sin(x) + 3;
%
%     与えられた勾配を使って関数を最小化するために、勾配が 2 番目の引数となる
%     ように、関数 myfun を修正します。
%        function [f,g] = myfun(x)
%         f = sin(x) + 3;
%         g = cos(x);
%     そして、(OPTIMSET を使って) OPTIONS.GradObj を 'on' に設定し、勾配を
%     使用できるようにします。
%        options = optimset('GradObj','on');
%        x = fminunc(@myfun,4,options);
%
%     FUN は、無名関数にすることもできます。
%        x = fminunc(@(x) 5*x(1)^2 + x(2)^2,[5;1])
%
%   FUN がパラメータ化された場合、問題に依存したパラメータを指定して無名関数
%   を使用できます。2 番目の引数 c でパラメータ化された関数 myfun を最小化
%   すると仮定します。ここで、mfun は以下のような M-ファイル関数です。
%
%     function [f,g] = myfun(x,c)
%
%     f = c*x(1)^2 + 2*x(1)*x(2) + x(2)^2; % 関数
%     g = [2*c*x(1) + 2*x(2)               % 勾配
%          2*x(1) + 2*x(2)];
%
%   c の指定値に対して最適化するためには、最初に c に設定します。その後、c の
%   値を捉える 1 つの引数を持つ無名関数を作成し、2 つの引数を持つ無名関数を
%   呼び出します。最終的に、無名関数を FMINUNC に渡します。
%
%     c = 3; % 最初にパラメータを定義します。
%     options = optimset('GradObj','on'); % 勾配を指示します。
%     x = fminunc(@(x) myfun(x,c),[1;1],options)
%
%   参考 OPTIMSET, FMINSEARCH, FMINBND, FMINCON, @, INLINE.


%   Copyright 1990-2008 The MathWorks, Inc.
