function [z, obj,Hist] = lasso(A, b, lambda, rho,eps, log)
if nargin<6
    log = false;
end
if nargin<5
    eps   = 1e-4;
end
max_iter = 15000;
eps_abs = eps;
eps_rel   = 10^(-4);
[m, n] = size(A);

% Prepare static values
Atb = A'*b;
L = chol( A'*A + rho*speye(n), 'lower' );
L = sparse(L);
U = sparse(L');

% Initilize variables
z = zeros(n,1);
mu = zeros(n,1);

% log object
if log
    objHist = zeros(1,max_iter);
    eps_dualHist = zeros(1,max_iter);
    eps_priHist = zeros(1,max_iter);
    s_normHist = zeros(1,max_iter);
    r_normHist = zeros(1,max_iter);
end


for k = 1:max_iter

    % x-update
    x = U \ (L \ (Atb + rho*(z - mu)));

    % z-update with relaxation
    v = x + mu;
    zold = z;
    z = max( 0, v - lambda/rho ) - max( 0, -v - lambda/rho );

    % mu-update
    mu = mu + (x - z);
    
    % convergence
    r_norm  = norm(x - z, 2);
    s_norm  = norm(-rho*(z - zold),2);

    eps_pri = sqrt(n)*eps_abs + eps_rel*max(norm(x), norm(-z));
    eps_dual = sqrt(n)*eps_abs + eps_rel*norm(rho*mu);
    
    if log
        objHist(k) = ( 1/2*sum((A*x - b).^2) + lambda*norm(z,1) );
        eps_dualHist(k) = eps_dual;
        eps_priHist(k) = eps_pri;
        s_normHist(k) = s_norm;
        r_normHist(k) = r_norm;
    end


    if (r_norm <= eps_pri && s_norm < eps_dual)
        obj  = ( 1/2*sum((A*x - b).^2) + lambda*norm(z,1) );
        if log
            objHist = objHist(1:k);
            eps_dualHist = eps_dualHist(1:k);
            eps_priHist = eps_priHist(1:k);
            s_normHist = s_normHist(1:k);
            r_normHist = r_normHist(1:k);

            Hist = struct('objHist', objHist, 'eps_dualHist', eps_dualHist, 'eps_priHist', eps_priHist, 's_normHist' ,s_normHist, 'r_normHist', r_normHist, 'Iteration', k);
        else
            Hist = struct();
        end
         return;
    end
end
disp("Max reached")
if log
    Hist = struct('objHist', objHist, 'eps_dualHist', eps_dualHist, 'eps_priHist', eps_priHist, 's_normHist' ,s_normHist, 'r_normHist', r_normHist, 'Iteration', k);
else
    Hist = struct();
end
obj  = ( 1/2*sum((A*x - b).^2) + lambda*norm(z,1) );

end