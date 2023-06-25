setwd('/Users/mads/Google Drev/Skole/Uni/10_semester/02424/Assignment 3')

#### Part 1 ----
conc.dat = read.csv('concrete.csv', sep = "")
conc.dat$date = as.Date(conc.dat$date)

## A.1 init plot 
png('figures/y7-raw.png', width = 1000, height = 800, pointsize = 24)
cols = c('green3', 'blue3', 'orange', 'red2', 'steelblue2')
plot(conc.dat$date[conc.dat$batch == 1], conc.dat$y7[conc.dat$batch == 1], col = 'green3', 
     xlim = range(conc.dat$date), ylim = range(conc.dat$y7), 
     xlab = "Time", ylab = "Strength (y7)")
lapply(2:5, function(i) points(conc.dat$date[conc.dat$batch == i], conc.dat$y7[conc.dat$batch == i], col = cols[i], pch = i))
grid(col = "darkgrey")
legend("topleft", paste('Batch',1:5), col = cols, pch = 1:5)
dev.off()

png('figures/y28-raw.png', width = 1000, height = 800, pointsize = 24)
plot(conc.dat$date[conc.dat$batch == 1], conc.dat$y28[conc.dat$batch == 1], col = 'green3', 
     xlim = range(conc.dat$date), ylim = range(conc.dat$y28), 
     xlab = "Time", ylab = "Strength (y28)")
lapply(2:5, function(i) points(conc.dat$date[conc.dat$batch == i], conc.dat$y28[conc.dat$batch == i], col = cols[i], pch = i))
grid(col = "darkgrey")
legend("topleft", paste('Batch',1:5), col = cols, pch = 1:5)
dev.off()

## A.2
m7 = do.call(c,lapply(1:5, function(i) mean(conc.dat$y7[conc.dat$batch == i])))
m28 = do.call(c,lapply(1:5, function(i) mean(conc.dat$y28[conc.dat$batch == i])))

png('figures/y7-means.png', width = 1000, height = 800, pointsize = 24)
plot(conc.dat$date[conc.dat$batch == 1], conc.dat$y7[conc.dat$batch == 1], col = 'green3', 
     xlim = range(conc.dat$date), ylim = range(conc.dat$y7), 
     xlab = "Time", ylab = "Strength (y7)")
lapply(2:5, function(i) points(conc.dat$date[conc.dat$batch == i], conc.dat$y7[conc.dat$batch == i], col = cols[i], pch = i))
lapply(1:5, function(i) {
  lines(range(conc.dat$date[conc.dat$batch == i]), rep(m7[i],2), col = cols[i], lwd = 2)
  lines(rep(mean(range(conc.dat$date[conc.dat$batch == i])),2),m7[i]+sd(conc.dat$y7[conc.dat$batch == i])*c(-1, 1), lty = 2, col = cols[i])})
grid(col = "darkgrey")
legend("topleft", paste('Batch',1:5), col = cols, pch = 1:5)
dev.off()

png('figures/y28-means.png', width = 1000, height = 800, pointsize = 24)
plot(conc.dat$date[conc.dat$batch == 1], conc.dat$y28[conc.dat$batch == 1], col = 'green3', 
     xlim = range(conc.dat$date), ylim = range(conc.dat$y28), 
     xlab = "Time", ylab = "Strength (y28)")
lapply(2:5, function(i) points(conc.dat$date[conc.dat$batch == i], conc.dat$y28[conc.dat$batch == i], col = cols[i], pch = i))
lapply(1:5, function(i) {
  lines(range(conc.dat$date[conc.dat$batch == i]), rep(m28[i],2), col = cols[i], lwd = 2)
  lines(rep(mean(range(conc.dat$date[conc.dat$batch == i])),2),m28[i]+sd(conc.dat$y28[conc.dat$batch == i])*c(-1, 1), lty = 2, col = cols[i])})
grid(col = "darkgrey")
legend("topleft", paste('Batch',1:5), col = cols, pch = 1:5)
dev.off()

## A.3 
## One-way model with random effects (def 5.2)
library(nlme)
fit0 = lme(y28 ~ 1, random = ~1|batch, data = conc.dat, method = 'ML'); summary(fit0)


