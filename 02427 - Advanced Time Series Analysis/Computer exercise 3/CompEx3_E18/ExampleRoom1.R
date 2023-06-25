setwd("/Users/mads/Google Drev/Skole/Uni/7. semester/Advanced time series/Computer exercise 3/CompEx3_E18")
library(ctsmr)
library(splines)

load("Exercise3.RData")
AllDat

source("sdeTiTm.R")
fit1 <- sdeTiTm(AllDat,AllDat$yTi1,AllDat$Ph1)



# summary(fit1,extended=TRUE)

Hour <- as.numeric(strftime(AllDat$date, format="%H"))

# Pred <- predict(fit1)
# plot(Pred[[1]]$state$pred$Ti - AllDat$yTi1 ~ Hour)
# What is going on 10 AM?
# Try to fir a varying effective window area

plot(AllDat$Gv ~ Hour)


idx <- (Hour>6 & Hour < 21) # It is impossible to fit a window area for the hours without any sun, so we limit the window area estimation to the hours with sun.
bs = bs(Hour[idx],df=5,intercept=TRUE) 


bs1 <- bs2 <- bs3 <- bs4 <- bs5 <- bs6 <- bs7 <- numeric(dim(AllDat)[1])

bs1[idx] = bs[,1]
bs2[idx] = bs[,2]
bs3[idx] = bs[,3]
bs4[idx] = bs[,4]
bs5[idx] = bs[,5]
bs6[idx] = bs[,6]
bs7[idx] = bs[,7]

# What does the splines look like?
plot(bs1[15:38],type='l',col=1,ylab="",xlab="Hour of the day")
lines(bs2[15:38],col=2)
lines(bs3[15:38],col=3)
lines(bs4[15:38],col=4)
lines(bs5[15:38],col=5)
legend("topleft",c("Spline 1","Spline 2","Spline 3","Spline 4","Spline 5"),lty=1,col=1:5,cex=1.5)


AllDat$bs1 = bs1
AllDat$bs2 = bs2
AllDat$bs3 = bs3
AllDat$bs4 = bs4
AllDat$bs5 = bs5
AllDat$bs6 = bs6
AllDat$bs7 = bs7


## ------------------------------------------------
### You will have to implement sdeTITmAv ###
source("sdeTiTmAv.R")
fit2 <- sdeTiTmAv(AllDat,AllDat$yTi1,AllDat$Ph1)
summary(fit2, extended = T)

BIC = log(3111)*dim(fit2$corr)[1] - 2*fit2$loglik
BIC
# BIC using 5 splines = 940.48

#plot(bs[14:27,1]*fit2$xm[3]+bs[14:27,2]*fit2$xm[4]+bs[14:27,3]*fit2$xm[5]+bs[14:27,4]*fit2$xm[6]+bs[14:27,5]*fit2$xm[7],type='l')

Pred <- predict(fit2)
fit2$res = Pred[[1]]$state$pred$Ti - AllDat$yTi1;
boxplot(Pred[[1]]$state$pred$Ti - AllDat$yTi1 ~ Hour, cex = 0.2,pch=3,ylab="Residuals [°C]",main="Spline 1 & 3",ylim=c(-2,2))
abline(h=0, col = 2)



count = 0;
day = rep(0,length(Hour))
for (i in 1:length(Hour)) {
  if (Hour[i] == 0){
    count = count + 1;
  }
  day[i] = count %% 7
}


# Plot for mondays
boxplot(fit2$res[day==6] ~ Hour[day==6], cex = 0.2,pch=3,ylab="Residuals [°C]",ylim=c(-2,2))
abline(h=0, col = 2)




## Let part of the heating enter directly into the thermal mass
source("sdeTiTmAvPm.R")
fit3 <- sdeTiTmAvPm(AllDat,AllDat$yTi1,AllDat$Ph1)
summary(fit3, extended = T)

BIC = log(3111)*dim(fit3$corr)[1] - 2*fit3$loglik
BIC

Pred <- predict(fit3)
fit3$res = Pred[[1]]$state$pred$Ti - AllDat$yTi1;
boxplot(fit3$res ~ Hour,ylim=c(-2,2),cex = 0.2,pch=3)
abline(h=0, col = 2)

# this was a bad idea, lets try to use a varibles to model heat instead


source("sdeTiTmAvVarHeat.R")
fit4 <- sdeTiTmAvVarHeat(AllDat,AllDat$yTi1,AllDat$Ph1)
summary(fit4, extended = T)

