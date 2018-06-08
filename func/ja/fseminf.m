%FSEMINF  ����������t���œK�����
%
%   FSEMINF �́A�ȉ��`���̖��������܂��B
%
%          { F(x) | C(x) <= 0 , Ceq(x) = 0 , PHI(x,w) <= 0 }
%   ��ԓ��ɑ��݂��邷�ׂĂ� w �ɑ΂��āAF(x) �� x �Ɋւ��čŏ������܂��B
%
%   X = FSEMINF(FUN,X0,NTHETA,SEMINFCON) �́AX0 �������l�Ƃ��āA�֐� 
%   SEMINFCON �ŋK�肳�ꂽ NTHETA �̔���������̂��ƂŁA�֐� FUN �ŏ������� 
%   X �����߂܂��B�֐� FUN �́AX ���x�N�g�����͂Ƃ��āAX �Ōv�Z�����X�J����
%   �֐��l F ��Ԃ��܂��B�֐� SEMINFCON �́AX, S �����`���͂Ƃ��āA����`
%   �s��������x�N�g�� C�A����`��������x�N�g�� Ceq�A����сA�����ԑS�̂�
%   �]������� NTHETA �̔������s��������s�� PHI_1, PHI_2, ..., PHI_NTHETA 
%   ��Ԃ��܂��BS �́A��������T���v���Ԋu�ŁA�g�p���Ă����Ȃ��Ă��\���܂���B
%
%   X = FSEMINF(FUN,X0,NTHETA,SEMINFCON,A,B) �́A���`�s�������� A*X <=  B ��
%   ���������Ƃ��܂��B
%
%   X = FSEMINF(FUN,X0,NTHETA,SEMINFCON,A,B,Aeq,Beq) �́A���`�������� 
%   Aeq*X = Beq �����������Ƃ��܂��B(�s���������݂��Ȃ��ꍇ�AA = [] �� 
%   B = [] ��ݒ肵�Ă�������)
%
%   X = FSEMINF(FUN,X0,NTHETA,SEMINFCON,A,B,Aeq,Beq,LB,UB) �́A�݌v�ϐ� X ��
%   �㉺���͈̔͂�^���邱�Ƃ��\�ł��B���̏ꍇ�ALB <= X <= UB �͈͓̔���
%   �œK�����T������܂��B�͈͂̐��񂪂Ȃ��ꍇ�ALB �� UB �ɋ�s���ݒ肵��
%   ���������BX(i) �� �������Ȃ��ꍇ�ALB(i) = -Inf �Ɛݒ肵�AX(i) �ɏ����
%   �Ȃ��ꍇ�AUB(i) = Inf �Ɛݒ肵�Ă��������B
%
%   X = FSEMINF(FUN,X0,NTHETA,SEMINFCON,A,B,Aeq,Beq,LB,UB,OPTIONS) �́A
%   �I�v�V���� (OPTIONS) ��ݒ肵�Ď��s�ł��܂��B�����ŁAOPTIONS �� 
%   OPTIMSET �֐��Őݒ�ł���\���̂ł��B�ڍׂ́AOPTIMSET ���Q�Ƃ��Ă��������B
%   Display, TolX, TolFun, TolCon, DerivativeCheck, Diagnostics, FunValCheck, 
%   GradObj, MaxFunEvals, MaxIter, DiffMinChange, DiffMaxChange, PlotFcns, 
%   OutputFcn, TypicalX �̃I�v�V�������g�p�ł��܂��B�I�v�V���� GradObj ��
%   �g���āAFUN ���Ăяo���A2 �Ԗڂ̏o�͈��� G �ɓ_ X �ł̕Δ����W�� df/dX 
%   ��ݒ�ł��܂��B [F,G] = feval(FUN,X)
%
%   X = FSEMINF(PROBLEM) �́APROBLEM �Œ�`��������������t�����������܂��B
%   PROBLEM �́APROBLEM.objective �Ɋ֐� FUN�APROBLEM.x0 �ɊJ�n�_�A
%   PROBLEM.ntheta �ɔ���������̐��APROBLEM.seminfcon �ɔ���`�Ɣ���������֐��A
%   PROBLEM.Aineq �� PROBLEM.bineq �ɐ��`�s��������APROBLEM.Aeq �� PROBLEM.beq 
%   �ɐ��`��������APROBLEM.lb �ɉ����APROBLEM.ub �ɏ���APROBLEM.options ��
%   �I�v�V�����\���́APROBLEM.solver �Ƀ\���o�� 'fseminf' �����\���̂ł��B
%   OPTIMTOOL ����G�N�X�|�[�g���������R�}���h���C���ŉ����ɂ́A����
%   �V���^�b�N�X���g�p���Ă��������B�\���� PROBLEM �́A�����̂��ׂĂ�
%   �t�B�[���h�������Ȃ���΂Ȃ�܂���B
%
%   [X,FVAL] = FSEMINF(FUN,X0,NTHETA,SEMINFCON,...) �́A�� X �ł̖ړI�֐� 
%   FUN �̒l��Ԃ��܂��B
%
%   [X,FVAL,EXITFLAG] = FSEMINF(FUN,X0,NTHETA,SEMINFCON,...) �́AFSEMINF ��
%   �I���󋵂����������� EXITFLAG ��Ԃ��܂��BEXITFLAG �̉\�Ȓl�ƑΉ�����
%   �I���󋵂́A���̂Ƃ���ł��B
%
%     1  FSEMINF �͉� X �Ɏ����������Ƃ������܂��B
%     4  �T�������̑傫�����w�肵�����e�덷��菬�����A����ᔽ�� 
%        options.TolCon ��菬�������Ƃ������܂��B
%     5  �T�������ɉ������֐��̌��z�̑傫�������e�͈͂�菬�����A
%        ����ᔽ�� options.TolCon ��菬�������Ƃ������܂��B
%     0  �֐��v�Z�̉񐔁A���邢�͌J��Ԃ��񐔂��ő�񐔂ɒB���Ă��邱�Ƃ�
%        �����܂��B
%    -1  �œK�����A�o�͊֐��ŏI�����Ă��邱�Ƃ������܂��B
%    -2  ����������Ȃ��������Ƃ������܂��B
%
%   [X,FVAL,EXITFLAG,OUTPUT] = FSEMINF(FUN,X0,NTHETA,SEMINFCON,...) �́A
%   �J��Ԃ��� OUTPUT.iterations�A�֐��̕]���� OUTPUT.funcCount�A�ŏI�X�e�b�v��
%   �m���� OUTPUT.stepsize�A�ŏI�̃��C���T���̃X�e�b�v�� OUTPUT.lssteplength�A
%   �g�p�����A���S���Y�� OUTPUT.algorithm�A1 ���̍œK�� OUTPUT.firstorderopt�A
%   �I�����b�Z�[�W OUTPUT.message �����\���� OUTPUT ��Ԃ��܂��B
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = FSEMINF(FUN,X0,NTHETA,SEMINFCON,...) 
%   �́A���ł̃��O�����W�F�搔��Ԃ��܂��BLAMBDA �\���̂́ALAMBDA.lower �� 
%   LB ���ALAMBDA.upper �� UB ���ALAMBDA.ineqlin �ɐ��`�s�������ALAMBDA.eqlin ��
%   ���`�������ALAMBDA.ineqnonlin �ɔ���`�s�������ALAMBDA.eqnonlin ��
%   ����`������ݒ肵�܂��B
%
%   ��
%     FUN �� SEMINFCOM �́A@ ���g���āA�ݒ肷�邱�Ƃ��ł��܂��B
%        x = fseminf(@myfun,[2 3 4],3,@myseminfcon)
%
%   �����ŁAmyfun �́A�ȉ��̂悤�ɕ\����� MATLAB �֐��ł��B
%
%       function F = myfun(x)
%       F = x(1)*cos(x(2))+ x(3)^3;
%
%   �܂��Amyseminfcon �́A�ȉ��̂悤�ɕ\�킳��� MATLAB �֐��ł��B
%
%       function [C,Ceq,PHI1,PHI2,PHI3,S] = myseminfcon(X,S)
%       C = [];     % C �� Ceq ���v�Z����R�[�h
%                   % ���񂪂Ȃ��ꍇ�͋�s��ɂ��܂��B
%       Ceq = [];
%       if isnan(S(1,1))
%          S = [...] ; % S �� ntheta �s �~ 2 ��
%       end
%       PHI1 = ... ;       % PHI ���v�Z����R�[�h
%       PHI2 = ... ;
%       PHI3 = ... ;
%
%   �Q�l OPTIMSET, @, FGOALATTAIN, LSQNONLIN.


%   Copyright 1990-2008 The MathWorks, Inc.
