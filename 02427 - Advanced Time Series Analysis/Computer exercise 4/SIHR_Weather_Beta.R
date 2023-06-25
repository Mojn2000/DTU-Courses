# Features beta as a new state

SIHR_Weather_Beta <- function(data){
  data$yI <- data$EstPos
  data$yH <- data$EstHos
  data$yR <- data$Removed
  
  # Generate a new object of class ctsm
  model <- ctsm()
  
  # Add a system equation and thereby also a state
  model$addSystem(dS ~ (-(exp(Beta - WC*aveTemp)/1E6)*S*I)*dt             + exp(p1)*dw1)
  model$addSystem(dI ~ ((exp(Beta - WC*aveTemp)/1E6)*S*I - I*exp(gammaI))*dt   + exp(p2)*dw2)
  model$addSystem(dH ~ (exp(hf)*exp(gammaI)*I - H*exp(gammaH))*dt           + exp(p3)*dw3)
  model$addSystem(dR ~ ((1 - exp(hf))*I*exp(gammaI) + H*exp(gammaH))*dt       + exp(p4)*dw4)
  model$addSystem(dBeta ~ exp(p5)*dw5)
  
  # Set the names of the inputs
  model$addInput(aveTemp)
  
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
  model$setParameter(I = c(init = 2, lb = 0, ub = 10))
  model$setParameter(H = 0)
  model$setParameter(R = 0)
  model$setParameter(Beta = c(init = -3.5, lb = -10, ub = 0))
  
  ##----------------------------------------------------------------
  # Set the initial value for the optimization
  model$setParameter(hf = c(init = -5, lb = -40, ub = 0))
  model$setParameter(gammaI = c(init = -2.5, lb = -40, ub = 0))
  model$setParameter(gammaH = c(init = -5.2, lb = -40, ub = 0))
  model$setParameter(WC = c(init=-0.10170, lb=-1,ub=1))
  
  model$setParameter(p1 = c(init = 4, lb = -10, ub = 10))
  model$setParameter(p2 = c(init = 3.7, lb = -15, ub = 10))
  model$setParameter(p3 = c(init = 2.5, lb = -10, ub = 10))
  model$setParameter(p4 = c(init = 4.5, lb = -10, ub = 10))
  model$setParameter(p5 = -5)
  
  model$setParameter(e1 = c(init = -8, lb = -30, ub = 5))
  model$setParameter(e2 = c(init = -10, lb = -30, ub = 5))
  model$setParameter(e3 = c(init = -8, lb = -30, ub = 5))
  
  ##----------------------------------------------------------------
  # Run the parameter optimization
  fit = model$estimate(data,firstorder = TRUE, threads=8)
  return(fit)
}