## A.4
conc.dat$air.aux = conc.dat$air.temp - mean(conc.dat$air.temp)
fit1 = lme(y28 ~ air.aux + 1, random = ~ (1)|batch, data = conc.dat, method = 'ML'); summary(fit1)
#fit1 = lme(y28 ~ air.temp + 1, random = ~ (air.temp+1)|batch, data = conc.dat, method = 'ML'); summary(fit1)
anova(fit0,fit1)

anova(fit0, fit1)

library(car)
png('figures/batch-qqplot.png', width = 1000, height = 800, pointsize = 24)
qqPlot(fit1$residuals[,2], ylab = "Batch residual quantiles")
dev.off()

#### B
## B.5 (see page 195)
X = t(cbind(conc.dat$y7, conc.dat$y28))
xbar_ip = do.call(rbind, lapply(1:5, function(i) return(apply(X[,conc.dat$batch == i],1,mean))))
xbar_pp = apply(X,1,mean)

SSE = Reduce("+",lapply(1:5, function(i) (X[,conc.dat$batch == i] - xbar_ip[i,]) %*% t(X[,conc.dat$batch == i] - xbar_ip[i,])))
SSB = Reduce("+",lapply(1:5, function(i) sum(conc.dat$batch == i) * (xbar_ip[i,] - xbar_pp) %*% t(xbar_ip[i,] - xbar_pp)))
SST = SSE + SSB

(n0 = (nrow(conc.dat) - do.call(sum,lapply(1:5,function(i) sum(conc.dat$batch==i)^2/nrow(conc.dat))))/(5-1))
(mu_tilde = xbar_pp)
(Sigma_tilde = 1/(nrow(conc.dat)-5) * SSE)
(Sigma_tilde0 = 1/n0 * (SSB/(5-1) - Sigma_tilde))

Gamma = Sigma_tilde0 * solve(Sigma_tilde)
Gamma/(1+Gamma)

cov2cor(Sigma_tilde + Sigma_tilde0)

eps =  do.call(cbind,lapply(1:5, function(i) X[, conc.dat$batch == i] - xbar_ip[i,]))
eps_group = t(xbar_ip) - xbar_pp
library(car)

png('figures/eps-within.png', width = 1000, height = 800, pointsize = 24)
plot(eps[1,conc.dat$batch==1], eps[2,conc.dat$batch==1], xlab = "Within batch errors (y7)", ylab = "Within batch errors (y28)", 
     pch = 1, col = cols[1], xlim = c(-2,2), ylim=c(-4,4))
lapply(2:5, function(i) points(eps[1,conc.dat$batch==i], eps[2,conc.dat$batch==i], pch = i, col = cols[i]))
ellipse(c(0, 0), shape=Sigma_tilde, radius=1, col="red", lty=2, lwd = .5)
ellipse(c(0, 0), shape=Sigma_tilde, radius=1.5, col="red", lty=2, lwd = .5)
ellipse(c(0, 0), shape=Sigma_tilde, radius=2, col="red", lty=2, lwd = .5)
grid()
legend("topleft", paste('Batch',1:5), col = cols, pch = 1:5)
dev.off()

png('figures/rand-eff.png', width = 1000, height = 800, pointsize = 24)
plot(eps_group[1,1], eps_group[2,1], xlab = "Random effects (y7)", ylab = "Random effects (y28)", 
     pch = 1, col = cols[1], xlim = c(-1,1), ylim=c(-4,4))
lapply(2:5, function(i) points(eps_group[1,i], eps_group[2,i], pch = i, col = cols[i]))
ellipse(c(0, 0), shape=Sigma_tilde0, radius=1, col="red", lty=2, lwd = .5)
ellipse(c(0, 0), shape=Sigma_tilde0, radius=1.5, col="red", lty=2, lwd = .5)
ellipse(c(0, 0), shape=Sigma_tilde0, radius=2, col="red", lty=2, lwd = .5)
grid()
legend("topleft", paste('Batch',1:5), col = cols, pch = 1:5)
dev.off()
