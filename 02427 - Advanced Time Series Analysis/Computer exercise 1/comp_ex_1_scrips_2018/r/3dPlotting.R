##------------------------------------------------
## Script to demonstrate 3-dimensional plotting
## in R with the rgl package.
##
## Note that this requires a computer with a graphics
## card, so it will not work on Unix mainframe systems.
##
## First install the rgl package with
## install.packages("rgl") or (I had to do that on Ubuntu 11.04) in the terminal: sudo apt-get install r-cran-rgl
##------------------------------------------------
## Start by deleting all objects in the memory
rm(list=ls())
## Use rgl
library(rgl)
##------------------------------------------------


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
    if(x[t-1] < 0)
      {
        y[t] <- 4 + 0.5 * y[t-1] + r[t]
      }
    else
      {
        y[t] <- -4 - 0.5 * y[t-1] + r[t]
      }
  }
## Put it into a data.frame, and make x1 and y1 which are lagged one step 
D <- data.frame(y=y[-1], x1=x[-n], y1=y[-n])
##------------------------------------------------


##------------------------------------------------
## The parameters for the grid for surface estimation
nplot <- 20
x1Seq=seq(min(x),max(x),len=nplot)
y1Seq=seq(min(y),max(y),len=nplot)
##------------------------------------------------


##------------------------------------------------
## Plot the points
open3d() ## Note: Do not use rgl.open()
points3d(D$x1, D$y1, D$y, size=3, col="red")
aspect3d(c(1,1,1))
axes3d()
title3d(xlab="x[t-1]",ylab="y[t-1]",zlab="y[t]")
##------------------------------------------------


##------------------------------------------------
## Estimate the function with 2D local polynomial regression using loess()
fit <- loess(y ~ x1 + y1, dat=D, span=0.8)
## Plot the surface with a grid of nPlot x nPlot points
yprd <- outer(x1Seq, y1Seq, function(x1,y1){predict(fit, data.frame(x1=x1, y1=y1))})
## Draw the surface. See ?rgl.material for options
surface3d(x1Seq, y1Seq, yprd, color="blue", alpha=0.5)
##------------------------------------------------


##------------------------------------------------
## Estimate the function with 2D local polynomial regression using loess() with another bandwidth
fit <- loess(y ~ x1 + y1, dat=D, span=0.2)
yprd <- outer(x1Seq, y1Seq, function(x1,y1){predict(fit, data.frame(x1=x1, y1=y1))})
## 'jet.colors' is "as in Matlab", alternatives see ?rainbow
jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                     "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
## Use 100 different colors
colors <- jet.colors(100)
## Set the colors for z values
color <- colors[(yprd-min(yprd))/max(yprd)*49.5+1]
## Make a surface with jet colors
surface3d(x1Seq, y1Seq, yprd, color=color, alpha=1)
##------------------------------------------------


##------------------------------------------------
## Estimate the function with local polynomial regression using lm()
## It is possible to use different bandwidths in each dimension.

## Epanechnikov kernel
kernelEp <- function(xall,x,h)
{
  ## Make the weights with an Epanechnikov kernel
  ## h has the same unit as x (i.e. it is on the same absolute scale, so if x is Watt, h is also given in Watt) 
  u <- abs(xall-x)
  u <- u / h
  w <- 3/4 * (1 - u^2)
  ## Set values with |u|>1 to 0
  w[abs(u)>1] <- 0
  return(w)
}

## Bandwidths in each two-dimensional multiplicative kernel relative to the range of x and y
hx <- 0.2*(max(D$x1) - min(D$x1))
hy <- 0.2*(max(D$y1) - min(D$y1))

## Do local 1'st order regression. This can also easily be changed to a conditional parametric model
yprd <- outer(x1Seq, y1Seq, function(x1,y1)
  {
    L <- lapply(1:length(x1), function(i)
      {
        ## Just a tip for debugging in R: Use browser() to stop inside some function. Quit with "Q", see ?browser
        ##browser()
        ## Calculate the weights in each dimension
        wx <- kernelEp(D$x1, x1[i], h=hx)
        wy <- kernelEp(D$y1, y1[i], h=hy)
        w <- wx*wy
        ## Do it only with positive weights
        ok <- w>0
        ## Note that this is local first order polynomial regression, but can easily be made 2'nd
        fit <- lm(y ~ x1 + y1, weights=w[ok], data=D[ok,])
        return(predict(fit, data.frame(x1=x1[i], y1=y1[i])))
      })
    return(do.call("rbind",L))
  })
## Draw the surface. See ?rgl.material for options
surface3d(x1Seq, y1Seq, yprd, color="red", alpha=0.5)
##------------------------------------------------


##------------------------------------------------
## Try some zooming
## Hold left mouse bottom to move the viewpoint
## Hold right mouse bottom to zoom
## Hold mid mouse bottom to change FOV, which is the depth perspective

## Do the same with functions
## See ?view3d

## Make a movie
## Set the starting viewpoint
fov=60
view3d(0,30,fov)
M <- par3d("userMatrix")
M <- rotate3d(M, -pi/2, 1, 0, 0)
view3d(userMatrix=M,fov=fov)
## Run a loop rotating the plot
start <- proc.time()[3]
while ((i <- 36*(proc.time()[3]-start)) < 360) {
  ## Rotate around the z-axis
  M <- rotate3d(M, pi/200, 0, 0, 1)
  view3d(userMatrix=M,fov=fov)
}

## save the plot to a file
## see ?snapshot3d
##------------------------------------------------
