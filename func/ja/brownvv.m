% BROWNVV   �t���s��̍\�������ꂽHessian�̔���`�ŏ���
%
% [F,G,HINFO] = BROWNVV(X,V) �́A�ړI�֐� F�A���z G�AHINFO�ɂ�����
% F ��Hessian�̃p�[�g���v�Z���܂��B�Ⴆ�΁A
%       F = FHAT(X) - 0.5*X'*V*V'*X
%       G �� F �̌��z 
%            G = FHAT(X)�̌��z - V*V'*X
%       Hinfo �� FHAT ��Hessian
%       (H �̓t���̌`���ł͂���܂��񂪁A
%       H = Hinfo - V*V' �𖞂����܂��BHMFBX4 ���Q��)


%   Copyright 1984-2006 The MathWorks, Inc.