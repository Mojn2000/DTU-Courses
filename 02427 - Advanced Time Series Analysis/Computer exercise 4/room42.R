setwd("/Users/mads/Google Drev/Skole/Uni/7. semester/Advanced time series/Computer exercise 4")
source("SIHR_Beta2.R")
fit21 <- SIHR_Beta2(AllDat,-5)
fit22 <- SIHR_Beta2(AllDat,-4)
fit23 <- SIHR_Beta2(AllDat,-3)
fit24 <- SIHR_Beta2(AllDat,-2)
fit25 <- SIHR_Beta2(AllDat,-1)


plot(AllDat$testPos ~ AllDat$Date, col=2,main="Effect of p5",ylab="Currently infected",xlab="Date",xlim=c(as.Date("2020-09-01"),as.Date("2020-12-15")))
points(AllDat$EstPos ~ AllDat$Date, col=1)
Pred <- predict(fit21)
lines(Pred[[1]]$state$pred$I ~ AllDat$Date, col=2)
Pred <- predict(fit22)
lines(Pred[[1]]$state$pred$I ~ AllDat$Date, col=3)
Pred <- predict(fit23)
lines(Pred[[1]]$state$pred$I ~ AllDat$Date, col=4)
Pred <- predict(fit24)
lines(Pred[[1]]$state$pred$I ~ AllDat$Date, col=5)
Pred <- predict(fit25)
lines(Pred[[1]]$state$pred$I ~ AllDat$Date, col=6)
legend("top",c(expression(e^{-5}),expression(e^{-4}),expression(e^{-3}),expression(e^{-2}),expression(e^{-1})), lty=1,col=2:6,cex=1.5)



fit21 <- SIHR_Weather_Beta2(AllDat,-5)
fit22 <- SIHR_Weather_Beta2(AllDat,-4)
fit23 <- SIHR_Weather_Beta2(AllDat,-3)
fit24 <- SIHR_Weather_Beta2(AllDat,-2)
fit25 <- SIHR_Weather_Beta2(AllDat,-1)


plot(AllDat$testPos ~ AllDat$Date, col=2,main="Effect of p5",ylab="Currently infected",xlab="Date",xlim=c(as.Date("2020-09-01"),as.Date("2020-12-15")))
points(AllDat$EstPos ~ AllDat$Date, col=1)
Pred <- predict(fit21)
lines(Pred[[1]]$state$pred$I ~ AllDat$Date, col=2)
Pred <- predict(fit22)
lines(Pred[[1]]$state$pred$I ~ AllDat$Date, col=3)
Pred <- predict(fit23)
lines(Pred[[1]]$state$pred$I ~ AllDat$Date, col=4)
Pred <- predict(fit24)
lines(Pred[[1]]$state$pred$I ~ AllDat$Date, col=5)
Pred <- predict(fit25)
lines(Pred[[1]]$state$pred$I ~ AllDat$Date, col=6)
legend("top",c(expression(e^{-5}),expression(e^{-4}),expression(e^{-3}),expression(e^{-2}),expression(e^{-1})), lty=1,col=2:6,cex=1.5)

n-m
dim(fit22$corr)


266*log(13)-2*log(-fit22$loglik)

