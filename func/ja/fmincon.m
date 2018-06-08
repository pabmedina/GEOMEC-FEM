%FMINCON  ����t�����ϐ��֐��̍ŏ���
%
%   FMINCON �́A�ȉ��̌`���̖��������܂��B
%   ���̐���̂��ƂŁAF(X) ���AX �Ɋւ��čŏ������܂��B
%       A*X  <= B, Aeq*X  = Beq (���`����)
%       C(X) <= 0, Ceq(X) = 0   (����`����)
%       LB <= X <= UB           (�͈�)
%
%   X = FMINCON(FUN,X0,A,B) �́A���� X0 �l�ŁA���`�s�������� A*X <= B ��
%   ���ƂŁA�֐� FUN ���ŏ������� X �����߂܂��BFUN �́AX ����͂Ƃ��āA
%   X �Ōv�Z�����X�J���̊֐��l F ��Ԃ��܂��BX0 �́A�X�J���A�x�N�g���A
%   �܂��́A�s��ł��B
%
%   X = FMINCON(FUN,X0,A,B,Aeq,Beq) �́AA*X <= B �Ɠ��l�ɐ��`�������� 
%   Aeq*X = Beq ���l������ FUN ���ŏ������܂� (�s�������񂪂Ȃ��ꍇ�́A
%   A=[], B=[] �Ɛݒ肵�܂�)�B
%
%   X = FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB) �́A�݌v�ϐ� X �̏㉺���͈̔͂�
%   �^���邱�Ƃ��\�ł��B���̏ꍇ�ALB <= X <= UB �͈͓̔��ōœK�����T������܂��B
%   �͈͂̐��񂪂Ȃ��ꍇ�ALB �� UB �ɋ�s���ݒ肵�Ă��������BX(i) �� ������
%   �Ȃ��ꍇ�ALB(i) = -Inf �Ɛݒ肵�AX(i) �ɏ�����Ȃ��ꍇ�AUB(i) = Inf ��
%   �ݒ肵�Ă��������B
%
%   X = FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON) �́ANONLCON �Œ�`���ꂽ
%   ����̂��Ƃōŏ������܂��B�����Ŋ֐� NONLCON �́AX ����͂Ƃ��āA
%   ����`�s�����Ɣ���`������\�킷 C �� Ceq �x�N�g����Ԃ��܂��B
%   FMINCON �́AC(X) <= 0 �� Ceq(X) = 0 �ƂȂ� FUN ���ŏ������܂�
%   (�͈͂̐��񂪂Ȃ��ꍇ�ALB=[] �� UB=[] �Ƃ��Đݒ肵�Ă�������)�B
%
%   X = FMINCON(FUN,X0,A,B,Aeq,Beq,LB,UB,NONLCON,OPTIONS) �́A�I�v�V���� 
%   (OPTIONS) ��ݒ肵�Ď��s�ł��܂��B�����ŁAOPTIONS �� OPTIMSET �֐���
%   �ݒ�ł���\���̂ł��B�ڍׂ́AOPTIMSET ���Q�Ƃ��Ă��������BFMINCON ��
%   �w��ł���I�v�V�����̃��X�g�ɂ��ẮAOptimization Toolbox ��
%   �}�j���A�����Q�Ƃ��Ă��������B
%
%   X = FMINCON(PROBLEM) �́APROBLEM �ɑ΂���ŏ��l�����߂܂��BPROBLEM �́A
%   PROBLEM.objective �Ɋ֐� FUN�APROBLEM.x0 �ɊJ�n�_�APROBLEM.Aineq �� 
%   PROBLEM.bineq �ɐ��`�s��������APROBLEM.Aeq �� PROBLEM.beq �ɐ��`��������A
%   PROBLEM.lb �ɉ����APROBLEM.ub �ɏ���APROBLEM.nonlcon �ɔ���`����֐��A
%   PROBLEM.options �ɃI�v�V�����\���́APROBLEM.solver �Ƀ\���o�� 'fmincon' ��
%   ���\���̂ł��BOPTIMTOOL ����G�N�X�|�[�g���������R�}���h���C���ŉ����ɂ́A
%   ���̃V���^�b�N�X���g�p���Ă��������B�\���� PROBLEM �́A�����̂��ׂĂ�
%   �t�B�[���h�������Ȃ���΂Ȃ�܂���B
%
%   [X,FVAL] = FMINCON(FUN,X0,...) �́A�� X �ł̖ړI�֐� FUN �̒l��Ԃ��܂��B
%
%   [X,FVAL,EXITFLAG] = FMINCON(FUN,X0,...) �́AFMINCON �̏I���󋵂�����
%   ������ EXITFLAG ��Ԃ��܂��BEXITFLAG �̉\�Ȓl�ƑΉ�����I���󋵂�
%   �ȉ��Ɉꗗ�\�����܂��B
%
%   ���ׂẴA���S���Y��:
%     1  1 ���̍œK�������w�肵�����e�͈͂𖞑����Ă��邱�Ƃ������܂��B
%     0  �֐��v�Z�̉񐔁A���邢�͌J��Ԃ��񐔂��ő�񐔂ɒB���Ă��邱�Ƃ�
%        �����܂��B
%    -1  �œK�����A�o�͊֐��ŏI�����Ă��邱�Ƃ������܂��B
%    -2  ����������Ȃ��������Ƃ������܂��B
%   trust-region-reflective �@�Ɠ��_�@:
%     2  X �̕ω����w�肵�����e�͈͂�菬�������Ƃ������܂��B
%   trust-region-reflective �@:
%     3  �ړI�֐��l�̕ω����w�肵�����e�͈͂�菬�������Ƃ������܂��B
%   �A�N�e�B�u�ݒ�̂�:
%     4  �T�������̑傫�����w�肵�����e�덷��菬�����A����ᔽ�� 
%        options.TolCon ��菬�������Ƃ������܂��B
%     5  �T�������ɉ������֐��̌��z�̑傫�������e�͈͂�菬�����A
%        ����ᔽ�� options.TolCon ��菬�������Ƃ������܂��B
%   ���_�@:
%    -3  ��肪�͈͊O�ŕ\��܂����B
%
%   [X,FVAL,EXITFLAG,OUTPUT] = FMINCON(FUN,X0,...) �́A�J��Ԃ��̑��񐔂�
%   �Ō�̖ړI�֐��l�̂悤�ȏ������\���� OUTPUT ��Ԃ��܂��B���S��
%   ���X�g�ɂ��Ă̓h�L�������e�[�V�������Q�Ƃ��Ă��������B
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = FMINCON(FUN,X0,...) �́A���ł̃��O�����W�F
%   �搔 LAMBDA ��Ԃ��܂��BLAMBDA �\���̂́ALAMBDA.lower �� LB ���ALAMBDA.upper 
%   �� UB ���ALAMBDA.ineqlin �ɐ��`�s�������ALAMBDA.eqlin �ɐ��`�������A
%   LAMBDA.ineqnonlin �ɔ���`�s�������ALAMBDA.eqnonlin �ɔ���`������ݒ肵�܂��B
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA,GRAD] = FMINCON(FUN,X0,...) �́A�� X �ł�
%   �֐� FUN �̌��z�l���Ԃ��܂��B
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA,GRAD,HESSIAN] = FMINCON(FUN,X0,...) �� 
%   �� X �ł̃��O�����W�F�̐��m�ȁA�܂��́A�ߎ��̃w�b�Z�s��̒l��Ԃ��܂��B
%
%   ��
%     FUN �́A@ ���g���Ďw�肷�邱�Ƃ��ł��܂��B:
%        X = fmincon(@humps,...)
%     ���̏ꍇ�AF = humps(X) �́AX �ł� HUMPS �֐��̃X�J���֐��l F ��Ԃ��܂��B
%
%     FUN �́A�����֐��ɂ��邱�Ƃ��ł��܂��B
%        X = fmincon(@(x) 3*sin(x(1))+exp(x(2)),[1;1],[],[],[],[],[0 0])
%     �́AX = [0;0] ��Ԃ��܂��B
%
%   FUN �܂��� NONLCON ���p�����[�^�����ꂽ�ꍇ�A���Ɉˑ������p�����[�^��
%   �w�肵�Ė����֐����g�p�ł��܂��B�֐� myfun ���ŏ�������Ɖ��肵�A�܂� 
%   ����`������� mycon ���l�����܂��B�����ŁA������ 2 �̊֐��� 2 �Ԗڂ�
%   ���� a1 �� a2 �ł��ꂼ��p�����[�^������܂��B�����ŁAmyfun �� mycon ��
%   ���̂悤�� M-�t�@�C���֐��ł��B
%
%        function f = myfun(x,a1)
%        f = x(1)^2 + a1*x(2)^2;
%
%        function [c,ceq] = mycon(x,a2)
%        c = a2/x(1) - x(2);
%        ceq = [];
%
%   �w�肳�ꂽ a1 �� a2 �ɑ΂��čœK�����s�Ȃ��ɂ́A�܂��A�����̃p�����[�^
%   ��ݒ肵�܂��B�����āAa1 �� a2 �� 1 �̈����Ƃ��閳���֐��� 2 ��`
%   ���܂��B�ŏI�I�ɁA�����̖����֐��� FMINCON �ɓn���܂��B
%
%        a1 = 2; a2 = 1.5; % �ŏ��Ƀp�����[�^���`���܂��B
%        options = optimset('Algorithm','active-set'); % �A�N�e�B�u�ݒ肳�ꂽ�A���S���Y�������s
%        x = fmincon(@(x) myfun(x,a1),[1;2],[],[],[],[],[],[],@(x) mycon(x,a2),options)
%
%   �Q�l OPTIMSET, OPTIMTOOL, FMINUNC, FMINBND, FMINSEARCH, @, FUNCTION_HANDLE.


%   Copyright 1990-2008 The MathWorks, Inc.
