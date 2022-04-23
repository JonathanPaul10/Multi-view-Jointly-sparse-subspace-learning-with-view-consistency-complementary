function [B] = OMP(Y_omp, X_omp, L)
% argmin_B  ||Y-XB'||^2_F
% Y: label matrix: n*P, n is the number of samples, P is the number of class
% X: dictionary, X:n*K, K is the dimensionality of data
% L: the number of projections in B
[n, P] = size(Y_omp);
[n, K] = size(X_omp);
for k = 1:P
    a = [];
    x = Y_omp(:, k);
    residual = x;
    index = zeros(L, 1);
    for j = 1:L
        proj = X_omp'*residual;
        pos = find(abs(proj)==max(abs(proj)));
        pos = pos(1);
        index(j) = pos;
        a = pinv(X_omp(:, index(1:j)))*x;
        residual = x - X_omp(:, index(1:j))*a;
    end;
    temp = zeros(K,1);
    temp(index) = a;
%    B(:, k) = sparse(temp);
    B(:,k) = temp;
end
%B = B';
end
