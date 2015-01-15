function [ eigen_vectors, eigen_values] = Eigen( A )
%EIGEN Calculate Eigen vectors
% Eigen vectors are sorted in descending order

%find Lambdas
identityMatrix = eye(size(A, 1));

syms Lambda;
LambdaS = solve(det(A - Lambda*identityMatrix) == 0,  Lambda);
LambdaS = sort(LambdaS);

eigen_vectors = zeros(size(LambdaS, 1));
eigen_values = eye(size(LambdaS, 1));

%for each Lambda, calculate eigen vector
for i=1:size(LambdaS, 1)
    X = null(A - (LambdaS(i)*identityMatrix));
    eigen_vectors(:, i) = X;
    eigen_values(i, i) = LambdaS(i);
end

end

