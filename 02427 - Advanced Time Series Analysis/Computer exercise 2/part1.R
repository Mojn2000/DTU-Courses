# Simulate SETAR(2,1,1) model (code taken from 3dPlotting.R given in the exercise)

##------------------------------------------------
## Make some data
## Number of samplepoints
n <- 1000
## Uniform distributed x
x <- runif(n,-1,1)
## Errors
r <- rnorm(n)
## Make a time series y with a regime model
y <- rep(NA,n)
y[1] <- r[1]
for(t in 2:n)
{
  if(y[t-1] < 0)
  {
    y[t] <- 2 + y[t-1] + r[t]
  }
  else
  {
    y[t] <- -2 - y[t-1] + r[t]
  }
}

plot(y[1:(length(y)-1)],y[2:length(y)],cex=0.2,pch=19,xlab=expression(X[t-1]),ylab=expression(X[t]))
##------------------------------------------------


# Optimize parameters
opt <- optim(c(-2,-1,2,1,4), method = "SANN", fn = RSSSetar)
opt <- optim(opt$par, method = "BFGS", fn = RSSSetar, hessian = TRUE)
opt$par
opt


x = seq(min(y),max(y),0.01)
y_fit = rep(0,length(x))
for (i in 1:length(x)){
  y_fit[i] = fit(x[i],opt)
}


lines(x,y_fit,cex=0.2,pch=19,xlab=expression(X[t-1]),ylab=expression(X[t]))




fit <- function(x,opt) {
  if (x < opt$par[5]){
    return (opt$par[1] + opt$par[2]*x)
  }
  else {
    return (opt$par[3] + opt$par[4]*x)
  }
}

RSSSetar <- function(par) {
  # alpha and beta of model 1
  p1 <- par[1]
  p2 <- par[2]
  
  # alpha and beta of model 2
  p3 <- par[3]
  p4 <- par[4]
  
  # regime change
  r <- par[5]
  
  ## Calculate the objective function value
  y_temp = rep(0,n);
  
  for(t in 2:n) {
    if(y[t-1] < r) {
      y_temp[t] <- p1 + p2*y[t-1]
    }
    else {
      y_temp[t] <- p3 + p4*y[t-1]
    }
  }
  return (t(y_temp-y) %*% (y_temp-y))
}