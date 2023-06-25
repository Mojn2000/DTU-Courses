## Uses splines to model window area

SEIHR <- function(data){
  data$yH <- data$Hos
  data$yR <- data$Recovered
  
  # Generate a new object of class ctsm
  model <- ctsm()
  
  # Add a system equation and thereby also a state
  model$addSystem(dS ~ (-beta*S*I)*dt             + exp(p1)*dw1)
  model$addSystem(dE ~ (beta*S*I - gammaE*E)*dt + exp(p2)*dw2)
  model$addSystem(dI ~ (gammaE*E - gammaI*I)*dt + exp(p3)*dw3)
  model$addSystem(dH ~ (h*gammaI*I - H*gammaH)*dt + exp(p4 + yH2*p44)*dw4)
  model$addSystem(dR ~ ((1-h)*gammaI*I + H*gammaH)*dt + exp(p5)*dw5)
  
  # Set the names of the inputs
  model$addInput(yH2)
  
  # Set the observation equation.
  model$addObs(yH ~ H)
  #model$addObs(yHR ~ HR)
  
  # Set the variance of the measurement error
  model$setVariance(yH ~ exp(e1))
  #model$setVariance(yHR ~ exp(e2))
  
  ##----------------------------------------------------------------
  # Set the initial value (for the optimization) of the value of the state at the starting time point
  model$setParameter(S = c(init = 6000000, lb = 5000000, ub = 7000000))
  model$setParameter(E = c(init = 1, lb = 0, ub = 100))
  model$setParameter(I = c(init = 1, lb = 0, ub = 100))
  model$setParameter(H = c(init = 1, lb = 0, ub = 100))
  model$setParameter(R = c(init = 1, lb = 0, ub = 100))
  
  ##----------------------------------------------------------------
  # Set the initial value for the optimization
  model$setParameter(beta = c(init = 1E-12, lb = 1E-20, ub = 1))
  model$setParameter(gammaE = c(init = 1E-4, lb = 1E-16, ub = 1))
  model$setParameter(gammaI = c(init = 1E-4, lb = 1E-16, ub = 1))
  model$setParameter(gammaH = c(init = 1E-8, lb = 1E-16, ub = 1))
  
  model$setParameter(h = c(init = 1E-4, lb = 1E-16, ub = 1))
  
  model$setParameter(p1 = c(init = 1, lb = -10, ub = 50))
  model$setParameter(p2 = c(init = -5, lb = -15, ub = 5))
  model$setParameter(p22 = c(init = -5, lb = -15, ub = 5))
  model$setParameter(p3 = c(init = 5, lb = -10, ub = 10))
  model$setParameter(p33 = c(init = -2, lb = -10, ub = 10))
  model$setParameter(p4 = c(init = 2, lb = -10, ub = 10))
  model$setParameter(p44 = c(init = 1E-5, lb = -10, ub = 10))
  model$setParameter(p5 = c(init = 1, lb = -10, ub = 10))
  
  model$setParameter(e1 = c(init = -3, lb = -30, ub = 10))
  model$setParameter(e2 = c(init = -3, lb = -30, ub = 10))
  
  ##----------------------------------------------------------------
  # Run the parameter optimization
  fit = model$estimate(data,firstorder = TRUE, threads=8)
  return(fit)
}