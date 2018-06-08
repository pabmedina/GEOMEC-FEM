%LSQLIN  ����t�����`�ŏ������
%
%   X = LSQLIN(C,d,A,b) �́A�ȉ��̌`���̕s�����̐�������t���ŏ�������
%   �����܂��B
%
%           A*x <=  b �̂��Ƃ� 0.5*(NORM(C*x-d)).^2 �� x �Ɋւ��āA�ŏ������܂��B
%
%   �����ŁAC �� m x n �ł��B
%
%   X = LSQLIN(C,d,A,b,Aeq,beq) �́A�ȉ��̌`���� (�����̐���t��) �ŏ����
%   ���������܂��B
%
%           A*x <=  b �� Aeq*X = Beq �̂��Ƃ� 0.5*(NORM(C*x-d)).^2 �� 
%           x �Ɋւ��āA�ŏ������܂��B
%
%   X = LSQLIN(C,d,A,b,Aeq,beq,LB,UB) �́A�݌v�ϐ� X �̏㉺���͈̔͂�^����
%   ���Ƃ��\�ł��B���̏ꍇ�ALB <= X <= UB �͈͓̔��ōœK�����T������܂��B
%   �͈͂̐��񂪂Ȃ��ꍇ�ALB �� UB �ɋ�s���ݒ肵�Ă��������BX(i) �ɉ�����
%   �Ȃ��ꍇ�ALB(i) = -Inf �Ɛݒ肵�AX(i) �ɏ�����Ȃ��ꍇ�AUB(i) = Inf ��
%   �ݒ肵�Ă��������B
%
%   X = LSQLIN(C,d,A,b,Aeq,beq,LB,UB,X0) �́AX0 ���J�n�_�Ƃ��Đݒ肵�܂��B
%
%   X = LSQLIN(C,d,A,b,Aeq,beq,LB,UB,X0,OPTIONS) �́A�f�t�H���g�̍œK��
%   �p�����[�^�̑���ɁA�֐� OPTIMSET �ō쐬���ꂽ OPTIONS �\���̂̒l��
%   �g���čŏ������s���܂��B�ڍׂ́AOPTIMSET ���Q�Ƃ��Ă��������BDisplay, 
%   Diagnostics, TolFun, LargeScale, MaxIter, JacobMult, PrecondBandWidth, 
%   TypicalX, TolPCG, MaxPCGIter �̃I�v�V�������g�p���邱�Ƃ��ł��܂��B
%   'final' �� 'off' �݂̂� Display �ɑ΂��Ďg���܂� ('iter' �͎g�p�ł��܂���)�B
%
%   X = LSQLIN(PROBLEM) �́APROBLEM �Œ�`���ꂽ�ŏ������������܂��B
%   PROBLEM �́APROBLEM.C �ɍs�� 'C'�APROBLEM.d �Ƀx�N�g�� 'd'�APROBLEM.Aineq 
%   �� PROBLEM.bineq �ɐ��`�s��������APROBLEM.Aeq �� PROBLEM.beq �ɐ��`��������A
%   PROBLEM.lb �ɉ����APROBLEM.ub �ɏ���APROBLEM.x0 �ɊJ�n�_�APROBLEM.options ��
%   �I�v�V�����\���́APROBLEM.solver �Ƀ\���o�� 'lsqlin' �����\���̂ł��B
%   OPTIMTOOL ����G�N�X�|�[�g���������R�}���h���C���ŉ����ɂ́A����
%   �V���^�b�N�X���g�p���Ă��������B�\���� PROBLEM �ɂ́A�����̂��ׂĂ�
%   �t�B�[���h���Ȃ���΂Ȃ�܂���B
%
%   [X,RESNORM] = LSQLIN(C,d,A,b) �́A�c���̓�� 2 �m�����l norm(C*X-d)^2 ��
%   �Ԃ��܂��B
%
%   [X,RESNORM,RESIDUAL] = LSQLIN(C,d,A,b) �́A�c�� C*X-d ��Ԃ��܂��B
%
%   [X,RESNORM,RESIDUAL,EXITFLAG] = LSQLIN(C,d,A,b) �́ALSQLIN �̏I���󋵂�
%   ���������� EXITFLAG ��Ԃ��܂��BEXITFLAG �̉\�Ȓl�ƑΉ�����I���󋵂́A
%   �ȉ��̂Ƃ���ł��B
%
%     1  LSQLIN �́A�� X �Ɏ����������Ƃ������܂��B
%     3  �c���̕ω����w�肵�����e�͈͂�菬�������Ƃ������܂��B
%     0  �ő�J��Ԃ��񐔂𒴂������Ƃ������܂��B
%    -2  ��肪�s���ł��邱�Ƃ������܂��B
%    -4  �������̂��߁A�œK���𒆒f�������Ƃ������܂��B
%    -7  �T�������̑傫�����������Ȃ肷���Ă��邱�Ƃ������܂��B
%        ����ȏ�v�Z���s�Ȃ����Ƃ��ł��܂���B���́A�s�ǐݒ肩
%        �������ł��B
%
%   [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT] = LSQLIN(C,d,A,b) �́A�J��Ԃ� 
%   OUTPUT.iterations�A�g�p�����A���S���Y�� OUTPUT.algorithm�A(�g�p�����ꍇ) 
%   �������z�J��Ԃ��� OUTPUT.cgiterations�A(��K�͖��̂�) 1 ���̍œK�� 
%   OUTPUT.firstorderopt�A�I�����b�Z�[�W OUTPUT.message �����\���� OUTPUT ��
%   �Ԃ��܂��B
%
%   [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = LSQLIN(C,d,A,b) �́A
%   �� X �ł̃��O�����W���搔 LAMBDA ��Ԃ��܂��BLAMBDA �\���̂́A
%   LAMBDA.ineqyalities �ɐ��`�s���� C ���ALAMBDA.eqlin �ɐ��`���� Ceq ���A
%   LAMBDA.lower �� LB ���ALAMBDA.upper �� UB ��ݒ肵�܂��B
%
%   �Q�l QUADPROG.


%   Copyright 1990-2008 The MathWorks, Inc.
