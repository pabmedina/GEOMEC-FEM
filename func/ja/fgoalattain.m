%FGOALATTAIN  ���ړI�S�[�����B�œK�����
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT) �́AX ��ω������邱�Ƃɂ��A
%   �֐� FUN �Őݒ肳���ړI�֐� (F) ���A�S�[�� �iGOAL�j �ɓ��B�����܂��B
%   �S�[���́AWEIGHT �ɏ]���āA�d�ݕt�����܂��B������s�Ȃ��Ƃ��ɁA
%   �ȉ��̌`���̔���`�v����������܂��B
%
%       LAMBDA : F(X)-WEIGHT.*LAMBDA<=GOAL �� X, LAMBDA �Ɋւ��čŏ������܂��B
%
%   FUN �́AX ����͂Ƃ��āAX �Ōv�Z�����x�N�g�� (�s��) �̊֐��l F ��
%   �Ԃ��܂��BX0 �́A�X�J���A�x�N�g���A�܂��́A�s��ł��B
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT,A,B) �́A���`�s�������� A*X <= B ��
%   ���ƂŁA�S�[�����B���������܂��B
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT,A,B,Aeq,Beq) �́A���l�ɐ��`������ 
%   Aeq*X = Beq �̐���̂��ƂŃS�[�����B���������܂��B
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT,A,B,Aeq,Beq,LB,UB) �́A�݌v�ϐ� 
%   X �̏㉺����^���邱�Ƃ��\�ł��B���̏ꍇ�ALB <= X <= UB �͈͓̔���
%   �œK�����T������܂��B�͈͂̐��񂪂Ȃ��ꍇ�ALB �� UB �ɋ�s���ݒ�
%   ���Ă��������BX(i) �� �������Ȃ��ꍇ�ALB(i) = -Inf �Ɛݒ肵�AX(i) ��
%   ������Ȃ��ꍇ�AUB(i) = Inf �Ɛݒ肵�Ă��������B
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT,A,B,Aeq,Beq,LB,UB,NONLCON) �́A
%   NONLCON (�ʏ�́AM-�t�@�C�� NONLCON.m) �Œ�`��������̂��ƂŁA�S�[��
%   ���B���������܂��B�����Ŋ֐� NONLCON �́A
%   feval: [C, Ceq] = feval(NONLCON,X) 
%   �̂悤�ɌĂяo�����ꍇ�A���ꂼ��A����`�̕s��������Ɠ��������
%   �\�킷 C �� Ceq �x�N�g����Ԃ��܂��BFGOALATTAIN �́AC(X)< = 0 �� 
%   Ceq(X) = 0 �ɂȂ�悤�ɍœK�����܂��B
%
%   X = FGOALATTAIN(FUN,X0,GOAL,WEIGHT,A,B,Aeq,Beq,LB,UB,NONLCON,OPTIONS) 
%   �́A�I�v�V���� (OPTIONS) ��ݒ肵�Ď��s�ł��܂��B�����ŁAOPTIONS �́A
%   OPTIMSET �֐��Őݒ�ł���\���̂ł��B�ڍׂ́AOPTIMSET ���Q�Ƃ��Ă��������B
%   Display, TolX, TolFun, TolCon, DerivativeCheck, FunValCheck, GradObj, 
%   GradConstr, MaxFunEvals, MaxIter, MeritFunction, GoalsExactAchieve, 
%   Diagnostics, DiffMinChange, DiffMaxChange, PlotFcns, OutputFcn, TypicalX 
%   �̃I�v�V�������g�p�ł��܂��B�I�v�V���� GradObj ���g���āAFUN ���Ăяo���A
%   2 �Ԗڂ̏o�͈��� G �ɓ_ X �ł̕Δ����W�� df/dX ��ݒ�ł��܂��B 
%   [F,G] = feval(FUN,X).GradConstr �I�v�V�������g���āA���̂悤�ɁA4 ��
%   �o�͈����ŌĂяo����� NONLCON ���w��ł��܂��B
%   [C,Ceq,G,C,GCeq] = feval(NONLINCON,X) �̌`���ŌĂяo���܂��B�����ŁA
%   GC �́A�s��������x�N�g�� C �̕Δ����W���AGCeq �́A��������x�N�g�� 
%   Ceq �̕Δ����W���ł��B�I�v�V������ݒ肵�Ȃ��ꍇ�́AOPTIONS = [] ��
%   �g�p���Ă��������B
%
%   X = FGOALATTAIN(PROBLEM) �́APROBLEM �ɒ�`���ꂽ�S�[�����B����
%   �����܂��BPROBLEM �́APROBLEM.objective �Ɋ֐� FUN�APROBLEM.x0 �ɊJ�n�_�A
%   PROBLEM.goal �� 'goal' �x�N�g���APROBLEM.weight �� 'weight' �x�N�g���A
%   PROBLEM.Aineq �� PROBLEM.bineq �ɐ��`�s��������APROBLEM.Aeq �� PROBLEM.beq 
%   �ɐ��`��������APROBLEM.lb �ɉ����APROBLEM.ub �ɏ���APROBLEM.nonlcon ��
%   ����`����֐��APROBLEM.options �ɃI�v�V�����\���́APROBLEM.solver ��
%   �\���o�� 'fgoalattain' �����\���̂ł��BOPTIMTOOL ����G�N�X�|�[�g����
%   �����R�}���h���C���ŉ����ɂ́A���̃V���^�b�N�X���g�p���Ă��������B
%   �\���� PROBLEM �́A�����̂��ׂẴt�B�[���h�������Ȃ���΂Ȃ�܂���B
%
%   [X,FVAL] = FGOALATTAIN(FUN,X0,...) �́A�� X �ł̖ړI�֐� FUN �̒l��
%   �Ԃ��܂��B
%
%   [X,FVAL,ATTAINFACTOR] = FGOALATTAIN(FUN,X0,...) �́A�� X �ł̓��B���q��
%   �Ԃ��܂��BATTAINFACTOR �����̏ꍇ�A�S�[���͉ߓ��B�ɂȂ�܂��B�܂��A
%   ���̏ꍇ�A�����B�ɂȂ�܂��B
%
%   [X,FVAL,ATTAINFACTOR,EXITFLAG] = FGOALATTAIN(FUN,X0,...) �́AFGOALATTAIN 
%   �̏I���󋵂����������� EXITFLAG ��Ԃ��܂��BEXITFLAG �̉\�Ȓl�ƑΉ�����
%   �I���󋵂́A���̂Ƃ���ł��B
%
%     1  FGOALATTAIN �́A�� X �Ɏ������Ă��邱�Ƃ������܂��B
%     4  �T�������̑傫�����w�肵�����e�덷��菬�����A����ᔽ�� 
%        options.TolCon ��菬�������Ƃ������܂��B
%     5  �T�������ɉ������֐��̌��z�̑傫�������e�͈͂�菬�����A
%        ����ᔽ�� options.TolCon ��菬�������Ƃ������܂��B
%     0  �֐��v�Z�̉񐔁A���邢�͌J��Ԃ��񐔂��ő�񐔂ɒB���Ă��邱�Ƃ�
%        �����܂��B
%    -1  �œK�����A�o�͊֐��ŏI�����Ă��邱�Ƃ������܂��B
%    -2  ����������Ȃ��������Ƃ������܂��B
%
%   [X,FVAL,ATTAINFACTOR,EXITFLAG,OUTPUT] = FGOALATTAIN(FUN,X0,...) �́A
%   �J��Ԃ��� OUTPUT.iterations�A�֐��̕]���� OUTPUT.funcCount�A�ŏI�X�e�b�v��
%   �m���� OUTPUT.stepsize�A�ŏI�̃��C���T���̃X�e�b�v�� OUTPUT.lssteplength�A
%   �g�p�����A���S���Y�� OUTPUT.algorithm�A1 ���̍œK�� OUTPUT.firstorderopt�A
%   �I�����b�Z�[�W OUTPUT.message �����\���� OUTPUT ��Ԃ��܂��B
%
%   [X,FVAL,ATTAINFACTOR,EXITFLAG,OUTPUT,LAMBDA] = FGOALATTAIN(FUN,X0,...) 
%   �́A���ł̃��O�����W�F�搔 LAMBDA ��Ԃ��܂��BLAMBDA �\���̂́ALAMBDA.lower 
%   �� LB ���ALAMBDA.upper �� UB ���ALAMBDA.ineqlin �ɐ��`�s�������A
%   LAMBDA.eqlin �ɐ��`�������ALAMBDA.ineqnonlin �ɔ���`�s�������A
%   LAMBDA.eqnonlin �ɔ���`������ݒ肵�܂��B
%
%   �ڍׂ́AM-�t�@�C�� FGOALATTAIN.M ���Q�Ƃ��Ă��������B
%
%   �Q�l OPTIMSET, OPTIMGET.


%   Copyright 1990-2008 The MathWorks, Inc.
