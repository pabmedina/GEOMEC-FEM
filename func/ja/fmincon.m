%FMINCON  制約付き多変数関数の最小化
%
%   FMINCON は、以下の形式の問題を解きます。
%   次の制約のもとで、F(X) を、X に関して最小化します。
%       A*X  <= B, Aeq*X  = Beq (線形制約)
%       C(X) <= 0, Ceq(X) = 0   (非線形制約)
%       LB <= X <= UB           (範囲)
%
%   X = FMINCON(FUN,X0,A,B) は、初期 X0 値で、線形不等式制約 A*X <= B の
%   もとで、関数 FUN を最小化する X を求めます。FUN は、X を入力として、
%   X で計算されるスカラの関数値 F を返します。X0 は、スカラ、ベクトル、
%   または、行列です。
%
%   X = FMINCON(FUN,X0,A,B,Aeq,Beq) は、A*X <= B と同様に線形等式制約 
%   Aeq*X = Beq を考慮して FUN を最小化します (不等式制約がない場合は、
%   A=[], B=[] と設定します)。
%
%   X = FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB) は、設計変数 X の上下限の範囲を
%   与えることが可能です。この場合、LB <= X <= UB の範囲内で最適解が探索されます。
%   範囲の制約がない場合、LB と UB に空行列を設定してください。X(i) に 下限が
%   ない場合、LB(i) = -Inf と設定し、X(i) に上限がない場合、UB(i) = Inf と
%   設定してください。
%
%   X = FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON) は、NONLCON で定義された
%   制約のもとで最小化します。ここで関数 NONLCON は、X を入力として、
%   非線形不等式と非線形等式を表わす C と Ceq ベクトルを返します。
%   FMINCON は、C(X) <= 0 と Ceq(X) = 0 となる FUN を最小化します
%   (範囲の制約がない場合、LB=[] と UB=[] として設定してください)。
%
%   X = FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON,OPTIONS) は、オプション 
%   (OPTIONS) を設定して実行できます。ここで、OPTIONS は OPTIMSET 関数で
%   設定できる構造体です。詳細は、OPTIMSET を参照してください。FMINCON で
%   指定できるオプションのリストについては、Optimization Toolbox の
%   マニュアルを参照してください。
%
%   X = FMINCON(PROBLEM) は、PROBLEM に対する最小値を求めます。PROBLEM は、
%   PROBLEM.objective に関数 FUN、PROBLEM.x0 に開始点、PROBLEM.Aineq と 
%   PROBLEM.bineq に線形不等式制約、PROBLEM.Aeq と PROBLEM.beq に線形等式制約、
%   PROBLEM.lb に下限、PROBLEM.ub に上限、PROBLEM.nonlcon に非線形制約関数、
%   PROBLEM.options にオプション構造体、PROBLEM.solver にソルバ名 'fmincon' を
%   持つ構造体です。OPTIMTOOL からエクスポートした問題をコマンドラインで解くには、
%   このシンタックスを使用してください。構造体 PROBLEM は、これらのすべての
%   フィールドを持たなければなりません。
%
%   [X,FVAL] = FMINCON(FUN,X0,...) は、解 X での目的関数 FUN の値を返します。
%
%   [X,FVAL,EXITFLAG] = FMINCON(FUN,X0,...) は、FMINCON の終了状況を示す
%   文字列 EXITFLAG を返します。EXITFLAG の可能な値と対応する終了状況を
%   以下に一覧表示します。
%
%   すべてのアルゴリズム:
%     1  1 次の最適条件が指定した許容範囲を満足していることを示します。
%     0  関数計算の回数、あるいは繰り返し回数が最大回数に達していることを
%        示します。
%    -1  最適化が、出力関数で終了していることを示します。
%    -2  可解が見つからなかったことを示します。
%   trust-region-reflective 法と内点法:
%     2  X の変化が指定した許容範囲より小さいことを示します。
%   trust-region-reflective 法:
%     3  目的関数値の変化が指定した許容範囲より小さいことを示します。
%   アクティブ設定のみ:
%     4  探索方向の大きさが指定した許容誤差より小さく、制約違反が 
%        options.TolCon より小さいことを示します。
%     5  探索方向に沿った関数の勾配の大きさが許容範囲より小さく、
%        制約違反が options.TolCon より小さいことを示します。
%   内点法:
%    -3  問題が範囲外で表れました。
%
%   [X,FVAL,EXITFLAG,OUTPUT] = FMINCON(FUN,X0,...) は、繰り返しの総回数や
%   最後の目的関数値のような情報を持つ構造体 OUTPUT を返します。完全な
%   リストについてはドキュメンテーションを参照してください。
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = FMINCON(FUN,X0,...) は、解でのラグランジェ
%   乗数 LAMBDA を返します。LAMBDA 構造体は、LAMBDA.lower に LB を、LAMBDA.upper 
%   に UB を、LAMBDA.ineqlin に線形不等式を、LAMBDA.eqlin に線形等式を、
%   LAMBDA.ineqnonlin に非線形不等式を、LAMBDA.eqnonlin に非線形等式を設定します。
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA,GRAD] = FMINCON(FUN,X0,...) は、解 X での
%   関数 FUN の勾配値も返します。
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA,GRAD,HESSIAN] = FMINCON(FUN,X0,...) は 
%   解 X でのラグランジェの正確な、または、近似のヘッセ行列の値を返します。
%
%   例
%     FUN は、@ を使って指定することができます。:
%        X = fmincon(@humps,...)
%     この場合、F = humps(X) は、X での HUMPS 関数のスカラ関数値 F を返します。
%
%     FUN は、無名関数にすることもできます。
%        X = fmincon(@(x) 3*sin(x(1))+exp(x(2)),[1;1],[],[],[],[],[0 0])
%     は、X = [0;0] を返します。
%
%   FUN または NONLCON がパラメータ化された場合、問題に依存したパラメータを
%   指定して無名関数を使用できます。関数 myfun を最小化すると仮定し、また 
%   非線形制約条件 mycon を考慮します。ここで、これらの 2 つの関数は 2 番目の
%   引数 a1 と a2 でそれぞれパラメータ化されます。ここで、myfun と mycon は
%   次のような M-ファイル関数です。
%
%        function f = myfun(x,a1)
%        f = x(1)^2 + a1*x(2)^2;
%
%        function [c,ceq] = mycon(x,a2)
%        c = a2/x(1) - x(2);
%        ceq = [];
%
%   指定された a1 と a2 に対して最適化を行なうには、まず、これらのパラメータ
%   を設定します。そして、a1 と a2 を 1 つの引数とする無名関数を 2 つ定義
%   します。最終的に、これらの無名関数を FMINCON に渡します。
%
%        a1 = 2; a2 = 1.5; % 最初にパラメータを定義します。
%        options = optimset('Algorithm','active-set'); % アクティブ設定されたアルゴリズムを実行
%        x = fmincon(@(x) myfun(x,a1),[1;2],[],[],[],[],[],[],@(x) mycon(x,a2),options)
%
%   参考 OPTIMSET, OPTIMTOOL, FMINUNC, FMINBND, FMINSEARCH, @, FUNCTION_HANDLE.


%   Copyright 1990-2008 The MathWorks, Inc.
