clc
clearvars
% 
% n=23000;
% 
% caso = '2';%'1';%
% switch caso
%     case '1'
%         A=rand(n,n);
%         b=rand(n,1);
%         x=A\b;
% 
%     case'2'
%         spmd (4)
% 
%             codistr = codistributor2dbc(codistributor2dbc.defaultLabGrid, ...
%                                         codistributor2dbc.defaultBlockSize, ...
%                                         'col');
%             A = codistributed.rand(n, n, codistr);
%             b = codistributed.rand(n, 1, codistr);
%         end
% 
%         spmd (4)
% 
%             x = A\b;
%         end
%         
% end
% A=distributed(A);
% b=distributed(b);
% spmd
%     x=A\b;
% end

% spmd
%     % Use the codistributor that usually gives the best performance
%     % for solving linear systems.
%     codistr = codistributor2dbc(codistributor2dbc.defaultLabGrid, ...
%                                 codistributor2dbc.defaultBlockSize, ...
%                                 'col');
%     A = codistributed.rand(n, n, codistr);
%     b = codistributed.rand(n, 1, codistr);
% end
% 
% spmd
% 
%     x = A\b;
% end

D = distributed.rand(10000); % a very large distributed random matrix
spmd
    tic
    m1 = max( svd( D ) );% Calculate the largest singular value
    toc
end
tic
m2 = max( svd( D ) ); % Calculate the largest singular value
toc
