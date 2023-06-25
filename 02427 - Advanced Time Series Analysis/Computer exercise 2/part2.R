library(plotly)
# Simulate SETAR(2,1,1) model (code taken from 3dPlotting.R given in the exercise)

##------------------------------------------------
## Make some data
## Number of samplepoints
n <- 3000
## Uniform distributed x
x <- runif(n,-1,1)
## Errors
r <- rnorm(n)
## Make a time series y with a regime model
y <- rep(NA,n)
y[1] <- r[1]
for(t in 2:n) {
  if(y[t-1] < 0){
    y[t] <- 2 + y[t-1] + r[t]
  }
  else{
    y[t] <- -2 - y[t-1] + r[t]
  }
}


y_test = y[1001:1030]

## Generate grid
p1_grid = seq(0,4,0.02)
p2_grid = seq(0,2,0.02)
RSS = matrix(data = 0, nrow = length(p1_grid), ncol = length(p2_grid))
for (i in 1:length(p1_grid)) {
  for (j in 1:length(p2_grid)) {
    RSS[i,j] = RSSSetar(p1_grid[i],p2_grid[j],y_test)
  }
}


fig <- plot_ly(
  x = p1_grid, 
  y = p2_grid, 
  z = log(RSS-min(RSS)/2),
  type = "contour",
  colorscale = 'Jet',
  autocontour = T,
  x = 'theta1'
)
fig <- fig %>% colorbar(title = "log(RSS)")
fig <- fig %>% layout(xaxis = expression(theta[1]), yaxis = expression(theta[2]))

fig


filled.contour(p1_grid,p2_grid,log(RSS-min(RSS)/2),xlab=expression(theta[1]),ylab=expression(theta[2]),color.palette=colorRampPalette(c("#00007F","blue","#007FFF", "cyan","#7FFF7F","yellow","#FF7F00","red","#7F0000")),
               main='log(RSS) - 1001:1030')
title(xlab=expression(a[1]), ylab=expression(a[2]), line=1.5)


RSSSetar <- function(p1,p2,y1) {
  # alpha and beta of model 1
  p1 <- p1
  p2 <- p2
  
  # alpha and beta of model 2
  p3 <- -2
  p4 <- -1
  
  # regime change
  r <- 0
  
  ## Calculate the objective function value
  y_temp = rep(0,length(y1));
  
  for(t in 2:length(y1)) {
    if(y1[t-1] < r) {
      y_temp[t] <- p1 + p2*y1[t-1]
    }
    else {
      y_temp[t] <- p3 + p4*y1[t-1]
    }
  }
  return (t(y_temp-y1) %*% (y_temp-y1))
}
