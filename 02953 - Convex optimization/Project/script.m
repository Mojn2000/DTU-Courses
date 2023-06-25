clear all
%% LASSO example
randn('seed', 0);
rand('seed',0);

m = 100000;       % number of examples
n = 50;        % number of features
p = 10/n;      % sparsity density

x0 = sprandn(n,1,p);
A = randn(m,n);
A = A*spdiags(1./sqrt(sum(A.^2))',0,n,n); % normalize columns
b = A*x0 + sqrt(0.001)*randn(m,1);

lambda_max = norm( A'*b, 'inf' );
lambda = 0.1*lambda_max;

%% Fit Boyd
[x, history] = lasso(A, b, lambda, 1.0, 1.0);

%% My fit
tic
[z, stat] = lasso2(A, b, lambda, 1.0);
toc

%% Distributed lasso
tl = zeros(8,1);
for n = 1:8
    for j = 1:2
        [mojn, t] = lassoDist(A, b, lambda, 1.0,n);
        tl(n) = tl(n) + t;
    end
end
tl = tl./10;
plot(tl)

%% My plots
plot(tl, "linewidth",2)
title("Effect of parallel computing", "fontsize",16)
xlabel("Number of cores", "fontsize",12)
ylabel("Wall time [s]", "fontsize", 12)

%%
Theta = (A'*A) \ (A'*b);
norm(Theta - z)


%% Plots 
K = length(history.objval);

h = figure;
plot(1:K, history.objval, 'k', 'MarkerSize', 10, 'LineWidth', 2);
ylabel('f(x^k) + g(z^k)'); xlabel('iter (k)');

g = figure;
subplot(2,1,1);
semilogy(1:K, max(1e-8, history.r_norm), 'k', ...
    1:K, history.eps_pri, 'k--',  'LineWidth', 2);
ylabel('||r||_2');

subplot(2,1,2);
semilogy(1:K, max(1e-8, history.s_norm), 'k', ...
    1:K, history.eps_dual, 'k--', 'LineWidth', 2);
ylabel('||s||_2'); xlabel('iter (k)');