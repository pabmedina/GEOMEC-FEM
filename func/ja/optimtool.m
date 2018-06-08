%OPTIMTOOL  Optimization Toolbox のグラフィカルユーザインタフェース
%
%   OPTIMTOOL は、MATLAB、Optimization Toolbox、また、ライセンスが利用可能で
%   あれば、Genetic Algorithm and Direct Search Toolbox から最適化のソルバの
%   グラフィカルユーザインタフェースを開始します。OPTIMTOOL は、デフォルト
%   オプションの編集、ソルバの選択と実行のために使用することができます。
%
%   OPTIMTOOL(INPUTARG) は、INPUTARG で Optimization Tool を開始します。
%   INPUTARG は、最適化オプション構造体、または、最適化問題の構造体のいずれかに
%   なります。オプション構造体は、OPTIMSET を使用するか、OPTIMTOOL から
%   エクスポートオプションを使用することで作成することができます。
%   オプションの作成についての詳細は、OPTIMSET を参照してください。
%   問題の構造体は、OPTIMTOOL で作成して MATLAB ワークスペースにエクスポート
%   することができます。INPUTARG は、最適化ソルバ名 (文字列) にもできます。
%   OPTIMTOOL は、デフォルトオプションとソルバ INPUTARG に対する problem 
%   フィールドを表示します。
%
%   MATLAB ワークスペースから OPTIMTOOL へ最適化オプション構造体をインポート
%   して、OPTIMTOOL 内で修正することができます。OPTIMTOOL から MATLAB 
%   ワークスペースへ最適化構造体をエクスポートすることもできます。
%   MATLAB ワークスペースから OPTIMTOOL へ問題の構造体をインポートすることも
%   可能です。OPTIMTOOL から MATLAB ワークスペースへ問題の構造体をエクスポート
%   することが可能です。問題の構造体の各フィールドの詳しい説明については、
%   最適化ソルバのヘルプを参照してください。
%
%   OPTIMTOOL は、問題を設定した後に、すべての最適化ソルバを実行するために
%   使用することができます。MATLAB ワークスペースに結果の構造体として、
%   たとえば X と FVAL 等エクスポートすることができます。
%
%   参考 OPTIMSET.


%   Copyright 2006-2009 The MathWorks, Inc.
