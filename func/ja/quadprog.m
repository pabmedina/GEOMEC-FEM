%QUADPROG  �񎟌v��@
%
%   X = QUADPROG(H,f,A,b) �́A�ȉ��̌`���̓񎟌v����������܂��B
%
%            A*x <=  b �̂��ƂŁA0.5*x'*H*x + f'*x �� x �Ɋւ��čŏ������܂��B
%
%   X = QUADPROG(H,f,A,b,Aeq,beq) �́A�������� Aeq*x = beq �𖞂����Ȃ���A
%   ��q�̖��������܂��B
%
%   X = QUADPROG(H,f,A,b,Aeq,beq,LB,UB) �́A�݌v�ϐ� X �̏㉺���͈̔͂�^����
%   ���Ƃ��\�ł��B���̏ꍇ�ALB <= X <= UB �͈͓̔��ōœK�����T������܂��B
%   �͈͂̐��񂪂Ȃ��ꍇ�ALB �� UB �ɋ�s���ݒ肵�Ă��������BX(i) �ɉ�����
%   �Ȃ��ꍇ�ALB(i) = -Inf �Ɛݒ肵�AX(i) �ɏ�����Ȃ��ꍇ�AUB(i) = Inf ��
%   �ݒ肵�Ă��������B
%
%   X = QUADPROG(H,f,A,b,Aeq,beq,LB,UB,X0) �́AX0 ���J�n�_�Ƃ��Đݒ肵�܂��B
%
%   X = QUADPROG(H,f,A,b,Aeq,beq,LB,UB,X0,OPTIONS) �́A�f�t�H���g�̍œK��
%   �p�����[�^�̑���ɁA�֐� OPTIMSET �ō쐬���ꂽ OPTIONS �\���̂̒l��
%   �g���čŏ������s���܂��B�ڍׂ́AOPTIMSET ���Q�Ƃ��Ă��������BDisplay, 
%   Diagnostics, TolX, TolFun, HessMult, LargeScale, MaxIter, PrecondBandWidth, 
%   TypicalX, TolPCG, MaxPCGIter �̃I�v�V�������g�p���邱�Ƃ��ł��܂��B
%   'final' �� 'off' �݂̂� Display �ɑ΂��Ďg���܂� ('iter' �͎g�p�ł��܂���)�B
%
%   X = QUADPROG(PROBLEM) �́APROBLEM �ɑ΂���ŏ��l�����߂܂��BPROBLEM �́A
%   PROBLEM.H �ɍs�� 'H'�APROBLEM.f �Ƀx�N�g�� 'f'�APROBLEM.Aineq �� 
%   PROBLEM.bineq �ɐ��`�s��������APROBLEM.Aeq �� PROBLEM.beq �ɐ��`��������A
%   PROBLEM.lb �ɉ����APROBLEM.ub �ɏ���APROBLEM.x0 �ɊJ�n�_�APROBLEM.options ��
%   �I�v�V�����\���́APROBLEM.solver �Ƀ\���o�� 'quadprog' �����\���̂ł��B
%   OPTIMTOOL ����G�N�X�|�[�g���������R�}���h���C���ŉ����ɂ́A����
%   �V���^�b�N�X���g�p���Ă��������B�\���� PROBLEM �ɂ́A�����̂��ׂĂ�
%   �t�B�[���h���Ȃ���΂Ȃ�܂���B
%
%   [X,FVAL] = QUADPROG(H,f,A,b) �́AX �ł̖ړI�֐� FVAL = 0.5*X'*H*X + f'*X 
%   �̒l��Ԃ��܂��B
%
%   [X,FVAL,EXITFLAG] = QUADPROG(H,f,A,b) �́AQUADPROG �̏I���󋵂����������� 
%   EXITFLAG ��Ԃ��܂��BEXITFLAG �̉\�Ȓl�ƑΉ�����I���󋵂́A�ȉ���
%   �Ƃ���ł��B
%
%     1  QUADPROG �́A�� X �Ɏ����������Ƃ������܂��B
%     3  �ړI�֐��l�̕ω����w�肵�����e�͈͂�菬�������Ƃ������܂��B
%     4  �Ǐ��ŏ��l�������������Ƃ������܂��B
%     0  �ő�J��Ԃ��񐔂𒴂������Ƃ������܂��B
%    -2  ����������Ȃ��������Ƃ������܂��B
%    -3  ���ɐ��񂪂Ȃ����Ƃ������܂��B
%    -4  ���݂̒T�������́A�~���̕����ł͂Ȃ��A����ɒT�����s���Ȃ����Ƃ�
%        �����܂��B
%    -7  �T�������̑傫�����������Ȃ肷���Ă��邱�Ƃ������܂��B
%        ����ȏ�v�Z���s�Ȃ����Ƃ��ł��܂���B���́A�s�ǐݒ肩�������ł��B
%
%   [X,FVAL,EXITFLAG,OUTPUT] = QUADPROG(H,f,A,b) �́A�J��Ԃ��� 
%   OUTPUT.iterations�A�g�p�����A���S���Y�� OUTPUT.algorithm�A(�g�p�����ꍇ) 
%   �������z�J��Ԃ��� OUTPUT.cgiterations �A(��K�͂ȃA���S���Y���̂�) 1 ���̍œK�l 
%   OUTPUT.firstorderopt�A�I�����b�Z�[�W������ꍇ�� OUTPUT.message ������
%   �\���� OUTPUT ��Ԃ��܂��B
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = QUADPROG(H,f,A,b) �́A�� X �ł�
%   ���O�����W���搔 LAMBDA ��Ԃ��܂��BLAMBDA �\���̂́ALAMBDA.ineqyalities 
%   �ɐ��`�s���� A ���ALAMBDA.eqlin �ɐ��`���� Aeq ���ALAMBDA.lower �� LB ���A
%   LAMBDA.upper �� UB ��ݒ肵�܂��B
%
%   �Q�l LINPROG, LSQLIN.


%   Copyright 1990-2008 The MathWorks, Inc.
