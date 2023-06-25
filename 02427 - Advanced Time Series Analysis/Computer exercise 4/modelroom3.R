setwd("/Users/mads/Google Drev/Skole/Uni/7. semester/Advanced time series/Computer exercise 4")
library(ctsmr)

load("AllDat.Rdata")
m = 25
n = length(AllDat$t)
removed = rep(0,(length(AllDat$t)-m))

for (i in 13: (length(AllDat$t)-m) ) {
  removed[i] = AllDat$NewPositive[i-12] + removed[i-1]
}
AllDat$Removed = c(removed,rep(NA,m))

source("BasicSIHR.R")
fit1 <- BasicSIHR(AllDat)
summary(fit1)

Pred <- predict(fit1)
fit1$predPos <- Pred[[1]]$state$pred$I

# train RSS 
fit1$resPos <- fit1$predPos[1:(n-m)] - AllDat$testPos[1:(n-m)]
sqrt(t(fit1$resPos) %*% fit1$resPos / (n-m))

# test RSS
fit1$resPos <- fit1$predPos[(n-m):n] - AllDat$testPos[(n-m):n]
sqrt(t(fit1$resPos) %*% fit1$resPos / m)


plot(AllDat$testPos ~ AllDat$Date, col=2,main="Basic model",ylab="Currently infected",xlab="Date",xlim=c(as.Date("2020-09-01"),as.Date("2020-12-15")))
points(AllDat$EstPos ~ AllDat$Date, col=4)
lines(fit1$predPos ~ AllDat$Date, col=1)
upr = Pred[[1]]$state$pred$I + Pred[[1]]$state$sd$I*1.96
lwr = Pred[[1]]$state$pred$I - Pred[[1]]$state$sd$I*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)
legend("top",c("Prediction","95% conf interval","Train data","Test Data"), lty=c(1,2,-1,-1),pch=c(-1,-1,1,1),col=c(1,3,2,4),cex=1.5)

plot(fit1$resPos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)



fit1$predHos <- Pred[[1]]$state$pred$H
fit1$resHos <- fit1$predHos - AllDat$EstHos

plot(AllDat$testHos ~ AllDat$Date, col = 2)
points(AllDat$EstHos ~ AllDat$Date, col = 3)
lines(fit1$predHos ~ AllDat$Date, col=2)
upr = Pred[[1]]$state$pred$H + Pred[[1]]$state$sd$H*1.96
lwr = Pred[[1]]$state$pred$H - Pred[[1]]$state$sd$H*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)

plot(fit1$resHos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)
t(fit1$resHos) %*% fit1$resHos


## --------------- Include beta as random walk --------------------¨
source("SIHR_Beta.R")
fit2 <- SIHR_Beta(AllDat)
summary(fit2)

Pred <- predict(fit2)
fit2$predPos <- Pred[[1]]$state$pred$I
fit2$resPos <- fit2$predPos - AllDat$EstPos

plot(AllDat$testPos ~ AllDat$Date, col=2,main="Beta as state",ylab="Currently infected",xlab="Date",xlim=c(as.Date("2020-09-01"),as.Date("2020-12-15")))
points(AllDat$EstPos ~ AllDat$Date, col=4)
lines(fit2$predPos ~ AllDat$Date, col=1)
upr = Pred[[1]]$state$pred$I + Pred[[1]]$state$sd$I*1.96
lwr = Pred[[1]]$state$pred$I - Pred[[1]]$state$sd$I*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)
legend("top",c("Prediction","95% conf interval","Train data","Test Data"), lty=c(1,2,-1,-1),pch=c(-1,-1,1,1),col=c(1,3,2,4),cex=1.5)


plot(fit2$resPos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)

t(fit2$resPos) %*% fit2$resPos

plot(Pred[[1]]$state$pred$Beta)


# train RSS 
fit2$resPos <- fit2$predPos[1:(n-m)] - AllDat$testPos[1:(n-m)]
sqrt(t(fit2$resPos) %*% fit2$resPos / (n-m))

# test RSS
fit2$resPos <- fit2$predPos[(n-m):n] - AllDat$testPos[(n-m):n]
sqrt(t(fit2$resPos) %*% fit2$resPos / m)



## --------------- Look at weather data --------------------
load("DMIData.Rdata")
DMIData$DateTime = as.Date(DMIData$DateTime)
# Start approx 02-20
meanTemp = DMIData$Middel[DMIData$DateTime>= as.Date("2020-02-17") & DMIData$DateTime <= as.Date("2020-12-03")]
length(AllDat$EstPos) - length(meanTemp) 

