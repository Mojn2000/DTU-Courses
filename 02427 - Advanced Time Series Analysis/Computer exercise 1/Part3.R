# Import libraries
#library("rgl")

## Part
# Simulate SETAR(2,1,1) model (code taken from 3dPlotting.R given in the exercise)

##------------------------------------------------
## Make some data
## Number of samplepoints
n <- 1000
## Uniform distributed x
x <- runif(n,-1,1)
## Errors
r <- rnorm(n,sd=1)
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

## Put it into a data.frame, and make x1 and y1 which are lagged one step 
D <- data.frame(y=y[-1], y1=y[-n], x1=x[-n])


plot(D$y1,D$y,cex=0.2)

##------------------------------------------------

# Lets try to fit the model using kernal method
sorted.y1 <- sort(D$y1) 
newX = seq(min(D$y1),max(D$y1),0.01)
##------------------------------------------------
## Estimate the function with 2D local polynomial regression using loess()
fit <- loess(y ~ y1, dat=D, span=0.1)
## Plot the surface with a grid of nPlot x nPlot points
yprd <- predict(fit, data.frame(y1=newX))
## Draw the surface. See ?rgl.material for options
lines(newX,yprd,col="Blue",lw=2)
##------------------------------------------------

## Numerical integration of the fitting values
integral <- rep(0,length(newX))
s = 0
for (i in 1:length(yprd)){
  s = s + yprd[i]
  print(s)
  integral[i] = (s/i)*(newX[i]-newX[1])
}

## Plot the empirical integral along with the fit and the data
plot(newX,integral,type='l',ylim=c(-30,4), col='Blue',main="Cumulative conditional mean",ylab=expression(X[t]), xlab=expression(X[t-1]))
points(D$y1,D$y,cex=0.1,pch=19)
lines(newX,yprd,col="Red")

## Find the theoretical integral
theo <- rep(0,length(sorted.y1))
for (i in 1:length(sorted.y1)){
  theo[i] <- theo_integral(sorted.y1[i])
}

lines(sorted.y1,theo,col="green")

legend("bottom",c("Prediction","Fit (span=0.1)","Emperical integral","Theoretical integral"),pch=c(19,-1,-1,-1),lty=c(-1,1,1,1),col=c("black","red","blue","green"))

theo_integral <- function(x) {
  if (x<0){
    return (2*x - 16. + 0.5*x^2)
  }
  else {
    return(-16. - 2*x - 0.5*x^2)
  }
}


