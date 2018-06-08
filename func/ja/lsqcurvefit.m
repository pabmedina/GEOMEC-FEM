% LSQCURVEFIT   ����`�ŏ������ (��A���͂ɓ���)
%
% LSQCURVEFIT �́A���̌`���̖��������܂��B
% sum {(FUN(X,XDATA)-YDATA).^2} �� X �Ɋւ��čŏ������܂��B
%                               �����ŁAX, XDATA, YDATA, FUN ��
%                               �o�͒l�́A�x�N�g���܂��͍s��ł��B
%
% X = LSQCURVEFIT(FUN,X0,XDATA,YDATA) �́AX0 �������l�Ƃ��A�֐� FUN ��
% ��`�������`�֐����f�[�^ YDATA �ɁA�ŏ����I�ɍœK�ߎ�����W�� X ������
% �܂��BFUN �́AX �� XDATA ����͂Ƃ��āA�x�N�g�� (�܂��́A�s��) �֐��l 
% F ���o�͂��܂��B�����ŁAF �́AYDATA �Ɠ����T�C�Y�ŁAX �� XDATA �Ōv�Z����
% ���̂ł��B���ӁFFUN �́AFUN(X,XDATA) ��Ԃ��Asum(FUN(X,XDATA).^2) ��
% �\�������a�ł͂���܂���B���̏����́A�A���S���Y���̒��ŁA�A�I��
% �s�Ȃ��܂��B
%
% X = LSQCURVEFIT(FUN,X0,XDATA,YDATA,LB,UB) �́A�݌v�ϐ� X �̏㉺����
% �͈͂�^���邱�Ƃ��\�ł��B�����ŁALB <= X <= UB �͈͓̔��ōœK����
% �T������܂��B�͈͂̐��񂪂Ȃ��ꍇ�ALB �� UB �ɋ�s���ݒ肵�Ă��������B
% X(i) �ɉ������Ȃ��ꍇ�ALB(i) = -Inf �Ɛݒ肵�AX(i) �ɏ�����Ȃ��ꍇ�A
% UB(i) = Inf �Ɛݒ肵�Ă��������B
% 
% X=LSQCURVEFIT(FUN,X0,XDATA,YDATA,LB,UB,OPTIONS) �́A�I�v�V���� 
% (OPTIONS) ��ݒ肵�Ď��s�ł��܂��B�����ŁAOPTIONS �� OPTIMSET �֐���
% �ݒ�ł���\���̂ł��B�ڍׂ́AOPTIMSET ���Q�Ƃ��Ă��������BDisplay, 
% TolX, TolFun, DerivativeCheck, Diagnostics, FunValCheck, Jacobian, 
% JacobMult, JacobPattern, LineSearchType, LevenbergMarquardt, MaxFunEvals, 
% MaxIter, DiffMinChange, DiffMaxChange, LargeScale, MaxPCGIter, 
% PrecondBandWidth, TolPCG, OutputFcn, TypicalX  �̃I�v�V�������g�p�ł��܂��B
% �I�v�V���� Jacobian ���g���āAFUN ���Ăяo���A2 �Ԗڂ̏o�͈��� J �ɁA
% �_ X �ł̃��R�r�s���ݒ�ł��܂��B[F,J] = feval(FUN,X) �̌`���ŌĂ�
% �o���܂��BFUN ���AX ������ n �̏ꍇ�Am �v�f�̃x�N�g����Ԃ��ꍇ�AJ �́A
% m �s n ��̍s��ɂȂ�܂��B�����ŁAJ(i,j) �́AF(i) �� x(j) �ɂ��Δ���
% �W���ł� (���R�r�s�� J �́AF �̌��z��]�u�������̂ł�)�B
%
% [X,RESNORM]=LSQCURVEFIT(FUN,X0,XDATA,YDATA,...)  �́AX �ł̎c���� 
% 2 �m���� sum {(FUN(X,XDATA)-YDATA).^2} ���o�͂��܂��B
%
% [X,RESNORM,RESIDUAL] = LSQCURVEFIT(FUN,X0,...) �́A�� X �ł̎c���̒l 
% FUN(X,XDATA)-YDATA ���o�͂��܂��B
%
% [X,RESNORM,RESIDUAL,EXITFLAG] = LSQCURVEFIT(FUN,X0,XDATA,YDATA,...) �́A
% LSQCURVEFIT �̏I���󋵂����������� EXITFLAG ���o�͂��܂��BEXITFLAG ��
% �\�Ȓl�ƑΉ�����I���󋵂́A���̒ʂ�ł��B
%
%   1  LSQCURVEFIT �́A�� X �Ɏ����������Ƃ������܂��B
%   2  X �̕ω����w�肵�����e�͈͂�菬�������Ƃ������܂��B
%   3  �ړI�֐��l�̕ω����w�肵�����e�͈͂�菬�������Ƃ������܂��B
%   4  �T�������̑傫�����w�肵�����e�덷��菬�������Ƃ������܂��B
%   0  �֐��v�Z�̉񐔁A���邢�͌J��Ԃ��񐔂��ő�񐔂ɒB���Ă��邱�Ƃ������܂��B
%  -1  �œK�����A�o�͊֐��ŏI�����Ă��邱�Ƃ������܂��B
%  -2  ���E���������Ă��邱�Ƃ������܂��B
%  -4  ���C���T���́A���݂̒T�������ɉ����ď\���Ɏc���������ł��Ȃ����Ƃ������܂��B
%
% [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT] = LSQCURVEFIT(FUN,X0,XDATA,YDATA,...) 
% �́A�J��Ԃ��� OUTPUT.iterations�A�֐��̕]���� OUTPUT.funcCount�A
% �g�p�����A���S���Y�� OUTPUT.algorithm�A(�g�p�����ꍇ) �������z�J��Ԃ��� 
% OUTPUT.cgiterations �A(�g�p�����ꍇ) 1 ���̍œK�� OUTPUT.firstorderopt�A
% �I�����b�Z�[�W OUTPUT.message �����\���� OUTPUT �ɏo�͂��܂��B
%
% [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA] = LSQCURVEFIT(FUN,X0,XDATA,YDATA,...) 
% �́A�� X �ł̃��O�����W�F�搔 LAMBDA ���o�͂��܂��BLAMBDA.lower �� LB ���A
% LAMBDA.upper �� UB ��ݒ肵�Ă��܂��B
%
% [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN] = LSQCURVEFIT(FUN,X0,XDATA,YDATA,...) 
% �́A�� X �ł̊֐� FUN �̃��R�r�s��l���o�͂��܂��B
%
% ��
% FUN �́A@ ���g���Đݒ肷�邱�Ƃ��ł��܂��B
% �@�@   xdata = [5;4;6];          % xdata �̗�
%        ydata = 3*sin([5;4;6])+6; % ydata �̗�
%        x = lsqcurvefit(@myfun, [2 7], xdata, ydata)
%
% �����ŁAmyfun �́A���̂悤�ɕ\����� MATLAB �֐��ł��B
%
%       function F = myfun(x,xdata)
%       F = x(1)*sin(xdata)+x(2);
%
% FUN �́A�����֐��Ƃ��Ă��\���ł��܂��B
%
%       x = lsqcurvefit(@(x,xdata) x(1)*sin(xdata)+x(2),[2 7],xdata,ydata)
%
% FUN ���p�����[�^�����ꂽ�ꍇ�A���Ɉˑ������p�����[�^���w�肵�Ė���
% �֐����g�p�ł��܂��B2 �Ԗڂ̈��� c �Ńp�����[�^�����ꂽ�֐� myfun ��
% �ŏ�������Ɖ��肵�܂��B�����ŁAmfun �͂��̂悤�� M-�t�@�C���֐��ł��B
%
%       function F = myfun(x,xdata,c)
%       F = x(1)*exp(c*xdata)+x(2);
%
% c �̎w��l�ɑ΂��čœK�����邽�߂ɂ́A�ŏ��� c �ɐݒ肵�܂��B���ɁA
% x �������Ƃ��閳���֐� myfun ���`���A�ŏI�I�ɁALSQCURVEFIT �ɓn���܂��B
%
%       xdata = [3; 1; 4];           % xdata �̗�
%       ydata = 6*exp(-1.5*xdata)+3; % ydata �̗�
%       c = -1.5;                    % �p�����[�^�̒�`
%       x = lsqcurvefit(@(x,xdata) myfun(x,xdata,c),[5;1],xdata,ydata)
%
%   �Q�l OPTIMSET, LSQNONLIN, FSOLVE, @, INLINE.


%   Copyright 1990-2006 The MathWorks, Inc.
