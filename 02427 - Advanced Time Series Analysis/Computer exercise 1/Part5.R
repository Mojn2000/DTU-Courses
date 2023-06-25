# Set working directory and read data
setwd("/Users/mads/Google Drev/Skole/Uni/7. semester/Advanced time series/Computer exercise 1/comp_ex_1_scrips_2018")
D3 <- read.csv("DataPart5.csv")
plot(D3$x)

# Find autocorrelation and partial-autocorrelataion
par(mfrow=c(2,1))
acf(D3$x, main = 'Initial test', 14)
pacf(D3$x, main = '', 15)

## Add a MA(1) term
tsData <- ts(D3$x, frequency = 2)
mod1 <- arima(tsData, order=c(0,0,0), seasonal = c(1,0,0))

par(mfrow=c(1,1))
acf(mod1$residuals, 15, main = 'Residuals of (0,0,0)(1,0,0)[2] model')
pacf(mod1$residuals, 15, main='')

res_temp = na.omit(mod1$residuals)
layout(matrix(c(1,1,2,3), nrow = 2, ncol = 2, byrow = TRUE))
plot(res_temp, ylab = "Residuals", xlab="Time [Years]", main = "Residuals for (0,0,0)(0,0,1)[2]")
abline(h = 0, lty = 1, col = "blue", lw = 2)
abline(h = sd(res_temp)*1.96, lty = 2, col = "blue", lw = 1)
abline(h = -sd(res_temp)*1.96, lty = 2, col = "blue", lw = 1)
nlag <- length(res_temp)
pval <- sapply(1:nlag, function(i) Box.test(res_temp, i, type = "Ljung-Box")$p.value)
plot(1L:nlag, pval, xlab = "lag", ylab = "p value", ylim = c(0,1), main = "p values for Ljung-Box statistic", type="l")
abline(h = 0.05, lty = 2, col = "blue")
qqPlot(res_temp, ylab = "Residuals",main="qqPlot")


## Plot the data together with the found model
plot(tsData)
fit <- D3$x - mod1$residuals
lines(fit,col="green")

LDF = rep(0,6);
for (i in 1:6) {
#  LDF[i] = ldf(mod1$residuals,i)
}

plot(1:6,LDF,type='l',xlab='Lag',main='Dependency')

# Look at the residuals 
par(mfrow=c(1,1))
n <- length(mod1$residuals)
err <- mod1$residuals[1:(n-2)] - mod1$residuals[(1+2):n]
plot(mod1$residuals[1:(n-2)],mod1$residuals[(1+2):n],xlab=expression(R[t-2]),ylab=expression(R[t]),main='Dependency of residuals')


# Lets check the original data
et <- D3$x[3:n]
et2 <- D3$x[1:(n-2)]
plot(et2,et,xlab=expression(X[t-2]),ylab=expression(X[t]), main = 'Dependency of original data')

## We see that a SETAR(4,2,1) could be a good model

# We can "fit" this using a kernal method
##------------------------------------------------
## Estimate the function with 2D local polynomial regression using loess()
fit <- loess(et ~ et2, span=0.3,parametric = F)
## Plot the surface with a grid of nPlot x nPlot points
yprd <- predict(fit, data.frame(et2=sort(et2)))
## Draw the surface. See ?rgl.material for options
lines(sort(et2),yprd,col="Blue",lw=2)
##------------------------------------------------

## Lets try to fit the original data
yprd2 <- predict(fit, data.frame(et2=et2))
plot(et,yprd2)

## Eye-balled model
et2.sorted = sort(et2)
theo <- rep(0,length(et2))
for (i in 1:length(et2)){
  theo[i] <- theo_val(et2.sorted[i])
}

## Plot everything together
plot(et2,et,xlab=expression(X[t-2]),ylab=expression(X[t]), main = 'Final model')
lines(sort(et2),yprd,col="Blue",lw=2)
lines(et2.sorted,theo,col="red",lw=2)
legend("bottom",c("Measurements","Kernal estimate","SETAR model"),lty=c(-1,1,1),pch=c(1,-1,-1),col=c(1,"blue","red"))


index = (2 < et2) & (et2 < 5)
plot(et2[index],et[index])
fit1 <- lm(et[index] ~ et2[index])
fit1

theo_val <- function(x) {
  if (x<(-2)){
    return (-0.680*x + 2.281)
  } else if (x>=-2 && x<2) {
    return (2.7342*x+0.9009)
  } else if (x>=2 && x<5) {
    return (0.804*x-1.002)
  } else{
    return (1.020*x-5.996)
  }
}
