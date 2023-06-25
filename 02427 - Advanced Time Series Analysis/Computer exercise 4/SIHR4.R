
SIHR4 <- function(data){
  data$yI <- data$EstPos
  data$yH <- data$EstHos
  data$yR <- data$Removed
  
  # Generate a new object of class ctsm
  model <- ctsm()
  
  # Add a system equation and thereby also a state
  model$addSystem(dS ~ (-(exp(Beta)/1E6)*S*I)*dt             + exp(p1)*dw1)
  model$addSystem(dI ~ ((exp(Beta)/1E6)*S*I - I*gammaI)*dt   + exp(p2)*dw2)
  model$addSystem(dH ~ (1/(1+exp(-HF/10))*gammaI*I - H*gammaH)*dt           + exp(p3)*dw3)
  model$addSystem(dR ~ ((1-1/(1+exp(-HF/10)))*I*gammaI + H*gammaH)*dt       + exp(p4)*dw4)
  model$addSystem(dBeta ~ 1/WC*(meanTemp-12)*dt + exp(p5)*dw5)
  model$addSystem(dHF ~ exp(p6)*dw6)
  
  
  
  # Set the names of the inputs
  model$addInput(meanTemp)
  
  # Set the observation equation.
  model$addObs(yI ~ I)
  model$addObs(yH ~ H)
  model$addObs(yR ~ R)
  
  # Set the variance of the measurement error
  model$setVariance(yI ~ exp(e1))
  model$setVariance(yH ~ exp(e2))
  model$setVariance(yR ~ exp(e3))
  
  ##----------------------------------------------------------------
  # Set the initial value (for the optimization) of the value of the state at the starting time point
  model$setParameter(S = 5730000)
  model$setParameter(I = 1)
  model$setParameter(H = 0)
  model$setParameter(R = 0)
  model$setParameter(Beta = c(init=-5, lb=-20,ub=5))
  model$setParameter(HF = c(init=-50, lb=-1000,ub=1000))
  
  
  ##----------------------------------------------------------------
  # Set the initial value for the optimization
  #model$setParameter(beta = c(init = 7E-8, lb = 1E-20, ub = 1))
  model$setParameter(gammaI = c(init = 1E-1, lb = 1E-20, ub = 1))
  model$setParameter(gammaH = c(init = 1E-3, lb = 1E-20, ub = 1))
  
  # model$setParameter(h = c(init = 1E-4, lb = 1E-16, ub = 1))
  
  model$setParameter(WC = c(init = 10, lb = -1E5, ub = 1E5))
  
  model$setParameter(p1 = -8)
  model$setParameter(p2 = c(init = 5, lb = -20, ub = 50))
  model$setParameter(p3 = c(init = 3, lb = -20, ub = 50))
  model$setParameter(p4 = c(init = 5, lb = -20, ub = 10))
  model$setParameter(p5 = c(init = -5, lb = -20, ub = -3))
  model$setParameter(p6 = c(init = -5, lb = -20, ub = -3))
  
  model$setParameter(e1 = c(init = -6, lb = -30, ub = 10))
  model$setParameter(e2 = c(init = -6, lb = -30, ub = 10))
  model$setParameter(e3 = c(init = -6, lb = -30, ub = 10))
  
  ##----------------------------------------------------------------
  # Run the parameter optimization
  fit = model$estimate(data,firstorder = TRUE, threads=8)
  return(fit)
}
