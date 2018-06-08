%FMINCON  ���ϐ��֐��̋ɏ���
%
%   X = FMINUNC(FUN,X0) �́AX0 �Ŏn�܂�A�֐� FUN �̋Ǐ��I�ȍŏ��_ X ��
%   �����悤�Ƃ��܂��BFUN �́AX ����͂Ƃ��āAX �Ōv�Z�����X�J����
%   �֐��l F ��Ԃ��܂��BX0 �́A�X�J���A�x�N�g���A�܂��́A�s��ł��B
%
%   X = FMINUNC(FUN,X0,OPTIONS) �́A�I�v�V���� (OPTIONS) ��ݒ肵�Ď��s
%   �ł��܂��B������ OPTIONS �� OPTIMSET �֐��Őݒ�ł���\���̂ł��B
%   �ڍׂ́AOPTIMSET ���Q�Ƃ��Ă��������BDisplay, TolX, TolFun, DerivativeCheck, 
%   Diagnostics, FunValCheck, GradObj, HessPattern, Hessian, HessMult, 
%   HessUpdate, InitialHessType, InitialHessMatrix, MaxFunEvals, MaxIter, 
%   DiffMinChange, DiffMaxChange, LargeScale, MaxPCGIter, PrecondBandWidth, 
%   TolPCG, PlotFcns, OutputFcn, TypicalX �̃I�v�V�������g�p�ł��܂��B
%   GradObj �I�v�V�������g���āAFUN ���Ăяo���A2 �Ԗڂ̏o�͈��� G �ɓ_ 
%   X �ł̕Δ����W�� df/dX ��ݒ�ł��܂��B�I�v�V���� Hessian ���g���āA
%   FUN ���Ăяo���A3 �Ԗڂ̈��� H �ɓ_ X �ł̃w�b�Z�s�� (2 �K����) ��
%   �ݒ�ł��܂��BHessian �́A��K�͖��ł̂ݎg���A���C���T���@�ł�
%   �g���܂���B
%
%   X = FMINUNC(PROBLEM) �́APROBLEM �ɑ΂���ŏ��l�����߂܂��BPROBLEM �́A
%   PROBLEM.objective �Ɋ֐� FUN�APROBLEM.x0 �ɊJ�n�_�APROBLEM.options ��
%   �I�v�V�����\���́APROBLEM.solver �Ƀ\���o�� 'fminunc' �����\���̂ł��B
%   OPTIMTOOL ����G�N�X�|�[�g���������R�}���h���C���ŉ����ɂ́A���̃V���^�b�N�X
%   ���g�p���Ă��������B�\���� PROBLEM �́A�����̂��ׂẴt�B�[���h��
%   �����Ȃ���΂Ȃ�܂���B
%
%   [X,FVAL] = FMINUNC(FUN,X0,...) �́A�� X �ł̖ړI�֐� FUN �̒l��Ԃ��܂��B
%
%   [X,FVAL,EXITFLAG] = FMINUNC(FUN,X0,...) �́AFMINUNC �̏I���󋵂���������
%   ��  EXITFLAG ��Ԃ��܂��BEXITFLAG �̉\�Ȓl�ƑΉ�����I���󋵂́A
%   ���̂Ƃ���ł��B
%
%     1  ���z�̑傫�����w�肵�����e�͈͂�菬�������Ƃ������܂��B
%     2  X �̕ω����w�肵�����e�͈͂�菬�������Ƃ������܂��B
%     3  �ړI�֐��l�̕ω����w�肵�����e�͈͂�菬�������Ƃ������܂� 
%        (��K�͖��̂�)�B
%     0  �֐��v�Z�̉񐔁A���邢�͌J��Ԃ��񐔂��ő�񐔂ɒB���Ă��邱�Ƃ�
%        �����܂��B
%    -1  �œK�����A�o�͊֐��ŏI�����Ă��邱�Ƃ������܂��B
%    -2  ���C���T�����A���݂̒T�������ɉ����Ď󂯓���\�ȓ_������
%        ���Ȃ����Ƃ������܂� (���K�͖��̂�)�B
%
%   [X,FVAL,EXITFLAG,OUTPUT] = FMINUNC(FUN,X0,...) �́A�J��Ԃ��� 
%   OUTPUT.iterations�A�֐��̕]���� OUTPUT.funcCount�A�g�p�����A���S���Y�� 
%   OUTPUT.algorithm�A(�g�p�����ꍇ) �������z�J��Ԃ��� OUTPUT.cgiterations�A
%   (�g�p�����ꍇ) 1 ���̍œK�� OUTPUT.firstorderopt�A�I�����b�Z�[�W 
%   OUTPUT.message �����\���� OUTPUT ��Ԃ��܂��B
%
%   [X,FVAL,EXITFLAG,OUTPUT,GRAD] = FMINUNC(FUN,X0,...) �́A�� X �ł̊֐� 
%   FUN �̌��z�l��Ԃ��܂��B
%
%   [X,FVAL,EXITFLAG,OUTPUT,GRAD,HESSIAN] = FMINUNC(FUN,X0,...) �́A
%   �� X �ł̖ړI�֐� FUN �̃w�b�Z�s���Ԃ��܂��B
%
%   ��
%     FUN �́A@ ���g���Ďw�肷�邱�Ƃ��ł��܂��B
%        X = fminunc(@myfun,2)
%
%   �����ŁAmyfun �́A�ȉ��̂悤�ɕ\����� MATLAB �֐��ł��B
%
%       function F = myfun(x)
%       F = sin(x) + 3;
%
%     �^����ꂽ���z���g���Ċ֐����ŏ������邽�߂ɁA���z�� 2 �Ԗڂ̈����ƂȂ�
%     �悤�ɁA�֐� myfun ���C�����܂��B
%        function [f,g] = myfun(x)
%         f = sin(x) + 3;
%         g = cos(x);
%     �����āA(OPTIMSET ���g����) OPTIONS.GradObj �� 'on' �ɐݒ肵�A���z��
%     �g�p�ł���悤�ɂ��܂��B
%        options = optimset('GradObj','on');
%        x = fminunc(@myfun,4,options);
%
%     FUN �́A�����֐��ɂ��邱�Ƃ��ł��܂��B
%        x = fminunc(@(x) 5*x(1)^2 + x(2)^2,[5;1])
%
%   FUN ���p�����[�^�����ꂽ�ꍇ�A���Ɉˑ������p�����[�^���w�肵�Ė����֐�
%   ���g�p�ł��܂��B2 �Ԗڂ̈��� c �Ńp�����[�^�����ꂽ�֐� myfun ���ŏ���
%   ����Ɖ��肵�܂��B�����ŁAmfun �͈ȉ��̂悤�� M-�t�@�C���֐��ł��B
%
%     function [f,g] = myfun(x,c)
%
%     f = c*x(1)^2 + 2*x(1)*x(2) + x(2)^2; % �֐�
%     g = [2*c*x(1) + 2*x(2)               % ���z
%          2*x(1) + 2*x(2)];
%
%   c �̎w��l�ɑ΂��čœK�����邽�߂ɂ́A�ŏ��� c �ɐݒ肵�܂��B���̌�Ac ��
%   �l�𑨂��� 1 �̈������������֐����쐬���A2 �̈������������֐���
%   �Ăяo���܂��B�ŏI�I�ɁA�����֐��� FMINUNC �ɓn���܂��B
%
%     c = 3; % �ŏ��Ƀp�����[�^���`���܂��B
%     options = optimset('GradObj','on'); % ���z���w�����܂��B
%     x = fminunc(@(x) myfun(x,c),[1;1],options)
%
%   �Q�l OPTIMSET, FMINSEARCH, FMINBND, FMINCON, @, INLINE.


%   Copyright 1990-2008 The MathWorks, Inc.
