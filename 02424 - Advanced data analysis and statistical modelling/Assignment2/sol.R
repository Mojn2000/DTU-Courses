setwd( '/Users/mads/Google Drev/Skole/Uni/10_semester/02424/Assignment2' )

#### Part 1 ----
library("gclus")
data(ozone)
head(ozone)

## 1)
png("figures/cor-raw.png", width = 800, height = 800, pointsize = 24)
pairs(ozone)
dev.off()

require(corrplot)
png("figures/cor-heat.png", width = 800, height = 800, pointsize = 24)
corrplot(cor(ozone))
dev.off()


## 2)
names(ozone)
fit1 <- lm(Ozone ~ Temp + InvHt + Pres + Vis + Hgt + Hum + InvTmp + Wind, data = ozone) 
summary(fit1)
drop1(fit1, test = "F")
fit1 <- update(fit1, .~.-Pres)
drop1(fit1, test = "F")
fit1 <- update(fit1, .~.-Wind)
drop1(fit1, test = "F")
fit1 <- update(fit1, .~.-Hgt)
drop1(fit1, test = "F")
fit1 <- update(fit1, .~.-InvTmp)
drop1(fit1, test = "F")
fit1 <- update(fit1, .~.-Vis)
drop1(fit1, test = "F")
summary(fit1)


png("figures/lm1_res.png", height = 1000, width = 1200, pointsize = 20)
par(mfrow = c(2,2))
plot(fit1)
dev.off()

png("figures/lm1_res2.png", height = 1000, width = 1200, pointsize = 20)
layout(matrix(c(1,2,1,3),2,2))
plot(residuals(fit1) ~ ozone$Temp, xlab = "Temp", ylab = "Residual")
lines(seq(min(ozone$Temp), max(ozone$Temp), length.out = 100),
      predict(loess(residuals(fit1) ~ ozone$Temp, span = 0.5, degree = 1), seq(min(ozone$Temp), max(ozone$Temp), length.out = 100)),
      col = "red", lwd = 0.5)
grid()
plot(residuals(fit1) ~ ozone$Hum, xlab = "Hum", ylab = "Residual")
lines(seq(min(ozone$Hum), max(ozone$Hum), length.out = 100),
      predict(loess(residuals(fit1) ~ ozone$Hum, span = 0.5, degree = 1), seq(min(ozone$Hum), max(ozone$Hum), length.out = 100)),
      col = "red", lwd = 0.5)
grid()
plot(residuals(fit1) ~ ozone$InvHt, xlab = "InvHt", ylab = "Residual")
lines(seq(min(ozone$InvHt), max(ozone$InvHt), length.out = 100),
      predict(loess(residuals(fit1) ~ ozone$InvHt, span = 0.5, degree = 1), seq(min(ozone$InvHt), max(ozone$InvHt), length.out = 100)),
      col = "red", lwd = 0.5)
grid()
dev.off()


## 3)
## Gamma cano. (inverse)
fit1.glm <- glm(Ozone ~ Temp + InvHt + Pres + Vis + Hgt + Hum + InvTmp + Wind, data = ozone,family = Gamma(link = "inverse")) 
summary(fit1.glm)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Wind)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Hgt)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-InvTmp)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Vis)
drop1(fit1.glm)
AIC(fit1.glm)
BIC(fit1.glm)

fit1.glm
summary(fit1.glm)
(pval <- 1 - pchisq(58.462/(0.1689992), 325)) # residual deviance, corresponding df 


## Gamma log
fit1.glm <- glm(Ozone ~ Temp + InvHt + Pres + Vis + Hgt + Hum + InvTmp + Wind, data = ozone,family = Gamma(link = "log")) 
summary(fit1.glm)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Wind)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Hgt)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-InvTmp)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Pres)
drop1(fit1.glm)
AIC(fit1.glm)
BIC(fit1.glm)
summary(fit1.glm)
(pval <- 1 - pchisq(51.091/(0.14714), 325)) # residual deviance, corresponding df 
fit2.glm = fit1.glm

## Gamma sqrt
fit1.glm <- glm(Ozone ~ Temp + InvHt + Pres + Vis + Hgt + Hum + InvTmp + Wind, data = ozone,family = Gamma(link = "sqrt")) 
summary(fit1.glm)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-InvTmp)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Hgt)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Wind)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Vis)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Pres)
drop1(fit1.glm, test = "Chisq")
AIC(fit1.glm)
BIC(fit1.glm)
summary(fit1.glm)
(pval <- 1 - pchisq(56.727/(0.1589725), 326)) # residual deviance, corresponding df 

## possion cano (log)
fit1.glm <- glm(Ozone ~ Temp + InvHt + Pres + Vis + Hgt + Hum + InvTmp + Wind, data = ozone,family = poisson(link = "log")) 
summary(fit1.glm)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Hgt)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Wind)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Pres)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-InvTmp)
drop1(fit1.glm, test = "Chisq")
AIC(fit1.glm)
BIC(fit1.glm)
#fit2.glm = fit1.glm
summary(fit1.glm)
(pval <- 1 - pchisq(445.42, 325))



