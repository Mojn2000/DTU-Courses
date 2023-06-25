#### Problem A ----
setwd( '/Users/mads/Google Drev/Skole/Uni/10_semester/02424/Assignment1' )

if (file.exists("clothingFull.csv") & file.exists("clothingSum.csv")) {
  print("Files are acessable. You can proceed!")
  clothingFull <- read.csv("./clothingFull.csv", stringsAsFactors = FALSE)
  clothingSum <- read.csv("./clothingSum.csv", stringsAsFactors = FALSE)
}

# Make an exploratory analysis of the data
library(corrplot)
clothingSum$sex[clothingSum$sex == 'male'] <- 1;
clothingSum$sex[clothingSum$sex == 'female'] <- 0;

clothingSum$sex <- as.numeric(clothingSum$sex);
clothingSum$X <- NULL;
clothingSum$subjId <- NULL;
clothingSum$obs.no <- NULL;
clothingSum$day <- NULL;

png("figures/cor-raw.png", width = 800, height = 800, pointsize = 24)
pairs(clothingSum)
dev.off()

png("figures/cor-heat.png", width = 800, height = 800, pointsize = 24)
corrplot(cor(clothingSum))
dev.off()

## GLM fit
clothingSum <- read.csv("./clothingSum.csv", stringsAsFactors = FALSE)

fit0 <- lm(clo ~ tOut*tInOp*sex, data = clothingSum) 

drop1(fit0,test="F")
fit1 <- update(fit0,.~.-tOut:tInOp:sex)

drop1(fit1,test="F")
fit2 <- update(fit1,.~.-tOut:tInOp)

drop1(fit2,test="F")
fit3 <- update(fit2,.~.-tOut:sex)

drop1(fit3,test="F")

## Lets just drop one significant one for show
fit4 <- update(fit3,.~.-tInOp:sex)

## And we are done, now lets compare the models with anova
anova(fit0,fit1) ## ok
anova(fit0,fit2) ## ok
anova(fit0,fit3) ## ok
anova(fit0,fit4) ## not ok, full model is significantly better! 

summary(fit3) ## final model

anova(fit0)
library("car")
anova(fit3)
Anova(fit3, type = "II")
Anova(fit3, type = "III")

## Compute param sd
Y = clothingSum$clo
X = matrix(NA,nrow=nrow(clothingSum), ncol=5) 
X[,1] = clothingSum$sex == "male"
X[,2] = clothingSum$sex != "male"
X[,3] = clothingSum$tOut
X[,4] = clothingSum$tInOp * (clothingSum$sex == "male")
X[,5] = clothingSum$tInOp * (clothingSum$sex != "male")

Sigma = diag(rep(1,nrow(X)))
Beta = solve(t(X) %*% solve(Sigma) %*% X) %*% t(X) %*% solve(Sigma) %*% Y
eps = Y - (X %*% Beta)
df = 131

Beta
sqrt(diag(solve(t(X) %*% solve(Sigma) %*% X))) * sqrt(sum(eps^2/df))

## Make plots
png("figures/res_anal.png", width = 1000, height = 800, pointsize = 24)
par(mfrow=c(2,2))
plot(residuals(fit3) ~ clothingSum$clo, ylab = "Residuals", xlab = "clo")
grid()
plot(residuals(fit3) ~ clothingSum$tInOp, ylab = "Residuals", xlab = "tInOp")
grid()
plot(residuals(fit3) ~ clothingSum$tOut, ylab = "Residuals", xlab = "tOut")
grid()
plot(residuals(fit3) ~ as.factor(clothingSum$sex), ylab = "Residuals", xlab = "sex")
grid()
dev.off()

## Weighted analysis
Sigma = rep(1,nrow(clothingSum))
for (i in 1:10) {
  res.male = residuals(fit3)[clothingSum$sex == "male"]
  res.female = residuals(fit3)[clothingSum$sex != "male"]
  
  Sigma[clothingSum$sex == "male"] = (t(res.male) %*% res.male) / (df-68)
  Sigma[clothingSum$sex != "male"] = (t(res.female) %*% res.female) / (df-64)
  
  #Sigma[clothingSum$sex == "male"] = var(res.male)
  #Sigma[clothingSum$sex != "male"] = var(res.female)
  
  fit3 = lm(clo ~ tOut + tInOp + sex + tInOp:sex,data = clothingSum,weights = (Sigma^-1))
}

## Make sigma to matrix
Sigma = diag(Sigma)

## Compute param 
Beta = solve(t(X) %*% solve(Sigma) %*% X) %*% t(X) %*% solve(Sigma) %*% Y
eps = Y - (X %*% Beta)

