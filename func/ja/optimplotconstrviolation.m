% OPTIMPLOTCONSTRVIOLATION  �e�J��Ԃ��ōő�̐���ᔽ���v���b�g
%
%   STOP = OPTIMPLOTCONSTRVIOLATION(X,OPTIMVALUES,STATE) �́A
%   OPTIMVALUES.constrviolation ���v���b�g���܂��B
%
%   ��:
%   �v���b�g�֐��Ƃ��� OPTIMPLOTCONSTRVIOLATION ���g�p����I�v�V����
%   �\���̂��쐬���܂��B
%     options = optimset('PlotFcns',@optimplotconstrviolation);
%
%   �v���b�g��\�����邽�߂� options ���œK�����ɓn���܂��B
%      fmincon(@(x) 3*sin(x(1))+exp(x(2)),[1;1],[],[],[],[],[0 0],[],[],options)


%   Copyright 2006-2008 The MathWorks, Inc.
