
SIHR <- function(data){
  data$yI <- data$EstPos
  data$yH <- data$EstHos
  
  # Generate a new object of class ctsm
  model <- ctsm()
  
  # Add a system equation and thereby also a state
  model$addSystem(dS ~ (-exp(beta)*S*I)*dt             + exp(p1)*dw1)
  model$addSystem(dI ~ (exp(beta)*S*I - I*gammaI)*dt   + exp(p2)*dw2)
  model$addSystem(dH ~ (h*gammaI*I - H*gammaH)*dt + exp(p3)*dw3)
  model$addSystem(dR ~ ((1-h)*I*gammaI + H*gammaH)*dt + exp(p4)*dw4)
  
  # Set the names of the inputs
  # model$addInput(yH2)
  
  # Set the observation equation.
  model$addObs(yI ~ I)
  model$addObs(yH ~ H)
  
  # Set the variance of the measurement error
  model$setVariance(yH ~ exp(e1))
  model$setVariance(yH ~ exp(e2))
  
  ##----------------------------------------------------------------
  # Set the initial value (for the optimization) of the value of the state at the starting time point
  model$setParameter(S = 5730000)
  model$setParameter(I = 1)
  model$setParameter(H = 0)
  model$setParameter(R = 0)
  
  ##----------------------------------------------------------------
  # Set the initial value for the optimization
  model$setParameter(beta = c(init = 7E-8, lb = 1E-20, ub = 1))
  model$setParameter(gammaI = c(init = 1E-1, lb = 1E-16, ub = 1))
  model$setParameter(gammaH = c(init = 1E-8, lb = 1E-16, ub = 1))
  
  model$setParameter(h = c(init = 1E-3, lb = 1E-16, ub = 1))
  
  model$setParameter(p1 = c(init = 2, lb = -10, ub = 50))
  model$setParameter(p2 = c(init = 5, lb = -15, ub = 5))
  model$setParameter(p3 = c(init = 3, lb = -10, ub = 10))
  model$setParameter(p4 = c(init = 0.5, lb = -10, ub = 10))

  model$setParameter(e1 = c(init = -2.5, lb = -30, ub = 10))
  model$setParameter(e2 = c(init = -11, lb = -30, ub = 10))
  
  ##----------------------------------------------------------------
  # Run the parameter optimization
  fit = model$estimate(data,firstorder = TRUE, threads=8)
  return(fit)
}
