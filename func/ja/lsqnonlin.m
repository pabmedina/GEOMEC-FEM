%LSQNONLIN  ����`�ŏ������
%
%   LSQNONLIN �́A�ȉ��̌`���̖��������܂��B
%   sum {FUN(X).^2} ���AX �Ɋւ��čŏ������܂��B
%   �����ŁAX �Ɗ֐� FUN �ŕԂ����l�́AX �̃x�N�g���܂��͍s��ł��B
%
%   X = LSQNONLIN(FUN,X0) �́AX0 �������l�Ƃ��āA�֐� FUN �ɋL�q�����֐���
%   ���a���ŏ������� X �����߂܂��B�֐� FUN �́AX ����͂Ƃ��āAX �Ōv�Z
%   �����x�N�g�� (�܂��͍s��) �̊֐��l F ��Ԃ��܂��B
%   ���ӁFFUN �́AFUN(X) ��Ԃ��Asum(FUN(X).^2)) �ŕ\�������a�ł͂���܂���B
%   (FUN(X) �́A�A���S���Y�����ňÖٓI�ɓ��a���s���܂��B)
%
%   X = LSQNONLIN(FUN,X0,LB,UB) �́A�݌v�ϐ� X �̏㉺���͈̔͂�^���邱�Ƃ�
%   �\�ł��B���̏ꍇ�ALB <= X <= UB �͈̔͂ōœK�����T������܂��B�͈͂�
%   ���񂪂Ȃ��ꍇ�ALB �� UB �ɋ�s���ݒ肵�Ă��������BX(i) �ɉ������Ȃ��ꍇ�A
%   LB(i) = -Inf �Ɛݒ肵�AX(i) �ɏ�����Ȃ��ꍇ�AUB(i) = Inf �Ɛݒ肵�Ă��������B
%
%   X = LSQNONLIN(FUN,X0,LB,UB,OPTIONS) �́A�I�v�V���� (OPTIONS) ��ݒ肵��
%   ���s�ł��܂��B������ OPTIONS �� OPTIMSET �֐��Őݒ�ł���\���̂ł��B
%   �ڍׂ́AOPTIMSET ���Q�Ƃ��Ă��������BDisplay, TolX, TolFun, DerivativeCheck, 
%   Diagnostics, FunValCheck, Jacobian, JacobMult, JacobPattern, 
%   LineSearchType, LevenbergMarquardt, MaxFunEvals, MaxIter, DiffMinChange, 
%   DiffMaxChange, LargeScale, MaxPCGIter, PrecondBandWidth, TolPCG, TypicalX, 
%   PlotFcns, OutputFcn �̃I�v�V�������g�p�ł��܂��B�I�v�V���� Jacobian ��
%   �g���� FUN ���Ăяo���A2 �Ԗڂ̏o�͈��� J �ɁA�_ X �ł̃��R�r�s���ݒ�
%   �ł��܂��BFUN �́AX ������ n �̂Ƃ��ɁAm �v�f�̃x�N�g�� F ���Ԃ����ꍇ�A
%   J �́Am �s n ��̍s��ɂȂ�܂��B�����ŁAJ(i,j) �́AF(i) �� x(j) �ɂ��
%   �Δ����W���ł� (���R�r�s�� J �́AF �̌��z��]�u�������̂ł�)�B
%
%   X = LSQNONLIN(PROBLEM) �́APROBLEM �Œ�`���ꂽ����`�ŏ������������܂��B
%   PROBLEM �́APROBLEM.objective �Ɋ֐� FUN�APROBLEM.x0 �ɊJ�n�_�APROBLEM.lb ��
%   �����APROBLEM.ub �ɏ���APROBLEM.options �ɃI�v�V�����\���́APROBLEM.solver 
%   �Ƀ\���o�� 'lsqnonlin' �����\���̂ł��BOPTIMTOOL ����G�N�X�|�[�g����
%   �����R�}���h���C���ŉ����ɂ́A���̃V���^�b�N�X���g�p���Ă��������B
%   �\���� PROBLEM �́A�����̂��ׂẴt�B�[���h�������Ȃ���΂Ȃ�܂���B
%
%   [X,RESNORM] = LSQNONLIN(FUN,X0,...) �́AX �ł̎c���� 2 �m���� 
%   sum(FUN(X).^2) ��Ԃ��܂��B
%
%   [X,RESNORM,RESIDUAL] = LSQNONLIN(FUN,X0,...) �́A�� X �ł̎c���l 
%   RESIDUAL = FUN(X) ��Ԃ��܂��B
%
%   [X,RESNORM,RESIDUAL,EXITFLAG] = LSQNONLIN(FUN,X0,...) �́ALSQNONLIN ��
%   �I���󋵂����������� EXITFLAG ��Ԃ��܂��BEXITFLAG �̉\�Ȓl�ƑΉ�����
%   �I���󋵂́A���̂Ƃ���ł��B
%
%     1  LSQNONLIN �́A�� X �Ɏ����������Ƃ������܂��B
%     2  X �̕ω����w�肵�����e�͈͂�菬�������Ƃ������܂��B
%     3  �ړI�֐��l�̕ω����w�肵�����e�͈͂�菬�������Ƃ������܂��B
%     4  �T�������̑傫�����w�肵�����e�덷��菬�������Ƃ������܂��B
%     0  �֐��v�Z�̉񐔁A���邢�͌J��Ԃ��񐔂��ő�񐔂ɒB���Ă��邱�Ƃ�
%        �����܂��B
%    -1  �œK�����A�o�͊֐��ŏI�����Ă��邱�Ƃ������܂��B
%    -2  ���E���������Ă��邱�Ƃ������܂��B
%    -4  ���C���T���́A���݂̒T�������ɉ����ď\���Ɏc���������ł��Ȃ����Ƃ�
%        �����܂��B
%
%   [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT] = LSQNONLIN(FUN,X0,...) �́A�J��Ԃ�
%   �� OUTPUT.iterations�A�֐��̕]���� OUTPUT.funcCount�A�g�p�����A���S���Y�� 
%   OUTPUT.algorithm�A(�g�p�����ꍇ) �������z�J��Ԃ��� OUTPUT.cgiterations�A
%   (�g�p�����ꍇ) 1 ���̍œK�� OUTPUT.firstorderopt�A�I�����b�Z�[�W 
%   OUTPUT.message �����\���� OUTPUT ��Ԃ��܂��B
%
%   [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = LSQNONLIN(FUN,X0,...) �́A
%   ���ł̃��O�����W�F�搔 LAMBDA ��Ԃ��܂��BLAMBDA.lower �� LB ���A
%   LAMBDA.upper �� UB ��ݒ肵�Ă��܂��B
%
%   [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN] = LSQNONLIN(FUN,X0,...) 
%   �́AX �ł̊֐� FUN �̃��R�r�s���Ԃ��܂��B
%
%   ��
%     FUN �́A@ ���g���Ďw�肷�邱�Ƃ��ł��܂��B
%        x = lsqnonlin(@myfun,[2 3 4])
%
%   �����ŁAmyfun �́A�ȉ��̂悤�ɕ\����� MATLAB �֐��ł��B
%
%       function F = myfun(x)
%       F = sin(x);
%
%   FUN �́A�����֐��ɂ��邱�Ƃ��ł��܂��B
%
%       x = lsqnonlin(@(x) sin(3*x),[1 4])
%
%   FUN ���p�����[�^�����ꂽ�ꍇ�A���Ɉˑ������p�����[�^���w�肵�Ė����֐�
%   ���g�p�ł��܂��B2 �Ԗڂ̈��� c �Ńp�����[�^�����ꂽ�֐� myfun ���ŏ���
%   ����Ɖ��肵�܂��B�����ŁAmfun �͈ȉ��̂悤�� M-�t�@�C���֐��ł��B
%
%       function F = myfun(x,c)
%       F = [ 2*x(1) - exp(c*x(1))
%             -x(1) - exp(c*x(2))
%             x(1) - x(2) ];
%
%   c �̎w��l�ɑ΂��čœK������ɂ́A�ŏ��� c �ɐݒ肵�܂��B���̌�Ac �̒l��
%   ������ 1 �̈������������֐����쐬���A2 �̈������������֐����Ăяo��
%   �܂��B�Ō�ɁA���̖����֐��� LSQNONLIN �ɓn���܂��B
%
%       c = -1; % �ŏ��Ƀp�����[�^���`���܂��B
%       x = lsqnonlin(@(x) myfun(x,c),[1;1])
%
%   �Q�l OPTIMSET, LSQCURVEFIT, FSOLVE, @, INLINE.


%   Copyright 1990-2008 The MathWorks, Inc.
