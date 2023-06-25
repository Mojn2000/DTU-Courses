setwd("/Users/mads/Google Drev/Skole/Uni/7. semester/Advanced time series/Computer exercise 4")
library(ctsmr)

## Read hospitalized data
AllDat = read.csv("Data/Newly_admitted_over_time.csv",header = T,sep=";")
n <- length(AllDat$Dato)
AllDat$Dato = as.Date(AllDat$Dato)
AllDat$t = 1:n

AllDat$Hos = rep(0,n)
AllDat$Recovered = rep(0,n)
for (i in 1:14) {
  AllDat$Hos[i] = sum(AllDat$Total[1:i])
}
for (i in 15:n) {
  AllDat$Hos[i] = sum(AllDat$Total[1:i]) - sum(AllDat$Total[1:(i-14)])
  AllDat$Recovered[i] = sum(AllDat$Total[1:(i-14)])
}
plot(AllDat$Hos,type='l')
plot(AllDat$Recovered,type='l')


## 
source("SHR.R")
fit1 = SHR(AllDat)
summary(fit1)

par(mfrow=c(1,1))
Pred <- predict(fit1)
fit1$pred <- Pred[[1]]$state$pred$H
fit1$res <- fit1$pred - AllDat$Hos

plot(AllDat$Hos ~ AllDat$t, cex=0.2, pch=19)
lines(fit1$pred ~ AllDat$t)

upr = Pred[[1]]$state$pred$H + Pred[[1]]$state$sd$H*1.96
lwr = Pred[[1]]$state$pred$H - Pred[[1]]$state$sd$H*1.96
lines(upr,col=2,lty=2)
lines(lwr,col=2,lty=2)

plot(AllDat$Dato, fit1$res, main = "Residuals", xlab = "Time", ylab = "Residuals",cex=.2,pch=19)
abline(h=0,col=2)

par(mfrow=c(1,1))
boxplot(fit1$res ~ weekdays(AllDat$Dato))




##
AllDat$yH2 = AllDat$Hos>400;
source("SEIHR.R")
fit2 = SEIHR(AllDat)
summary(fit2)

par(mfrow=c(1,1))
Pred <- predict(fit2)
fit2$pred <- Pred[[1]]$state$pred$H
fit2$res <- fit1$pred - AllDat$Hos

plot(AllDat$Hos ~ AllDat$t, cex=0.2, pch=19)
lines(fit2$pred ~ AllDat$t)

upr = Pred[[1]]$state$pred$H + Pred[[1]]$state$sd$H*1.96
lwr = Pred[[1]]$state$pred$H - Pred[[1]]$state$sd$H*1.96
lines(upr,col=2,lty=2)
lines(lwr,col=2,lty=2)

plot(AllDat$Dato, fit2$res, main = "Residuals", xlab = "Time", ylab = "Residuals",cex=.2,pch=19)
abline(h=0,col=2)

plot(Pred[[1]]$state$pred$I,type='l')
upr = Pred[[1]]$state$pred$I + Pred[[1]]$state$sd$I*1.96
lwr = Pred[[1]]$state$pred$I - Pred[[1]]$state$sd$I*1.96
lines(upr,col=2,lty=2)
lines(lwr,col=2,lty=2)


plot(Pred[[1]]$state$pred$R,type='l')