BIC = log(3111)*dim(fit4$corr)[1] - 2*fit4$loglik
BIC

Pred <- predict(fit4)
fit4$res = Pred[[1]]$state$pred$Ti - AllDat$yTi1;
boxplot(fit4$res ~ Hour,ylim=c(-2,2),cex = 0.2,pch=3)
abline(h=0, col = 2)


## We can now include room 2 as boundary as a new state
source("sdeTiTmAv2rooms.R")
fit5 <- sdeTiTmAv2rooms(AllDat,AllDat$yTi1,AllDat$yTi2,AllDat$Ph1)
summary(fit5, extended = T)

BIC = log(3111)*dim(fit5$corr)[1] - 2*fit5$loglik
BIC

Pred <- predict(fit5)
fit5$res = Pred[[1]]$state$pred$Ti1 - AllDat$yTi1;
boxplot(fit5$res ~ Hour,ylim=c(-2,2),cex = 0.2,pch=3)
abline(h=0, col = 2)


# fit5$res = Pred[[1]]$state$pred$Ti2 - AllDat$yTi2;
# boxplot(fit5$res ~ Hour,ylim=c(-2,2),cex = 0.2,pch=3)
# abline(h=0, col = 2)



t(fit4$res) %*% fit4$res
t(fit5$res) %*% fit5$res












## Weekly res
plot(day + runif(length(Hour),-0.2,0.2),Pred[[1]]$state$pred$Ti - AllDat$yTi1, cex = 0.2,pch=3)


## Plot for mondays
sDay = 2
plot(Hour[day==sDay]+rep(-0.2,length(Hour[day==sDay])),fit2$res[day==sDay],cex=.4,ylim=c(-2,2))
for (sDay in 1:4) {
  points(Hour[day==sDay]+rep(-0.2+sDay/10,length(Hour[day==sDay])),fit2$res[day==sDay],col=sDay+1,cex=.4)
}
abline(h=0, col = 2)


## ------------------------------------------------
## Let model know student are present
AllDat$stud = Hour>=9 & Hour<=20 & day<=4

source("sdeTiTmAvStud.R")
fit3 <- sdeTiTmAvStud(AllDat,AllDat$yTi1,AllDat$Ph1)
summary(fit3, extended = T)

Pred <- predict(fit3)
fit3$res = Pred[[1]]$state$pred$Ti - AllDat$yTi1;
plot(Hour+runif(length(Hour),-0.2,0.2), Pred[[1]]$state$pred$Ti - AllDat$yTi1, cex = 0.2,pch=3)
abline(h=0, col = 2)

## Plot for mondays
plot(Hour[day==sDay]+rep(-0.2,length(Hour[day==sDay])),fit3$res[day==sDay],cex=.4,ylim=c(-2,2))
for (sDay in 1:4) {
  points(Hour[day==sDay]+rep(-0.2+sDay/10,length(Hour[day==sDay])),fit3$res[day==sDay],col=sDay+1,cex=.4)
}
abline(h=0, col = 2)


fit3$loglik
fit2$loglik

## ------------------------------------------------
fit4 <- sdeTiTmAvStudAi2(AllDat,AllDat$yTi1,AllDat$Ph1)
summary(fit4, extended = T)

Pred <- predict(fit4)
fit4$res = Pred[[1]]$state$pred$Ti - AllDat$yTi1;
plot(Hour+runif(length(Hour),-0.2,0.2), Pred[[1]]$state$pred$Ti - AllDat$yTi1, cex = 0.2,pch=3)
abline(h=0, col = 2)



## ------------------------------------------------
fit5 <- sdeTiTmAvStudTStud(AllDat,AllDat$yTi1,AllDat$Ph1)
summary(fit5, extended = T)

Pred <- predict(fit5)
fit5$res = Pred[[1]]$state$pred$Ti - AllDat$yTi1;
plot(Hour+runif(length(Hour),-0.2,0.2), fit5$res, cex = 0.2,pch=3)
abline(h=0, col = 2)


## ------------------------------------------------
fit6 <- sdeTiTmAvStudDoor(AllDat,AllDat$yTi1,AllDat$Ph1)
summary(fit6, extended = T)

Pred <- predict(fit6)
fit6$res = Pred[[1]]$state$pred$Ti - AllDat$yTi1;
plot(Hour+runif(length(Hour),-0.2,0.2), fit6$res, cex = 0.2,pch=3)
abline(h=0, col = 2)
 
