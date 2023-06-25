function [betaBar, t] = lassoDist(A, b, lambda, rho, N)
    MAX_ITER = 10000;
    rTol   = 1e-5;
    dTol   = 1e-5;
    
    n = zeros(N,1);
    
    for i = 1:N
        if i<N
            n(i) = floor(size(A,1)/N);
        else
            n(i) = size(A,1) - sum(n);
        end
    end
    tic;
    parfor i=1:N
        if i==1
            Am{i} = A(1:n(i),:);
            bm{i} = b(1:n(i));
        elseif i<N
            Am{i} = A(sum([n(1:(i-1));1]): sum(n(1:i)),:);
            bm{i} = b(sum([n(1:(i-1));1]): sum(n(1:i)));
        else
            Am{i} = A(sum([n(1:(i-1));1]):end,:);
            bm{i} = b(sum([n(1:(i-1));1]):end);
        end
        L{i} = chol(Am{i}'*Am{i} + rho*eye(size(Am{i},2)), 'lower' );
        U{i} = L{i}';
        
        beta{i} = zeros(size(A,2),1);
        w{i} = zeros(size(A,2),1);
    end
    
    alpha = zeros(size(A,2),1);
    wBar = zeros(size(A,2),1);
    betaBarOld = zeros(size(A,2),1);
    
    %stat.beta = alpha;
    %stat.alpha = alpha;
    %stat.w = w;
    %stat.obj = objective(A,b, lambda, beta, alpha);
    
    for k = 1:MAX_ITER
        parfor i=1:N
            beta{i} = U{i} \ (L{i} \ ( Am{i}'*bm{i} + rho*(alpha - w{i}) ));
        end
        
        betaBar = zeros(size(A,2),1);
        for i=1:N
            betaBar = betaBar + beta{i};
        end
        betaBar = betaBar./N;
        
        alpha = S(betaBar + wBar, lambda./(rho*N));
        
        parfor i=1:N
            w{i} = w{i} + (beta{i} - alpha);
        end
        
        wBar = zeros(size(A,2),1);
        for i=1:N
            wBar = wBar + w{i};
        end
        wBar = wBar./N;
        
        %stat.beta = [stat.beta, beta];
        %stat.alpha = [stat.alpha, alpha];
        %stat.w = [stat.w, w];
        %stat.obj = [stat.obj, objective(A,b, lambda, beta, alpha)];
        
        % Primal residual
        rk = 0;
        for i=1:N
            rk = rk + norm(beta{i} - betaBar,2)^2;
        end
        
        % Dual residual
        sk = N*rho^2*norm(betaBar - betaBarOld,2)^2;
        
        if rk<rTol && sk<dTol
            t = toc;
            break
        end
        betaBarOld = betaBar;
    end
end

function res = S(x, kappa)
    res = max( 0, x - kappa ) - max( 0, -x - kappa );
end

function p = objective(A, b, lambda, beta, alpha)
    p = ( 1/2*sum((A*beta - b).^2) + lambda*norm(alpha,1) );
end
