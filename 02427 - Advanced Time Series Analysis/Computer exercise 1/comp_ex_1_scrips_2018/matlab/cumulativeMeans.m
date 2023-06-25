% Script for calculation of a confidence bands using the cumulative means technique.
% First generate x: a time series with a realization of a Markov process, i.e. some
% model where x_t is dependent on x_{t-1}

%%--------
% Hist regression prm.
bin = [-2 2];
n_bin = 20;
h = (bin(2) - bin(1))/n_bin;
bin_points = (bin(1)+h/2):h:(bin(2)-h/2);
%%--------

%%--------
% Hist regression
% the starting bin
cur_bin=[bin_points(1)-0.5*h bin_points(1)+0.5*h];
% init
lambda=zeros(n_bin,1);
gamma=zeros(n_bin,1);
f_hat=zeros(n_bin,1);

for i=1:n_bin
    index=(x(1:end-1)>cur_bin(1) & x(1:end-1)<=cur_bin(2));
    if (sum(index)>5)
        lambda(i) = sum( x(2:end).*index ) / sum(index);
        % f_hat is needed for confidence band calculation
        f_hat(i) = (n_bin*h)^(-1) * sum(index);
        gamma(i) = sum( (x(2:end) - lambda(i) ).^2 .* index ) / sum(index);
    else
        fprintf('Need more points')
        break
    end

    % move to next bin
    cur_bin=cur_bin+h;
end


% Make confidence bands for the cumulated function. Def. (3.10).
% 95% confidence band, c is found in table 3.1
c = 1.273;

Lambda = cumsum(lambda*h);
h_hat = zeros(n_bin,1);
for i=1:n_bin
    h_hat(i) = gamma(i)/f_hat(i);
end
H_hat = cumsum(h_hat*h);

H_hat_b = H_hat(n_bin);
Lambda_lower = Lambda - c .* n_bin.^(-0.5) .* H_hat_b.^(0.5) .* (1 + H_hat/H_hat_b);
Lambda_upper = Lambda + c .* n_bin.^(-0.5) .* H_hat_b.^(0.5) .* (1 + H_hat/H_hat_b);
%%--------