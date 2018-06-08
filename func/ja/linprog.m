%LINPROG  ���`�v����
%
%   X = LINPROG(f,A,b) �́A�ȉ��̌`���̐��`�v����������܂��B
%
%            A*x <= b �̂��ƂŁAf'*x �� x �Ɋւ��čŏ������܂��B
%
%   X = LINPROG(f,A,b,Aeq,beq) �́A�������� Aeq*x = beq �𖞂����Ȃ���A
%   ��q�̖��������܂��B
%
%   X = LINPROG(f,A,b,Aeq,beq,LB,UB) �́A�݌v�ϐ� X �̏㉺���͈̔͂�^����
%   ���Ƃ��\�ł��B���̏ꍇ�ALB <= X <= UB �͈͓̔��ōœK�����T������܂��B
%   �͈͂̐��񂪂Ȃ��ꍇ�ALB �� UB �ɋ�s���ݒ肵�Ă��������BX(i) �ɉ�����
%   �Ȃ��ꍇ�ALB(i) = -Inf �Ɛݒ肵�AX(i) �ɏ�����Ȃ��ꍇ�AUB(i) = Inf ��
%   �ݒ肵�Ă��������B
%
%   X = LINPROG(f,A,b,Aeq,beq,LB,UB,X0) �́A�����l�� X0 �ɐݒ肵�܂��B
%   ���̃I�v�V�����́A�L������@���g�p����Ƃ��̂ݗ��p�ł��܂��B
%   �f�t�H���g�̓��_�A���S���Y���́A���ׂĂ̋�łȂ������l�𖳎����܂��B
%
%   X = LINPROG(f,A,b,Aeq,beq,LB,UB,X0,OPTIONS) �́A�I�v�V���� (OPTIONS) ��
%   �ݒ肵�Ď��s�ł��܂��B�����ŁAOPTIONS �� OPTIMSET �֐��Őݒ�ł���\���̂ł��B
%   �ڍׂ́AOPTIMSET ���Q�Ƃ��Ă��������BDisplay, Diagnostics, TolFun, 
%   LargeScale, MaxIter �̃I�v�V�������g�p���邱�Ƃ��ł��܂��BLargeScale �� 
%   'off' �̏ꍇ�A'final' �� 'off' �݂̂��ADisplay �ɑ΂��Ďg���܂� 
%   (LargeScale �� 'on' �̏ꍇ�A'iter' ���g�p�ł��܂�)�B
%
%   X = LINPROG(PROBLEM) �́APROBLEM �ɑ΂���ŏ��l�����߂܂��B
%   PROBLEM �́APROBLEM.f �Ƀx�N�g�� 'f'�APROBLEM.Aineq �� PROBLEM.bineq ��
%   ���`�s��������APROBLEM.Aeq �� PROBLEM.beq �ɐ��`��������APROBLEM.lb ��
%   �����APROBLEM.ub �ɏ���APROBLEM.x0 �ɊJ�n�_�APROBLEM.options ��
%   �I�v�V�����\���́APROBLEM.solver �Ƀ\���o�� 'linprog' �����\���̂ł��B
%   OPTIMTOOL ����G�N�X�|�[�g���������R�}���h���C���ŉ����ɂ́A
%   ���̃V���^�b�N�X���g�p���Ă��������B�\���� PROBLEM �ɂ́A�����̂��ׂĂ�
%   �t�B�[���h���Ȃ���΂Ȃ�܂���B
%
%   [X,FVAL] = LINPROG(f,A,b) �́A�� X �ł̖ړI�֐��̒l FVAL = f'*X ��Ԃ��܂��B
%
%   [X,FVAL,EXITFLAG] = LINPROG(f,A,b) �́ALINPROG �̏I���󋵂����������� 
%   EXITFLAG ��Ԃ��܂��BEXITFLAG �̉\�Ȓl�ƑΉ�����I���󋵂́A�ȉ��̂Ƃ���ł��B
%
%     1  LINPROG �́A�� X �Ɏ����������Ƃ������܂��B
%     0  �ő�J��Ԃ��񐔂ɒB���Ă��邱�Ƃ������܂��B
%    -2  ����������Ȃ��������Ƃ������܂��B
%    -3  ���ɐ��񂪂Ȃ����Ƃ������܂��B
%    -4  �A���S���Y���̕]������ NaN �̒l�����������Ƃ������܂��B
%    -5  �o�΁A����̗������s���ł��邱�Ƃ������܂��B
%    -7  �T�������̑傫�����������Ȃ肷���Ă��邱�Ƃ������܂��B
%        ����ȏ�v�Z���s�Ȃ����Ƃ��ł��܂���B���́A�s�ǐݒ肩�������ł��B
%
%   [X,FVAL,EXITFLAG,OUTPUT] = LINPROG(f,A,b) �́A�J��Ԃ��� OUTPUT.iterations�A
%   �g�p�����A���S���Y�� OUTPUT.algorithm�A�������z�J��Ԃ��� 
%   OUTPUT.cgiterations (= 0, ���ʌ݊����̂��߂Ɋ܂܂�܂���)�A�I�����b�Z�[�W 
%   OUTPUT.message �����\���� OUTPUT ��Ԃ��܂��B
%
%   [X,FVAL,EXITFLAG,OUTPUT,LAMBDA] = LINPROG(f,A,b) �́A�� X �ł̃��O�����W��
%   �搔 LAMBDA ��Ԃ��܂��BLAMBDA �\���̂́ALAMBDA.ineqyalities �ɐ��`�s���� 
%   A ���ALAMBDA.eqlin �ɐ��`���� Aeq ���ALAMBDA.lower �� LB ���ALAMBDA.upper 
%   �� UB ��ݒ肵�܂��B
%
%   ����: LINPROG �̑�K�͖�� (�f�t�H���g) �́A��o�Ζ@���g�p���܂��B
%         ����Ƒo�Ζ��́A���Ɏ����ɑ΂��ĕs���łȂ���΂Ȃ�܂���B
%         ����A�o�Ζ��A���邢�͗����̂����ꂩ�����ł���Ƃ���
%         ���b�Z�[�W���K�؂ɗ^�����܂��B����̕W���I�Ȍ`���́A
%         �ȉ��̂Ƃ���ł��B
%              A*x = b, x >= 0 �̂��ƂŁAf'*x ���ŏ������܂��B
%         �o�Ζ��́A�ȉ��̌`���ɂȂ�܂��B
%              A'*y + s = f, s >= 0 �̂��ƂŁAb'*y ���ő剻���܂��B
%
%   �Q�l QUADPROG.


%   Copyright 1990-2008 The MathWorks, Inc.
