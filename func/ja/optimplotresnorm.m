% OPTIMPLOTRESNORM  �e�J��Ԃ��Ŏc���̃m�����̒l���v���b�g
%
%   STOP = OPTIMPLOTRESNORM(X,OPTIMVALUES,STATE) �́AOPTIMVALUES.resnorm ��
%   �v���b�g���܂��B
%
%   ��:
%   �v���b�g�֐��Ƃ��� OPTIMPLOTRESNORM ���g�p����I�v�V�����\���̂�
%   �쐬���܂��B
%     options = optimset('PlotFcns',@optimplotresnorm);
%
%   �v���b�g��\�����邽�߂� options ���œK�����ɓn���܂��B
%     lsqnonlin(@(x) sin(3*x),[1 4],[],[],options);


%   Copyright 2006-2008 The MathWorks, Inc.
