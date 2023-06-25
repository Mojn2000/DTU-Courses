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
for(t in 2:n){
  if(y[t-1] < 0)
  {
    y[t] <- 2 + 1 * y[t-1] + r[t]
  }
  else
  {
    y[t] <- -2 - 1 * y[t-1] + r[t]
  }
}

## Put it into a data.frame, and make x1 and y1 which are lagged one step 
D <- data.frame(y=y[-1], y1=y[-n], x1=x[-n])

plot(D$y1,D$y,main=expression(SETAR(2,1,1)),ylab=expression(X[t]), xlab=expression(X[t-1]),cex=1)

##------------------------------------------------

## Lets sort the data :)


## CV to get best span
D$xk = D$y1;
D$x = D$y;
d1 = leaveOneOut(D,F)
plot(d1$span,d1$RSSkAll,type='l', main = 'Leave one out CV', xlab=expression(span),ylab=expression(RSSK))
lines(c(0.1,0.1),c(1000,2000),col='red')
legend('bottom',c('CV result','span=0.1'),col=c('black', 'red'),lty=1:1)



# Lets try to fit the model using kernel method
##------------------------------------------------
## Estimate the function with 2D local polynomial regression using loess()
fit <- loess(y ~ y1, data=D, span=0.1)
## Plot the surface with a grid of nPlot x nPlot points
yprd <- predict(fit, data.frame(y1=sort(D$y1)))
## Draw the surface. See ?rgl.material for options
lines(sort(D$y1),yprd,col="Blue",lw=1)
##------------------------------------------------
fit <- loess(y ~ y1, data=D, span=0.3)
yprd <- predict(fit, data.frame(y1=sort(D$y1)))
lines(sort(D$y1),yprd,col="Red",lw=1)

fit <- loess(y ~ y1, data=D, span=0.7)
yprd <- predict(fit, data.frame(y1=sort(D$y1)))
lines(sort(D$y1),yprd,col="Green",lw=1)


x = seq(-8,6,0.2)
y = rep(0,length(x))
for (i in 1:length(x)){
  y[i] = theo_val(x[i])
}

points(x,y,pch=3,cex=1,col="Black")

legend("bottom",c("Theoretical","Span=0.1","Span=0.3","Span=0.7"),lty=c(-1,1,1,1),pch=c(3,-1,-1,-1),col=c("Black","Blue","Red","Green"),cex=1.5)

theo_val <- function(x) {
  if (x<0){
    return (2+x)
  }else{
    return (-2-x)
  }
}

# An increase in alpha means lower variance and vice versa



