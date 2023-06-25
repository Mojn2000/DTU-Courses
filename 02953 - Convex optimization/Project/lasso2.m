function [beta, stat] = lasso2(A, b, lambda, rho)
    MAX_ITER = 1000;
    ABSTOL   = 1e-9;
    RELTOL   = 1e-12;

    [m, n] = size(A);

    beta = zeros(n,1);
    alpha = zeros(n,1);
    w = zeros(n,1);

    stat.beta = alpha;
    stat.alpha = alpha;
    stat.w = w;
    stat.obj = objective(A,b, lambda, beta, alpha);
    
    L = sparse(chol(A'*A + rho*eye(n), 'lower' ));
    U = L';
    
    
    for k = 1:MAX_ITER
        beta = U \ (L \ ( A'*b + rho*(alpha - w) ));
        alpha = S(beta + w, lambda./rho);
        w = w + (beta - alpha);
        
        stat.beta = [stat.beta, beta];
        stat.alpha = [stat.alpha, alpha];
        stat.w = [stat.w, w];
        stat.obj = [stat.obj, objective(A,b, lambda, beta, alpha)];
        
        r = norm(beta - alpha,'Inf');
        rn = r / norm(beta,'Inf');
        
        if r<ABSTOL && rn<RELTOL
            break
        end
    end
end

function res = S(x, kappa)
    res = max( 0, x - kappa ) - max( 0, -x - kappa );
end

function p = objective(A, b, lambda, beta, alpha)
    p = ( 1/2*sum((A*beta - b).^2) + lambda*norm(alpha,1) );
end
