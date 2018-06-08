%LINPROG  線形計画問題
%
%   X = LINPROG(f,A,b) は、以下の形式の線形計画問題を解きます。
%
%            A*x <= b のもとで、f'*x を x に関して最小化します。
%
%   X = LINPROG(f,A,b,Aeq,beq) は、等式制約 Aeq*x = beq を満たしながら、
%   上述の問題を解きます。
%
%   X = LINPROG(f,A,b,Aeq,beq,LB,UB) は、設計変数 X の上下限の範囲を与える
%   ことが可能です。この場合、LB <= X <= UB の範囲内で最適解が探索されます。
%   範囲の制約がない場合、LB と UB に空行列を設定してください。X(i) に下限が
%   ない場合、LB(i) = -Inf と設定し、X(i) に上限がない場合、UB(i) = Inf と
%   設定してください。
%
%   X = LINPROG(f,A,b,Aeq,beq,LB,UB,X0) は、初期値を X0 に設定します。
%   このオプションは、有効制約法を使用するときのみ利用できます。
%   デフォルトの内点アルゴリズムは、すべての空でない初期値を無視します。
%
%   X = LINPROG(f,A,b,Aeq,beq,LB,UB,X0,OPTIONS) は、オプション (OPTIONS) を
%   設定して実行できます。ここで、OPTIONS は OPTIMSET 関数で設定できる構造体です。
%   詳細は、OPTIMSET を参照してください。Display, Diagnostics, TolFun, 
%   LargeScale, MaxIter のオプションを使用することができます。LargeScale が 
%   'off' の場合、'final' と 'off' のみが、Display に対して使われます 
%   (LargeScale が 'on' の場合、'iter' を使用できます)。
%
%   X = LINPROG(PROBLEM) は、PROBLEM に対する最小値を求めます。
%   PROBLEM は、PROBLEM.f にベクトル 'f'、PROBLEM.Aineq と PROBLEM.bineq に
%   線形不等式制約、PROBLEM.Aeq と PROBLEM.beq に線形等式制約、PROBLEM.lb に
%   下限、PROBLEM.ub に上限、PROBLEM.x0 に開始点、PROBLEM.options に
%   オプション構造体、PROBLEM.solver にソルバ名 'linprog' を持つ構造体です。
%   OPTIMTOOL からエクスポートした問題をコマンドラインで解くには、
%   このシンタックスを使用してください。構造体 PROBLEM には、これらのすべての
%   フィールドがなければなりません。
%
%   [X,FVAL] = LINPROG(f,A,b) は、解 X での目的関数の値 FVAL = f'*X を返します。
%
%   [X,FVAL,EXITFLAG] = LINPROG(f,A,b) は、LINPROG の終了状況を示す文字列 
%   EXITFLAG を返します。EXITFLAG の可能な値と対応する終了状況は、以下のとおりです。
%
%     1  LINPROG は、解 X に収束したことを示します。
%     0  最大繰り返し回数に達していることを示します。
%    -2  可解が見つからなかったことを示します。
%    -3  問題に制約がないことを示します。
%    -4  アルゴリズムの評価中に NaN の値があったことを示します。
%    -5  双対、主問題の両方が不可解であることを示します。
%    -7  探索方向の大きさが小さくなりすぎていることを示します。
%        これ以上計算を行なうことができません。問題は、不良設定か悪条件です。
%
%   [X,FVAL,EXITFLAG,OUTPUT] = LINPROG(f,A,b) は、繰り返し回数 OUTPUT.iterations、
%   使用したアルゴリズム OUTPUT.algorithm、共役勾配繰り返し回数 
%   OUTPUT.cgiterations (= 0, 下位互換性のために含まれました)、終了メッセージ 
%   OUTPUT.message を持つ構造体 OUTPUT を返します。
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = LINPROG(f,A,b) は、解 X でのラグランジュ
%   乗数 LAMBDA を返します。LAMBDA 構造体は、LAMBDA.ineqyalities に線形不等式 
%   A を、LAMBDA.eqlin に線形等式 Aeq を、LAMBDA.lower に LB を、LAMBDA.upper 
%   に UB を設定します。
%
%   注意: LINPROG の大規模問題 (デフォルト) は、主双対法を使用します。
%         主問題と双対問題は、共に収束に対して不可解でなければなりません。
%         主問題、双対問題、あるいは両方のいずれかが可解であるという
%         メッセージが適切に与えられます。主問題の標準的な形式は、
%         以下のとおりです。
%              A*x = b, x >= 0 のもとで、f'*x を最小化します。
%         双対問題は、以下の形式になります。
%              A'*y + s = f, s >= 0 のもとで、b'*y を最大化します。
%
%   参考 QUADPROG.


%   Copyright 1990-2008 The MathWorks, Inc.
