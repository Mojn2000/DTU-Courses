setwd("/Users/mads/Google Drev/Skole/Uni/7. semester/Advanced time series/Computer exercise 4")

data = read.csv("Data/Newly_admitted_over_time.csv",header = T,sep=";")
data$Dato = as.Date(data$Dato)

from = as.Date("2020-06-01", tryformat = "yyyy-mm-dd")

plot(data$Total ~ data$data, cex=0.2, pch=19)
plot(data$Hovedstaden[data$Dato>from] ~ data$Dato[data$Dato>from], cex=1)

