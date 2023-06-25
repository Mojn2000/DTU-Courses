# Simulate SETAR(2,1,1) model (code taken from 3dPlotting.R given in the exercise)

##------------------------------------------------
## Make some data
## Number of samplepoints
n <- 1000

## Parameter random-ness
phi1 <- rnorm(n,mean=0.3,sd=0.5)
phi2 <- rnorm(n,mean=0.7,sd=0.25)
theta1 <- rnorm(n,mean=0.2,sd=1)
e <- rnorm(n,mean=0,sd=1)

## Make a time series y with a regime model
x1 <- rep(0,n)
x2 <- rep(0,n)
x1[1] <- rnorm(1)
x2[1] <- rnorm(1)
for(t in 2:n){
  x1[t] = -phi1[t]*x1[t-1]+x2[t-1]+e[t]
  x2[t] = -phi2[t]*x1[t-1]+theta1[t]*e[t]
}
y = x1
plot(y,type='l')


arima(y,c(2,0,1))



plot(y[1:(length(y)-1)],y[2:length(y)],cex=0.2,pch=19,xlab=expression(X[t-1]),ylab=expression(X[t]))
##------------------------------------------------


