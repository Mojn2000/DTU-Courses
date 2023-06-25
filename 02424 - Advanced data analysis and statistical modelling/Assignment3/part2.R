#### Part 2
## clo data
clo = read.csv('dat_count3.csv', sep = ";", stringsAsFactors = F)

#### A ####
## Present data
pairs(clo[,-6])

png("subjId_box.png", width = 1000, height = 800, pointsize = 24)
plot(as.numeric(clo$clo) ~ as.factor(clo$subjId), col = 2+(clo$sex == "male"), lwd = 1.5,
     xlab = "subjId", ylab = "clo")
grid()
dev.off()

png("sex_box.png", width = 1000, height = 800, pointsize = 24)
plot(as.numeric(clo$clo) ~ as.factor(clo$sex), col = 2:3, lwd = 1.5,
     xlab = "sex", ylab = "clo")
grid()
dev.off()



plot(clo$clo[clo$subjId == ids[i]], clo$tOut[clo$subjId == ids[i]], col = i, pch = i, xlim = c(0,5), ylim = c(10,35))
lapply(min(ids):max(ids), function(i) points(clo$clo[clo$subjId == ids[i]], clo$tOut[clo$subjId == ids[i]], col = i, pch = i))
grid()
clo$clo[clo$subjId == ids[i]]



## fit generalized mixed model
library(glmmTMB)

## binom
fit1TMB <- glmmTMB(cbind(clo,nobs-clo) ~ tInOp+tOut+as.factor(sex) + (1|subjId) - 1,
                   family="binomial",data=clo)
drop1(fit1TMB)
fit1TMB = update(fit1TMB,.~.-tOut)
drop1(fit1TMB)
fit1TMB = update(fit1TMB,.~.-tInOp)
drop1(fit1TMB)
summary(fit1TMB)

fit1.1TMB <- glmmTMB(cbind(clo,nobs-clo) ~ as.factor(sex) - 1,
                   family="binomial",data=clo)
AIC(fit1.1TMB)

## pois
fit2TMB <- glmmTMB(clo ~ tInOp+tOut+as.factor(sex) + (1|subjId) - 1,
                   family="poisson",data=clo)
drop1(fit2TMB)
fit2TMB = update(fit2TMB,.~.-tOut)
drop1(fit2TMB)
fit2TMB = update(fit2TMB,.~.-tInOp)
drop1(fit2TMB)
summary(fit2TMB)

fit2.1TMB <- glmmTMB(clo ~ as.factor(sex),
                   family="poisson",data=clo)
AIC(fit2.1TMB)


#### B ####
dat.count = read.csv('dat_count3.csv', sep = ";", stringsAsFactors = F)

X <- matrix(0,ncol=2,nrow=dim(dat.count)[1])
X[ ,1]<- dat.count$sex=="male"
X[ ,2]<-dat.count$sex=="female"

## Joint Likelihood
nll <- function(u,params,X){
  theta <- params[1:2] ## male, female
  alpha <- params[3]   
  
  # Compute lambda for Poisson
  mu <- exp(X[,1]*theta[1] + X[,2]*theta[2])
  
  
  # Compute negative log-likelihood
  #first_stage <- -sum(dgamma(u[dat.count$subjId], shape = alpha, rate = beta, log = TRUE))
  first_stage <- -sum(dgamma(u, shape = alpha, scale = 1/alpha, log = TRUE))
  second_state <- -sum(dpois(dat.count$clo, mu*u[dat.count$subjId], log = TRUE))
  return(second_state + first_stage)
}

##################################################
## use independence of u's in nlminb
nll.LA <- function(params,X){
  fun.tmp <- function(ui,u,params,X,i){
    u <- u*0+1
    u[i]<-ui
    nll(u,params,X)
  }
  u <- numeric(47)
  
  ## Use grouping structure
  for(i in 1:length(u)){
    u[i] <- nlminb(1,objective = fun.tmp, u=u,params=params,
                   X=X,i=i, lower = 0)$par
  }
  l.u <- nll(u,params,X)
  H <- numeric(length(u))
  for(i in 1:length(u)){
    H[i] <- hessian(func = fun.tmp, x = u[i], u=u,
                    params = params, X=X,i=i)}
  
  l.u + 0.5 * log(prod(H/(2*pi)))
}
system.time(fit <- nlminb(c(-1,0,2),nll.LA,X=X))
fit


#### C ####
## neg binom likelihood fun
l.fun <- function(param) {
  alpha = param[1]
  mu.male = param[2]
  mu.female = param[3]
  -sum(dnbinom(clo$clo,alpha,alpha/(mu.male*(clo$sex=="male")+mu.female*(clo$sex=="female")+alpha), log = T))
} 

sol = nlminb(c(2,0.5,0.5), l.fun)
sol

(alpha = sol$par[1])
(beta = 1/alpha)
mu = sol$par[2:3] # male, female
(theta = log(mu))

sqrt(1/diag(hessian(l.fun, sol$par)))
sol$par


dat.count = read.csv('dat_count3.csv', sep = ";", stringsAsFactors = F)
uranus = sapply(1:47, function(i){
  dat.count = dat.count[dat.count$subjId == i,]
  X <- matrix(0,ncol=2,nrow=dim(dat.count)[1])
  X[ ,1]<- dat.count$sex=="male"
  X[ ,2]<-dat.count$sex=="female"
  
  mu_ij = exp(X[,1]*theta[1] + X[,2]*theta[2])
  ((mean(dat.count$clo) + alpha)/(mean(mu_ij) + alpha))
})

png("figures/analvsnum_ex.png", width = 1000, height = 800, pointsize = 24)
plot(uranus, rand.eff$par, xlab = "Analytic expectation", ylab = "Numerical approx.")
abline(a=0,b=1)
grid()
legend("topleft",c("Slope=1"),lty =1)
dev.off()


uranus = sapply(1:47, function(i){
  dat.count = dat.count[dat.count$subjId == i,]
  X <- matrix(0,ncol=2,nrow=dim(dat.count)[1])
  X[ ,1]<- dat.count$sex=="male"
  X[ ,2]<-dat.count$sex=="female"
  
  mu_ij = exp(X[,1]*theta[1] + X[,2]*theta[2])
  ((mean(dat.count$clo) + alpha)/(mean(mu_ij) + alpha)^2)
})

png("figures/analvsnum_var.png", width = 1000, height = 800, pointsize = 24)
plot(uranus, var.numest, xlab = "Analytic expectation of variance", ylab = "Numerical approx. of variance")
abline(a=0,b=1)
grid()
legend("topleft",c("Slope=1"),lty =1)
dev.off()


