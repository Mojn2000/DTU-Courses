## Uses splines to model window area

SHR <- function(data){
  data$yH <- data$Hos
  data$yR <- data$Recovered
  
  # Generate a new object of class ctsm
  model <- ctsm()
  
  # Add a system equation and thereby also a state
  model$addSystem(dS ~ -beta*(S*H)*dt + exp(p1)*dw1)
  model$addSystem(dH ~  (beta*S*H - gamma*H)*dt + exp(p2)*dw2)
  model$addSystem(dR ~  (gamma*H)*dt + exp(p3)*dw3)
  
  # Set the names of the inputs
  #model$addInput()
  
  # Set the observation equation.
  model$addObs(yH ~ H)
  model$addObs(yR ~ R)
  
  # Set the variance of the measurement error
  model$setVariance(yH ~ exp(e2))
  model$setVariance(yR ~ exp(e3))
  
  ##----------------------------------------------------------------
  # Set the initial value (for the optimization) of the value of the state at the starting time point
  model$setParameter(S = c(init = 6000000, lb = 0, ub = 8000000))
  model$setParameter(H = c(init = 1, lb = 0, ub = 100000))
  model$setParameter(R = c(init = 1, lb = 0, ub = 100000))
  ##----------------------------------------------------------------
  
  # Set the initial value for the optimization
  model$setParameter(beta = c(init = 1E-4, lb = 1E-12, ub = 1E2))
  model$setParameter(gamma = c(init = 1E-4, lb = 1E-12, ub = 1E2))

  model$setParameter(p1 = c(init = 9, lb = -30, ub = 10))
  model$setParameter(p2 = c(init = -7, lb = -30, ub = 10))
  model$setParameter(p3 = c(init = 1, lb = -50, ub = 10))
  
  model$setParameter(e2 = c(init = 3, lb = -30, ub = 10))
  model$setParameter(e3 = c(init = 3, lb = -30, ub = 10))
  
  ##----------------------------------------------------------------
  # Run the parameter optimization
  fit = model$estimate(data,firstorder = TRUE, threads=8)
  return(fit)
}