sDay = 0
plot(Hour[day==sDay]+rep(-0.2,length(Hour[day==sDay])),fit6$res[day==sDay],cex=.4,ylim=c(-2,2))
for (sDay in 1:4) {
  points(Hour[day==sDay]+rep(-0.2+sDay/10,length(Hour[day==sDay])),fit6$res[day==sDay],col=sDay+1,cex=.4)
}
abline(h=0, col = 2)



## ------------------------------------------------
AllDat$meetIn = Hour=9 & day<=4
fit7 <- sdeTiTmAvStudMeet(AllDat,AllDat$yTi1,AllDat$Ph1)
summary(fit7, extended = T)

Pred <- predict(fit7)
fit7$res = Pred[[1]]$state$pred$Ti - AllDat$yTi1;
plot(Hour+runif(length(Hour),-0.2,0.2), fit7$res, cex = 0.2,pch=3)
abline(h=0, col = 2)

sDay = 0
plot(Hour[day==sDay]+rep(-0.2,length(Hour[day==sDay])),fit7$res[day==sDay],cex=.4,ylim=c(-2,2))
for (sDay in 1:4) {
  points(Hour[day==sDay]+rep(-0.2+sDay/10,length(Hour[day==sDay])),fit7$res[day==sDay],col=sDay+1,cex=.4)
}
abline(h=0, col = 2)



## ------------------------------------------------
# Let's use black box to account for drift during weekdays 
weekRes = fit3$res[day<5]
plot(Hour[day<5],weekRes)

medFit = rep(0,24)
for (t in 1:24) {
    medFit[t] = median(fit3$res[day<5 & Hour==(t-1)])
}
lines(0:23,medFit)
diffDrift = diff(medFit,1)


EN = rep(0,length(Hour)) ## Eight-nine
NT = rep(0,length(Hour)) ## Nine-ten
TE = rep(0,length(Hour)) ## Ten-elleven

for (t in 1:length(Hour-2)) {
  if (day[t]<5 & Hour[t]==8){
    EN[t] = 1
    NT[t+1] = 1
    TE[t+2] = 1
  }
}

AllDat$EN = EN
AllDat$NT = NT
AllDat$TE = TE

source("sdeTiTmAvStudAlt.R")
fit8 <- sdeTiTmAvStudAlt(AllDat,AllDat$yTi1,AllDat$Ph1)
summary(fit8, extended = T)

Pred <- predict(fit8)
fit8$res = Pred[[1]]$state$pred$Ti - AllDat$yTi1;
plot(Hour+runif(length(Hour),-0.2,0.2), fit8$res, cex = 0.2,pch=3)
abline(h=0, col = 2)

medFit2 = rep(0,24)
for (t in 1:24) {
  medFit2[t] = median(fit8$res[day<5 & Hour==(t-1)])
}

plot(Hour[day<5]+runif(length(Hour[day<5]),-0.2,0.2),fit8$res[day<5],ylim=c(-2,2),cex=.4,col=2)
points(Hour[day>=5]+runif(length(Hour[day>=5]),-0.2,0.2),fit8$res[day>=5],ylim=c(-2,2),cex=.4,col=3)
#lines(0:23,medFit2)
abline(h=0,col=4,lw=2)
legend("bottom",c("Weekdays","Weekends"),pch=c(1,1),col=c(2,3))



plot(Hour[day<5]+runif(length(Hour[day<5]),-0.2,0.2),fit3$res[day<5],ylim=c(-2,2),cex=.4,col=2)
points(Hour[day>=5]+runif(length(Hour[day>=5]),-0.2,0.2),fit3$res[day>=5],ylim=c(-2,2),cex=.4,col=3)
#lines(0:23,medFit2)
abline(h=0,col=4,lw=2)
legend("bottom",c("Weekdays","Weekends"),pch=c(1,1),col=c(2,3))


boxplot(fit8$res[day==0],fit8$res[day==1],fit8$res[day==2],fit8$res[day==3],fit8$res[day==4],fit8$res[day==5],fit8$res[day==6])
abline(h=0,col=4,lw=2)

boxplot(fit3$res[day==0],fit3$res[day==1],fit3$res[day==2],fit3$res[day==3],fit3$res[day==4],fit3$res[day==5],fit3$res[day==6])
abline(h=0,col=4,lw=2)
