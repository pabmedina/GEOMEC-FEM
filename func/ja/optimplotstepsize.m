% OPTIMPLOTSTEPSIZE  �e�J��Ԃ��ŃX�e�b�v�T�C�Y���v���b�g
%
%   STOP = OPTIMPLOTSTEPSIZE(X,OPTIMVALUES,STATE) �́AOPTIMVALUES.stepsize 
%   ���v���b�g���܂��B
%
%   ��:
%   �v���b�g�֐��Ƃ��� OPTIMPLOTSTEPSIZE ���g�p����I�v�V�����\���̂�
%   �쐬���܂��B
%     options = optimset('PlotFcns',@optimplotstepsize);
%
%   �v���b�g��\�����邽�߂� options ���œK�����ɓn���܂��B
%      fmincon(@(x) 3*sin(x(1))+exp(x(2)),[1;1],[],[],[],[],[0 0],[],[],options)


%   Copyright 2006-2008 The MathWorks, Inc.