## possion sqrt
fit1.glm <- glm(Ozone ~ Temp + InvHt + Pres + Vis + Hgt + Hum + InvTmp + Wind, data = ozone,family = poisson(link = "sqrt")) 
summary(fit1.glm)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Wind)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Pres)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Hgt)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-InvTmp)
drop1(fit1.glm, test = "Chisq")
AIC(fit1.glm)
BIC(fit1.glm)
summary(fit1.glm)
(pval <- 1 - pchisq(479.2, 325))


## possion inverse
fit1.glm <- glm(Ozone ~ Temp + InvHt + Pres + Vis + Hgt + Hum + InvTmp + Wind, data = ozone,family = poisson(link = "inverse")) 
summary(fit1.glm)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Hgt)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Wind)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Vis)
drop1(fit1.glm, test = "Chisq")
AIC(fit1.glm)
BIC(fit1.glm)
summary(fit1.glm)
(pval <- 1 - pchisq(524.29, 324))


## Gassian
summary(glm(Ozone ~ Temp + InvHt + Hum, data = ozone, family = gaussian))
(pval <- 1 - pchisq(6673.1/20.46953, 326))

fit1.glm <- glm(Ozone ~ Temp + InvHt + Pres + Vis + Hgt + Hum + InvTmp + Wind, data = ozone,family = gaussian(link = "log")) 
summary(fit1.glm)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Wind)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Hgt)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Pres)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Vis)
drop1(fit1.glm, test = "Chisq")
AIC(fit1.glm)
BIC(fit1.glm)
summary(fit1.glm)
(pval <- 1 - pchisq(5475.1/16.8468, 325))

fit1.glm <- glm(Ozone ~ Temp + InvHt + Pres + Vis + Hgt + Hum + InvTmp + Wind, data = ozone,family = gaussian(link = "sqrt")) 
summary(fit1.glm)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Hgt)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Hgt)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Pres)
drop1(fit1.glm, test = "Chisq")
fit1.glm <- update(fit1.glm, .~.-Vis)
drop1(fit1.glm, test = "Chisq")
AIC(fit1.glm)
BIC(fit1.glm)
summary(fit1.glm)
(pval <- 1 - pchisq(5615.3/17.33122, 324))


## plots
png("figures/glm1_res.png", height = 1000, width = 1200, pointsize = 20)
par(mfrow = c(2,2))
plot(fit2.glm)
dev.off()

png("figures/glm1_res2.png", height = 1000, width = 1200, pointsize = 20)
layout(matrix(c(1,2,3,4),2,2))
plot(residuals(fit2.glm) ~ ozone$Temp, xlab = "Temp", ylab = "Residual")
lines(seq(min(ozone$Temp), max(ozone$Temp), length.out = 100),
      predict(loess(residuals(fit2.glm) ~ ozone$Temp, span = 0.5, degree = 1), seq(min(ozone$Temp), max(ozone$Temp), length.out = 100)),
      col = "red", lwd = 0.5)
grid()
plot(residuals(fit2.glm) ~ ozone$InvHt, xlab = "InvHt", ylab = "Residual")
lines(seq(min(ozone$InvHt), max(ozone$InvHt), length.out = 100),
      predict(loess(residuals(fit2.glm) ~ ozone$InvHt, span = 0.5, degree = 1), seq(min(ozone$InvHt), max(ozone$InvHt), length.out = 100)),
      col = "red", lwd = 0.5)
grid()
plot(residuals(fit2.glm) ~ ozone$Vis, xlab = "Vis", ylab = "Residual")
lines(seq(min(ozone$Vis), max(ozone$Vis), length.out = 100),
      predict(loess(residuals(fit2.glm) ~ ozone$Vis, span = 0.5, degree = 1), seq(min(ozone$Vis), max(ozone$Vis), length.out = 100)),
      col = "red", lwd = 0.5)
grid()
plot(residuals(fit2.glm) ~ ozone$Hum, xlab = "Hum", ylab = "Residual")
lines(seq(min(ozone$Hum), max(ozone$Hum), length.out = 100),
      predict(loess(residuals(fit2.glm) ~ ozone$Hum, span = 0.5, degree = 1), seq(min(ozone$Hum), max(ozone$Hum), length.out = 100)),
      col = "red", lwd = 0.5)
grid()
dev.off()



## 4+5)
png("figures/lm1.png", height = 800, width = 1000, pointsize = 24)
plot(ozone$Temp, ozone$Ozone, col = "salmon3", lwd = 2,
     xlab = "Temp", ylab = "Ozone")
points(ozone$Temp, fit1$fitted.values, pch = 2, col = "steelblue2", lwd = 2)
grid()
legend("topleft", c("Measurement","Prediction"), pch = c(1,2), col = c("salmon3","steelblue2"), lwd = 2, lty = -1)
dev.off()

