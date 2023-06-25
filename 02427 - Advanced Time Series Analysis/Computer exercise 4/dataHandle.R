setwd("/Users/mads/Google Drev/Skole/Uni/7. semester/Advanced time series/Computer exercise 4")

## Read test data
TestDat = read.csv("Data/Test_pos_over_time.csv",header=T,dec=',',sep=';',colClasses="character")
TestDat = TestDat[1:(length(TestDat$Date)-4),]
TestDat$NotPrevPos = as.numeric(gsub('\\.',"",TestDat$NotPrevPos))
TestDat$NewPositive = as.numeric(gsub('\\.',"",TestDat$NewPositive))
TestDat$Date = as.Date(TestDat$Date)
TestDat = TestDat[TestDat$Date>=as.Date("2020-03-01"),]
Dat = TestDat[ TestDat$Date>=as.Date("2020-03-01"),]

## Read hospitalized data
HosDat = read.csv("Data/Newly_admitted_over_time.csv",header = T,sep=";")
HosDat = HosDat[1:(length(HosDat$Dato)-1),]
n <- length(HosDat$Dato)
m <- 25

EstPos = rep(0,n)
EstHos = rep(0,n)

for (i in 1:9) {
  EstPos[i] = sum(TestDat$NewPositive[1:i])
  EstHos[i] = sum(HosDat$Total[1:i])
}
for (i in 10:n) {
  from = i-9
  EstPos[i] = sum(TestDat$NewPositive[from:i])
  EstHos[i] = sum(HosDat$Total[from:i])
}


AllDat = data.frame(
  Date = Dat$Date,
  n = n,
  t = 1:n,
  NewPositive = c(TestDat$NewPositive[1:(n-m)],rep(NA,m)),
  NotPrevPos = c(TestDat$NotPrevPos[1:(n-m)],rep(NA,m)),
  EstPos = c(EstPos[1:(n-m)],rep(NA,m)),
  NewHos = c(HosDat$Total[1:(n-m)],rep(NA,m)),
  EstHos = c(EstHos[1:(n-m)],rep(NA,m)),
  testPos = EstPos,
  testHos = EstHos)


plot(AllDat$EstPos ~ AllDat$Date)
plot(AllDat$EstHos ~ AllDat$Date)

save(AllDat, file = "AllDat.RData")