# Lets try to include mean temperature in the model
aveTemp = rep(0,length(meanTemp))
for (i in 10:length(meanTemp)) {
  aveTemp[i] = meanTemp[i] - ave(meanTemp[(i-10):i])[1]
}


plot((Pred[[1]]$state$pred$Beta) ~ aveTemp[1:length(Pred[[1]]$state$pred$Beta)],ylab=expression(beta),xlab=expression(tau))

AllDat$meanTemp = meanTemp
AllDat$aveTemp = aveTemp
abline(lm(Pred[[1]]$state$pred$Beta ~ aveTemp))
summary(lm(Pred[[1]]$state$pred$Beta ~ aveTemp))

cor(aveTemp, exp(Pred[[1]]$state$pred$Beta)/1E6)
#12 : -0.2119761
#14 : -0.2721696
#15 : -0.3339599
#16 : -0.3731141
#17 : -0.3875987
#18 : -0.3530692
#20 : -0.2143247
#22 : -0.1447145
#24 : -0.04244483


## --------------- Include weather data --------------------
source("SIHR_Weather.R")
fit3 <- SIHR_Weather(AllDat)
summary(fit3)

dim(fit3$corr)
266*log(12)-2*log(-fit3$loglik)

Pred <- predict(fit3)
fit3$predPos <- Pred[[1]]$state$pred$I
fit3$resPos <- fit3$predPos - AllDat$EstPos

plot(AllDat$testPos ~ AllDat$Date, col=2,main="Weather data",ylab="Currently infected",xlab="Date",xlim=c(as.Date("2020-09-01"),as.Date("2020-12-15")))
points(AllDat$EstPos ~ AllDat$Date, col=4)
lines(fit3$predPos ~ AllDat$Date, col=1)
upr = Pred[[1]]$state$pred$I + Pred[[1]]$state$sd$I*1.96
lwr = Pred[[1]]$state$pred$I - Pred[[1]]$state$sd$I*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)
legend("top",c("Prediction","95% conf interval","Train data","Test Data"), lty=c(1,2,-1,-1),pch=c(-1,-1,1,1),col=c(1,3,2,4),cex=1.5)



plot(fit3$resPos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)

# train RSS 
fit3$resPos <- fit3$predPos[1:(n-m)] - AllDat$testPos[1:(n-m)]
sqrt(t(fit3$resPos) %*% fit3$resPos / (n-m))

# test RSS
fit3$resPos <- fit3$predPos[(n-m):n] - AllDat$testPos[(n-m):n]
sqrt(t(fit3$resPos) %*% fit3$resPos / m)




## --------------- Include weather data and beta const --------------------
source("SIHR_Weather_Beta.R")
fit4 <- SIHR_Weather_Beta(AllDat)
summary(fit4)

Pred <- predict(fit4)
fit4$predPos <- Pred[[1]]$state$pred$I
fit4$resPos <- fit4$predPos - AllDat$EstPos

plot(AllDat$testPos ~ AllDat$Date, col=2,main="Beta as state and weather",ylab="Currently infected",xlab="Date",xlim=c(as.Date("2020-09-01"),as.Date("2020-12-15")))
points(AllDat$EstPos ~ AllDat$Date, col=4)
lines(fit4$predPos ~ AllDat$Date, col=1)
upr = Pred[[1]]$state$pred$I + Pred[[1]]$state$sd$I*1.96
lwr = Pred[[1]]$state$pred$I - Pred[[1]]$state$sd$I*1.96
lines(upr ~ AllDat$Date,col=3,lty=2)
lines(lwr ~ AllDat$Date,col=3,lty=2)
legend("top",c("Prediction","95% conf interval","Train data","Test Data"), lty=c(1,2,-1,-1),pch=c(-1,-1,1,1),col=c(1,3,2,4),cex=1.5)

plot(fit4$resPos ~ AllDat$Date, cex=.2, pch=19)
abline(h=0,col=2)

t(fit1$resPos) %*% fit1$resPos
t(fit2$resPos) %*% fit1$resPos
t(fit3$resPos) %*% fit3$resPos
t(fit4$resPos) %*% fit3$resPos

plot(na.omit(Pred[[1]]$state$pred$Beta ))


# train RSS 
fit4$resPos <- fit4$predPos[1:(n-m)] - AllDat$testPos[1:(n-m)]
sqrt(t(fit4$resPos) %*% fit4$resPos / (n-m))

# test RSS
fit4$resPos <- fit4$predPos[(n-m):n] - AllDat$testPos[(n-m):n]
sqrt(t(fit4$resPos) %*% fit4$resPos / m)

