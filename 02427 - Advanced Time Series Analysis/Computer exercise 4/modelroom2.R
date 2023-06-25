setwd("/Users/mads/Google Drev/Skole/Uni/7. semester/Advanced time series/Computer exercise 4")
library(ctsmr)

load("AllDat.Rdata")
removed = rep(0,length(AllDat$t))

for (i in 13:length(AllDat$t)) {
  removed[i] = AllDat$NewPositive[i-12] + removed[i-1]
}
AllDat$Removed = removed

source("SIHR.R")
fit1 <- SIHR(AllDat)
summary(fit1)

Pred <- predict(fit1)
fit1$predPos <- Pred[[1]]$state$pred$I
fit1$resPos <- fit1$predPos - AllDat$EstPos


plot(AllDat$EstPos ~ AllDat$Date, cex=0.2, pch=19)
lines(fit1$predPos ~ AllDat$Date, col=2)
upr = Pred[[1]]$state$pred$I + Pred[[1]]$state$sd$I*1.96
lwr = Pred[[1]]$state$pred$I - Pred[[1]]$state$sd$I*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)

plot(fit1$resPos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)

t(fit1$resPos) %*% fit1$resPos


fit1$predHos <- Pred[[1]]$state$pred$H
fit1$resHos <- fit1$predHos - AllDat$EstHos

plot(AllDat$EstHos ~ AllDat$Date, cex=0.2, pch=19)
lines(fit1$predHos ~ AllDat$Date, col=2)
upr = Pred[[1]]$state$pred$H + Pred[[1]]$state$sd$H*1.96
lwr = Pred[[1]]$state$pred$H - Pred[[1]]$state$sd$H*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)

plot(fit1$resHos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)
t(fit1$resHos) %*% fit1$resHos


## Load weather data
load("DMIData.Rdata")
DMIData$DateTime = as.Date(DMIData$DateTime)

meanTemp = DMIData$Middel[DMIData$DateTime>= as.Date("2020-02-25") & DMIData$DateTime <= as.Date("2020-11-17")]

plot(fit1$resPos ~ meanTemp,pch=19,cex=.3)
plot(fit1$resHos ~ meanTemp,pch=19,cex=.3)

# Lets try to include mean temperature in the model
AllDat$meanTemp = meanTemp
source("SIHR2.R")
fit2 <- SIHR2(AllDat)
summary(fit2)

Pred <- predict(fit2)
fit2$predPos <- Pred[[1]]$state$pred$I
fit2$resPos <- fit2$predPos - AllDat$EstPos


plot(AllDat$EstPos ~ AllDat$Date, cex=0.2, pch=19)
lines(fit2$predPos ~ AllDat$Date, col=2)
upr = Pred[[1]]$state$pred$I + Pred[[1]]$state$sd$I*1.96
lwr = Pred[[1]]$state$pred$I - Pred[[1]]$state$sd$I*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)

plot(fit2$resPos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)


fit2$predHos <- Pred[[1]]$state$pred$H
fit2$resHos <- fit2$predHos - AllDat$EstHos

plot(AllDat$EstHos ~ AllDat$Date, cex=0.2, pch=19)
lines(fit2$predHos ~ AllDat$Date, col=2)
upr = Pred[[1]]$state$pred$H + Pred[[1]]$state$sd$H*1.96
lwr = Pred[[1]]$state$pred$H - Pred[[1]]$state$sd$H*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)

plot(fit2$resHos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)

t(fit2$resHos) %*% fit2$resHos


# Let's try to implement beta as a random walk 
source("SIHR3.R")
fit3 <- SIHR3(AllDat)
summary(fit3)

Pred <- predict(fit3)

plot(exp(Pred[[1]]$state$pred$Beta)/1E6 ~ AllDat$Date,type='l')
abline(h=1/5.7E6,col=2)
abline(v=as.Date("2020-03-17"),col=3,lty=2)
abline(v=as.Date("2020-04-20"),col=2,lty=2)
abline(v=as.Date("2020-05-27"),col=2,lty=2)
abline(v=as.Date("2020-08-22"),col=3,lty=2)
abline(v=as.Date("2020-09-17"),col=3,lty=2)
abline(v=as.Date("2020-10-23"),col=3,lty=2)
abline(v=as.Date("2020-11-5"),col=3,lty=2)
lines(exp(Pred[[1]]$state$pred$Beta[strftime(AllDat$Date, format ="%V") == 42])/1E6 ~ AllDat$Date[strftime(AllDat$Date, format ="%V") == 42],col="yellow")



fit3$predPos <- Pred[[1]]$state$pred$I
fit3$resPos <- fit3$predPos - AllDat$EstPos

plot(AllDat$EstPos ~ AllDat$Date, cex=0.2, pch=19)
lines(fit3$predPos ~ AllDat$Date, col=2)
upr = Pred[[1]]$state$pred$I + Pred[[1]]$state$sd$I*1.96
lwr = Pred[[1]]$state$pred$I - Pred[[1]]$state$sd$I*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)

plot(fit3$resPos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)
t(fit3$resPos) %*% fit3$resPos

plot(exp(Pred[[1]]$state$pred$Beta)/1E6 ~ AllDat$meanTemp)
plot(fit3$resPos ~ AllDat$meanTemp)



# Let's try to implement beta as a random walk 
source("SIHR4.R")
fit4 <- SIHR4(AllDat)
summary(fit4)

  
Pred <- predict(fit4)
plot(1/(1+exp(-Pred[[1]]$state$pred$HF/10)) ~ AllDat$Date,type='l')


fit4$predPos <- Pred[[1]]$state$pred$I
fit4$resPos <- fit4$predPos - AllDat$EstPos

plot(AllDat$EstPos ~ AllDat$Date, cex=0.2, pch=19)
lines(fit4$predPos ~ AllDat$Date, col=2)
upr = Pred[[1]]$state$pred$I + Pred[[1]]$state$sd$I*1.96
lwr = Pred[[1]]$state$pred$I - Pred[[1]]$state$sd$I*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)

plot(fit4$resPos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)
t(fit4$resPos) %*% fit4$resPos


fit4$predHos <- Pred[[1]]$state$pred$H
fit4$resHos <- fit4$predHos - AllDat$EstHos

plot(AllDat$EstHos ~ AllDat$Date, cex=0.2, pch=19)
lines(fit4$predHos ~ AllDat$Date, col=2)
upr = Pred[[1]]$state$pred$H + Pred[[1]]$state$sd$H*1.96
lwr = Pred[[1]]$state$pred$H - Pred[[1]]$state$sd$H*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)
plot(fit4$resHos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)

t(fit4$resHos) %*% fit4$resHos

RtHosData = read.csv("data/Rt_indlagte_2020_11_24.csv",header = T,sep=";",dec=",")
RtHosData$Date = as.Date(RtHosData$date_sample)


gammaI = 8.7947e-02;
kontatktTal = (exp(Pred[[1]]$state$pred$Beta)/1E6) * Pred[[1]]$state$pred$S  / gammaI



plot(kontatktTal ~ AllDat$Date, type='l',ylim=c(0,3))
abline(h=1,col=2)

lines(RtHosData$estimate ~ RtHosData$Date,col=3)
plot(Pred[[1]]$state$pred$H,type='l')




