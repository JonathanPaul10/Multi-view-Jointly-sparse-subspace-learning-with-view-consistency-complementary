function G = updateG(X)
G = zeros(size(X,1),size(X,1));
for i=1 : size(X,1)
    G(i,i) = 1 / (2 * norm(X(i,:)));
end