Beta
sqrt(diag(solve(t(X) %*% solve(Sigma) %*% X))) #* sqrt(sum(eps^2/df)) # sigma included in estimates of Sigma
summary(fit3)

## Plots
fit.conf = predict(fit3, newdata = data.frame(clo = seq(0,1,length.out = 2*100),
                                              tInOp = mean(clothingSum$tInOp),
                                              tOut = rep(seq(10,35, length.out = 100),2),
                                              sex = as.factor(c(rep("male",100),rep("female",100)))),
                   interval = 'confidence')

png("figures/model_fin.png", width = 1000, height = 800, pointsize = 24)
par(mfrow = c(1,1))
plot(clothingSum$clo[clothingSum$sex=="male"] ~ clothingSum$tOut[clothingSum$sex=="male"], col = "blue", ylim = c(0.2,1),
     ylab = "clo", xlab = "tOut")
points(clothingSum$clo[clothingSum$sex!="male"] ~ clothingSum$tOut[clothingSum$sex!="male"], col = "red", pch = 2)
lines(fit.conf[1:100,1] ~ seq(10,35, length.out = 100), col = "blue")
lines(fit.conf[1:100,2] ~ seq(10,35, length.out = 100), col = "blue", lty = 2)
lines(fit.conf[1:100,3] ~ seq(10,35, length.out = 100), col = "blue", lty = 2)
lines(fit.conf[1:100,2]-1.96*sd(res.male) ~ seq(10,35, length.out = 100), col = "blue", lty = 3)
lines(fit.conf[1:100,3]+1.96*sd(res.male) ~ seq(10,35, length.out = 100), col = "blue", lty = 3)
lines(fit.conf[101:200,1] ~ seq(10,35, length.out = 100), col = "red")
lines(fit.conf[101:200,2] ~ seq(10,35, length.out = 100), col = "red", lty = 2)
lines(fit.conf[101:200,3] ~ seq(10,35, length.out = 100), col = "red", lty = 2)
lines(fit.conf[101:200,2]-1.96*sd(res.female) ~ seq(10,35, length.out = 100), col = "red", lty = 3)
lines(fit.conf[101:200,3]+1.96*sd(res.female) ~ seq(10,35, length.out = 100), col = "red", lty = 3)
grid()
legend("topright", c("Male","Female"),pch=c(1,2),lty=1, col = c("blue","red"))
dev.off()

fit.conf = predict(fit3, newdata = data.frame(clo = seq(0,1,length.out = 2*100),
                                              tOut = mean(clothingSum$tOut),
                                              tInOp = rep(seq(10,35, length.out = 100),2),
                                              sex = as.factor(c(rep("male",100),rep("female",100)))),
                   interval = 'confidence')

png("figures/model_fin2.png", width = 1000, height = 800, pointsize = 24)
par(mfrow = c(1,1))
plot(clothingSum$clo[clothingSum$sex=="male"] ~ clothingSum$tInOp[clothingSum$sex=="male"], col = "blue", ylim = c(0.2,1),
     ylab = "clo", xlab = "tInOp")
points(clothingSum$clo[clothingSum$sex!="male"] ~ clothingSum$tInOp[clothingSum$sex!="male"], col = "red", pch = 2)
lines(fit.conf[1:100,1] ~ seq(10,35, length.out = 100), col = "blue")
lines(fit.conf[1:100,2] ~ seq(10,35, length.out = 100), col = "blue", lty = 2)
lines(fit.conf[1:100,3] ~ seq(10,35, length.out = 100), col = "blue", lty = 2)
lines(fit.conf[1:100,2]-1.96*sd(res.male) ~ seq(10,35, length.out = 100), col = "blue", lty = 3)
lines(fit.conf[1:100,3]+1.96*sd(res.male) ~ seq(10,35, length.out = 100), col = "blue", lty = 3)
lines(fit.conf[101:200,1] ~ seq(10,35, length.out = 100), col = "red")
lines(fit.conf[101:200,2] ~ seq(10,35, length.out = 100), col = "red", lty = 2)
lines(fit.conf[101:200,3] ~ seq(10,35, length.out = 100), col = "red", lty = 2)
lines(fit.conf[101:200,2]-1.96*sd(res.female) ~ seq(10,35, length.out = 100), col = "red", lty = 3)
lines(fit.conf[101:200,3]+1.96*sd(res.female) ~ seq(10,35, length.out = 100), col = "red", lty = 3)
grid()
legend("topright", c("Male","Female"),pch=c(1,2),lty=1, col = c("blue","red"))
dev.off()

