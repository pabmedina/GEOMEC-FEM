clc 
clearvars

D = distributed.rand(40); % a very large distributed random matrix
spmd
m1 = max( svd( D ) ) % Calculate the largest singular value
end
m2 = max( svd( D ) ); % Calculate the largest singular value