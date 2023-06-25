##----------------------------------------------------------------
## Script for calculation of a confidence bands using the cumulative means technique.
## First generate x: a time series with a realization of a Markov process, i.e. some
## model where x_t is dependent on x_{t-1}

## Parameters for the histogram regression
## Number of intervals 
n.bin <- 20
## The breaks between the intervals 
breaks <- seq(-2,2,len=n.bin+1)
## Initialize
h <- diff(breaks)[1]
lambda <- gamma <- f.hat <- h.hat <- numeric(n.bin)
##----------------------------------------------------------------


##----------------------------------------------------------------
## Cut into intervals conditioned on x_{t-1}
L <- split(x[-1], cut(x[-length(x)],breaks))
## Check if there are at least 5 points in each interval
if(!all(sapply(L,length)>=5)){ print('Stopped: There are less than 5 points in one of the intervals'); break;}
## Calc the hist regressogram, i.e. for each interval
for(i in 1:n.bin)
  {
    x.bin <- L[[i]]
    lambda[i] <- mean(x.bin)
    f.hat[i] <- (n.bin*h)^(-1) * length(x.bin)
    gamma[i] <- sum((x.bin - lambda[i])^2) / length(x.bin)
  }
## Make confidence bands for the cumulated function. Def. (3.10).
## 95% confidence band, c is found in table 3.1
c.alpha <- 1.273
##
Lambda <- cumsum(lambda*h)
for(i in 1:n.bin)
  {
    h.hat[i] <- gamma[i]/f.hat[i];
  }
H.hat <- cumsum(h.hat*h);
##
H.hat.b <- H.hat[n.bin];
Lambda.lower <- Lambda - c.alpha * n.bin^(-0.5) * H.hat.b^(0.5) * (1 + H.hat/H.hat.b);
Lambda.upper <- Lambda + c.alpha * n.bin^(-0.5) * H.hat.b^(0.5) * (1 + H.hat/H.hat.b);
##----------------------------------------------------------------