png("figures/glm1.png", height = 800, width = 1000, pointsize = 24)
plot(ozone$Temp, ozone$Ozone, col = "salmon3", lwd = 2,
     xlab = "Temp", ylab = "Ozone")
points(ozone$Temp, fit2.glm$fitted.values, pch = 2, col = "seagreen", lwd = 2)
grid()
legend("topleft", c("Measurement","Prediction"), pch = c(1,2), col = c("salmon3","seagreen"), lwd = 2, lty = -1)
dev.off()
summary(fit2.glm)




#### Par 3 ----
fan.dat = read.csv("CeilingFan.csv", sep = ";")

## 3.1
fan.dat$TSV = factor(paste0(fan.dat$TSV,".tsv"))
fan.dat$fanSpeed = factor(paste0(fan.dat$fanSpeed,".fanSpeed"))

con.tab = table(fan.dat$fanSpeed, fan.dat$TSV)
addmargins(con.tab)

#COLUMN PERCENTAGES
colpercent<-prop.table(con.tab, 2)
colpercent
row.names(colpercent) = 0:2

png("figures/con-tab3.png", height = 1000, width = 1000, pointsize = 24)
barplot(t(colpercent), beside = TRUE, col = 2:4, las = 1,
       ylab = "Percent", xlab = "fanSpeed")
legend( legend = paste("TSV =",0:2), fill = 2:4,"topright", cex = 1)
dev.off()

chi <- chisq.test(con.tab, correct = FALSE)
chi


## 3.2
library(ordinal)
names(fan.dat)
m1.p <- clm( TSV ~ 1, data = fan.dat )
summary(m1.p)
fan.dat$fanSpeed = as.numeric(fan.dat$fanSpeed)
m2.p <- clm( TSV ~ fanSpeed, data = fan.dat, link = "logit" )
summary(m2.p)

anova(m1.p,m2.p)


## 3.3
fan.dat = read.csv("CeilingFan.csv", sep = ";")
fan.dat$fanSpeed = (fan.dat$fanSpeed)
fan.dat$fanType = as.factor(fan.dat$fanType)
fan.dat$TSV = as.factor(fan.dat$TSV)
m3.p <- clm( TSV ~ fanSpeed:fanType + fanType, data = fan.dat)
m4.p <- clm( TSV ~ fanSpeed:fanType + fanType, data = fan.dat, link = "probit")
m5.p <- clm( TSV ~ fanSpeed:fanType + fanType, data = fan.dat, link = "cloglog")
AIC(m3.p)
AIC(m4.p)
AIC(m5.p)
drop1(m3.p, test = "Chisq")
drop1(m4.p, test = "Chisq")
drop1(m5.p, test = "Chisq")

summary(m5.p)


## 3.4
ex.n = 10
x.new = data.frame(fanSpeed = rep(0:(ex.n-1),2),
                   fanType = c(rep("downstream",ex.n),rep("upstream",ex.n)))
x.new$fanSpeed = as.numeric(x.new$fanSpeed)
x.new$fanType = as.factor(x.new$fanType)
pred.new = predict(m4.p, newdata = x.new)

col.1 = "blue"
col.2 = "red"

png("figures/clm3.png", height = 800, width = 1000, pointsize = 24)
plot(0:(ex.n-1),pred.new$fit[1:ex.n,3], type = 'l', 
     ylab = "Probability", xlab = "fanSpeed", ylim = c(0,1), lty = 6, col = col.1)
points(0:(ex.n-1),pred.new$fit[1:ex.n,3], col = col.1)
lines(0:(ex.n-1),pred.new$fit[1:ex.n,2], lty = 2, col = col.1)
points(0:(ex.n-1),pred.new$fit[1:ex.n,2], lty = 2, col = col.1, pch = 2)
lines(0:(ex.n-1),pred.new$fit[1:ex.n,1], lty = 3, col = col.1)
points(0:(ex.n-1),pred.new$fit[1:ex.n,1], col = col.1,  pch = 3)

lines(0:(ex.n-1),pred.new$fit[(ex.n+1):(2*ex.n),3], col = col.2,  lty = 6)
points(0:(ex.n-1),pred.new$fit[(ex.n+1):(2*ex.n),3], col = col.2, pch = 1)
lines(0:(ex.n-1),pred.new$fit[(ex.n+1):(2*ex.n),2], lty = 2, col = col.2)
points(0:(ex.n-1),pred.new$fit[(ex.n+1):(2*ex.n),2], lty = 2, col = col.2, pch = 2)
lines(0:(ex.n-1),pred.new$fit[(ex.n+1):(2*ex.n),1], lty = 3, col = col.2)
points(0:(ex.n-1),pred.new$fit[(ex.n+1):(2*ex.n),1], col = col.2, pch = 3)
grid()
legend("topright", c("Downstream", "Upstream","TSV=0","TSV=1","TSV=2"), pch=c(-1,-1,3,2,1), 
       lty = c(1,1,3,2,6), col = c("blue","red",1,1,1), bg = "white")
dev.off()

