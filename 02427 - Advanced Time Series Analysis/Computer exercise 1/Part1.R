# Import libraries
library("rgl")

## Part
# Simulate SETAR(2,1,1) model (code taken from 3dPlotting.R given in the exercise)

##------------------------------------------------
## Make some data
## Number of samplepoints
n <- 1000
## Uniform distributed x
x <- runif(n,-1,1)
## Errors
r <- rnorm(n)
## Make a time series y with a regime model
y <- rep(NA,n)
y[1] <- r[1]
for(t in 2:n)
{
  if(y[t-1] > 0)
  {
    y[t] <- 1 + 0.5 * y[t-1] + r[t]
  }
  else
  {
    y[t] <- -1 + 0.5 * y[t-1] + r[t]
  }
}

plot(y)
##------------------------------------------------



# Simulate IGAR(2,1) model (code taken from 3dPlotting.R given in the exercise)

##------------------------------------------------
## Make some data
## Number of samplepoints
n <- 1000
## Uniform distributed x
x <- runif(n,-1,1)
## Errors
e1 <- rnorm(n,sd=1)
e2 <- rnorm(n,sd=2)

## Regime prop
p <- runif(n,0,1)

## Make a time series y with a regime model
y <- rep(NA,n)
y <- x[1]
for(t in 2:n)
{
  if(p[t] > 0.3)
  {
    y[t] <- 5 + 0.5 * y[t-1] + e1[t]
  }
  else
  {
    y[t] <- -5 + 0.5 * y[t-1] + e2[t]
  }
}

plot(y)
##------------------------------------------------



# Simulate MMAR(2,1) model (code taken from 3dPlotting.R given in the exercise)

##------------------------------------------------
## Make some data
## Number of samplepoints
n <- 1000
## Uniform distributed x
x <- runif(n,-1,1)
## Errors
e1 <- rnorm(n,sd=1)
e2 <- rnorm(n,sd=2)

## Regime prop
p <- runif(n,0,1)

## Make a time series y with a regime model
y <- rep(NA,n)
y <- x[1]

## Define initial regime
if (runif(1,0,1)>.5){
  regime1 = T
}
else {
  regime1 = F
}

for(t in 2:n) {
  if(regime1)
  {
    y[t] <- 5 + 0.5 * y[t-1] + e1[t]
    if (runif(1,0,1)>0.99){
      regime1 = !(regime1)
    }
  }
  else
  {
    y[t] <- -5 + 0.5 * y[t-1] + e2[t]
    if (runif(1,0,1)>0.99){
      regime1 = !(regime1)
    }
  }
}

plot(y)
##------------------------------------------------