png("figures/res_anal2.png", width = 1000, height = 800, pointsize = 24)
par(mfrow=c(2,2))
plot(eps ~ clothingSum$clo, ylab = "Residuals", xlab = "clo")
grid()
plot(eps ~ clothingSum$tInOp, ylab = "Residuals", xlab = "tInOp")
grid()
plot(eps ~ clothingSum$tOut, ylab = "Residuals", xlab = "tOut")
grid()
plot(eps ~ as.factor(clothingSum$sex), ylab = "Residuals", xlab = "sex")
grid()
dev.off()


## subjId
par(mfrow = c(1,1))
png("figures/subjId_a.png", width = 1000, height = 800, pointsize = 24)
aux.col = c("red","blue")
boxplot(eps ~ clothingSum$subjId, ylab = "Residual", xlab = "subjId", col = aux.col[(clothingSum$sex == "male")+1])
grid()
dev.off()

## ANOVA
anova(lm(eps[clothingSum$sex == "male"] ~ clothingSum$subjId[clothingSum$sex == "male"]))      # male
anova(lm(eps[clothingSum$sex == "female"] ~ clothingSum$subjId[clothingSum$sex == "female"]))  # female



#### Problem B ----
setwd( '/Users/mads/Google Drev/Skole/Uni/10_semester/02424/Assignment1' )

if (file.exists("clothingFull.csv") & file.exists("clothingSum.csv")) {
  print("Files are acessable. You can proceed!")
  clothingFull <- read.csv("./clothingFull.csv", stringsAsFactors = FALSE)
  clothingSum <- read.csv("./clothingSum.csv", stringsAsFactors = FALSE)
}

clothingSum$subjId = as.factor(clothingSum$subjId)

## Test type II 
fit0 <- lm(clo ~ tOut*tInOp*subjId, data = clothingSum) 

drop1(fit0,test="F")
fit1 <- update(fit0,.~.-tOut:tInOp:subjId)
summary(fit1)
drop1(fit1,test="F")
fit2 <- update(fit1,.~.-tInOp:subjId)

drop1(fit2,test="F")
fit3 <- update(fit2,.~.-tOut:subjId)

drop1(fit3,test="F")
fit4 <- update(fit3,.~.-tOut:tInOp)

drop1(fit4,test="F")
fit5 <- update(fit4,.~.-tInOp)

drop1(fit5,test="F")
anova(fit1,fit5)

## Final model:
summary(fit5)

png("figures/subjid.png", width = 1000, height = 800, pointsize = 24)
plot(clothingSum$clo ~ clothingSum$tOut, cex = 0, xlab = "tOut", ylab = "clo")
id = unique(clothingSum$subjId)
theta = fit5$coefficients[2]
coef = fit5$coefficients[-2]
coef[2:length(coef)] = tail(coef,-1)+coef[1] 
cols = rainbow(length(coef))
for (ii in 1:length(coef)) {
  points(clothingSum$clo[clothingSum$subjId == id[ii]] ~ clothingSum$tOut[clothingSum$subjId == id[ii]], col = cols[ii], cex = 0.5)
  abline(a=coef[ii], b = theta, col = cols[ii], lwd = 0.3)
}
grid()
dev.off()

png("figures/intercept_b.png", width = 800, height = 800, pointsize = 24)
hist(coef,xlab = "Intercept")
grid()
dev.off()


#### Problem C ----
setwd( '/Users/mads/Google Drev/Skole/Uni/10_semester/02424/Assignment1' )

if (file.exists("clothingFull.csv") & file.exists("clothingSum.csv")) {
  print("Files are acessable. You can proceed!")
  clothingFull <- read.csv("./clothingFull.csv", stringsAsFactors = FALSE)
  clothingSum <- read.csv("./clothingSum.csv", stringsAsFactors = FALSE)
}

clothingFull$subjId = as.factor(clothingFull$subjId)

## Version 1 (based on sex)
fit0 <- lm(clo ~ tOut*tInOp*sex, data = clothingFull) 
drop1(fit0,test="F")
## It seems we are already done, fit0 is final model!
fit.v1 = fit0
summary(fit.v1)

## Version 2 (based on sex)
fit0 <- lm(clo ~ tOut*tInOp*subjId, data = clothingFull) 
drop1(fit0,test="F")
fit1 <- update(fit0,.~.-tOut:tInOp:subjId)

drop1(fit1,test="F")
## It seems we are already done, fit1 is final model!
fit.v2 = fit1
summary(fit.v2)

## Lets compare version 1 and 2
anova(fit.v1,fit.v2)
# Version 2 is much better!

## Final model:
summary(fit5)

