% OPTIMPLOTFIRSTORDEROPT  �e�J��Ԃ��� 1 ���̍œK�����v���b�g
%
%   STOP = OPTIMPLOTFIRSTORDEROPT(X,OPTIMVALUES,STATE) �́A
%   OPTIMVALUES.firstorderopt ���v���b�g���܂��B
%
%   ��:
%   �v���b�g�֐��Ƃ��� OPTIMPLOTFIRSTORDEROPT ���g�p����I�v�V�����\���̂�
%   �쐬���܂��B
%     options = optimset('PlotFcns',@optimplotfirstorderopt);
%
%   �v���b�g��\�����邽�߂� options ���œK�����ɓn���܂��B
%      fmincon(@(x) 3*sin(x(1))+exp(x(2)),[1;1],[],[],[],[],[0 0],[],[],options)


%   Copyright 2006-2008 The MathWorks, Inc.
