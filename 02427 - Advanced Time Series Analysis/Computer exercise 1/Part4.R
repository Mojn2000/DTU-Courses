
# Set working directory and read data
setwd("/Users/mads/Google Drev/Skole/Uni/7. semester/Advanced time series/Computer exercise 1/comp_ex_1_scrips_2018")
D2 <- read.csv("DataPart4.csv")

# Estimate Ua(W_t)
D2$Ut <- D2$Ph/(D2$Ti-D2$Te);
par(mfrow=c(1,1))
plot(D2$W,D2$Ut,ylim=c(100,250),cex=0.5)

D2$xk <- D2$W;
D2$x <- D2$Ut;
#leaveOneOut(D2,plotIt = F)

# Lets try to fit the model using kernal method
##------------------------------------------------
## Estimate the function with 2D local polynomial regression using loess()
D2$W.sorted <- sort(D2$W)
fit <- loess(Ut ~ W, data = D2, span=0.778,parametric = F)
## Plot the surface with a grid of nPlot x nPlot points
yprd <- predict(fit, data.frame(W=D2$W.sorted))
## Draw the surface. See ?rgl.material for options
lines(D2$W.sorted,yprd,col="Blue",lw=2)
##------------------------------------------------