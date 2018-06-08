%BINTPROG  0-1 整数計画問題
%
%   BINTPROG は、0-1 整数計画問題を解きます。
%   以下の制約のもとで、f'*X を X に関して最小化します。  
%                A*X <= b,
%                Aeq*X = beq,
%                ここで、X の要素は 2 値整数、すなわち 0 か 1 です。
%
%   X = BINTPROG(f) は、 f'*X を最小化する問題を解きます。ここで、X の
%   要素は、0-1 の整数です。
%
%   X = BINTPROG(f,A,b) は、線形不等式 A*X <= b のもとで、f'*X を最小化する
%   問題を解きます。ここで、X の要素は、0-1 の整数です。
%
%   X = BINTPROG(f,A,b,Aeq,beq) は、線形等式 Aeq*X = beq と線形不等式 
%   A*X <= b のもとで f'*X を最小化する問題を解きます。ここで、X の要素は、
%   0-1 の整数です。
%
%   X = BINTPROG(f,A,b,Aeq,beq,X0) は、初期値を X0 に設定します。初期値 X0 
%   は、2 値整数で、かつ可解でなければなりません。そうでない場合、無視されます。
%
%   X = BINTPROG(f,A,b,Aeq,beq,X0,OPTIONS) は、オプション (OPTIONS) を設定
%   して実行できます。ここで、OPTIONS は OPTIMSET 関数で設定できる構造体です。
%   詳細は、OPTIMSET を参照してください。BranchStrategy, Diagnostics, Display, 
%   NodeDisplayInterval, MaxIter, MaxNodes, MaxRLPIter, MaxTime, 
%   NodeSearchStrategy, TolFun, TolXInteger, TolRLPFun のオプションが
%   使用できます。
%
%   X = BINTPROG(PROBLEM) は、PROBLEM に対する最小値を求めます。PROBLEM は、
%   PROBLEM.f にベクトル 'f'、 PROBLEM.Aineq と PROBLEM.bineq に線形不等式制約、
%   PROBLEM.Aeq と PROBLEM.beq に線形等式制約、PROBLEM.x0 に開始点、
%   PROBLEM.options にオプション構造体、PROBLEM.solver にソルバ名 'bintprog' 
%   を持つ構造体です。OPTIMTOOL からエクスポートした問題をコマンドラインで
%   解くには、このシンタックスを使用してください。構造体 PROBLEM は、
%   これらのすべてのフィールドを持たなければなりません。
%
%   [X,FVAL] = BINTPROG(...) は、解 X における目的関数の値 FVAL = f'*X を
%   戻します。 
%
%   [X,FVAL,EXITFLAG] = BINTPROG(...) は、BINTPROG の終了状況を示す文字列 
%   EXITFLAG を返します。EXITFLAG の可能な値と対応する終了状況は、次の
%   とおりです。
%
%      1  BINTPROG は、解 X に収束したことを示します。
%      0  繰り返し回数が最大回数に達していることを示します。
%     -2  問題が不可解であることを示します。
%     -4  収束することなく MaxNodes に達したことを示します。
%     -5  収束することなく MaxTime に達したことを示します。
%     -6  LP 緩和問題を解くためのノードで実行された繰り返し回数が、
%         となく MaxRLPIter に達したことを示します。
%
%   [X,FVAL,EXITFLAG,OUTPUT] = BINTPROG(...) は、繰り返し数 OUTPUT.iterations、
%   探索したノードの数 OUTPUT.nodes、実行時間 (秒単位) OUTPUT.time、使用した
%   アルゴリズム OUTPUT.algorithm、分岐法 OUTPUT.branchStrategy、ノード検索
%   方法 OUTPUT.nodeSrchStrategy、終了メッセージ OUTPUT.message を持つ構造体 
%   OUTPUT を返します。
%
%   例
%     f = [-9; -5; -6; -4];
%     A = [6 3 5 2; 0 0 1 1; -1 0 1 0; 0 -1 0 1];
%     b = [9; 1; 0; 0];
%     X = bintprog(f,A,b)
%
% 参考 LINPROG.


%   Copyright 1990-2008 The MathWorks, Inc.
