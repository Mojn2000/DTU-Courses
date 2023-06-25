
## ----- Q 1.a ------
theta = c(0.7,0.8,3.0,-0.34);
sigma = 0.4;

Delta = 2^(-9);
N = 100/Delta;
t = seq(0,100,Delta);

W = rnorm(N+1,mean=0,sd=Delta)

y1 = rep(0,N+1)
y2 = rep(0,N+1)

y1[1] = -1.9;
y2[1] = 1.2;

for (n in 1:N) {
  y1[n+1] = y1[n] + theta[3]*(y1[n] + y2[n] - 1/3*y1[n]^3 + theta[4])*Delta + sigma*W[n+1];
  y2[n+1] = y2[n] - 1/theta[3]*(y1[n] + theta[2]*y2[n] - theta[1])*Delta;
}


plot(y1,y2,type='l', xlab=expression(y[1]),ylab=expression(y[2]),main=expression(paste('Phase plot when ',sigma,'=0')))


## ----- Q 1.b ------
library(plotly)

y1grid = seq(min(y1)-0.0001, max(y1), length.out = 101);
y2grid = seq(min(y2)-0.0001, max(y2), length.out = 101);
hyp = matrix(0,nrow=100,ncol=100);

for (i in 1:100) {
  for (j in 1:100) {
    hyp[j,i] = sum(y1>y1grid[i] & y1<=y1grid[i+1] & y2>y2grid[j] & y2<=y2grid[j+1])
  }
}

fig <- plot_ly(type="heatmap",x = y1grid, y = y2grid, z = log(hyp+1))
fig <- fig %>% layout(
  title = "Log of frequency",
    xaxis = list(title = "y1"),
    yaxis = list(title = "y2")
  )

fig



fig <- plot_ly(type="scatter3d",mode="lines",x = y1, y = y2, z = t,opacity = 1, line = list(color = ~t, colorscale = 'Viridis', width = 4))
fig





