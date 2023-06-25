## Uses splines to model window area

sdeTiTm <- function(data, yTi,Ph){
  data$yTi <- yTi
  data$Ph <- Ph
  # Generate a new object of class ctsm
  model = ctsm()
  
  # Add a system equation and thereby also a state
  # Gv in Ti: Aw/Ci*Gv or Tm: Aw/Cm*Gv
  model$addSystem(dTi ~  1/Ci*(1/Ria*(Ta-Ti) + 1/Rim*(Tm-Ti) + Ph + (aw1*bs1 + aw3*bs3)*Gv + gamma7*J7 + gamma8*J8 + gamma9*J9 + gamma10*J10)*dt + exp(p11)*dw1)
  model$addSystem(dTm ~  1/Cm*(1/Rim*(Ti-Tm))*dt + exp(p22)*dw2)
  # Set the names of the inputs
  model$addInput()
  # Set the observation equation: Ti is the state, yTi is the measured output
  model$addObs(yTi ~ Ti)
  # Set the variance of the measurement error
  model$setVariance(yTi ~ exp(e11))
  ##----------------------------------------------------------------
  # Set the initial value (for the optimization) of the value of the state at the starting time point
  model$setParameter(Ti = c(init = 23, lb = 0, ub = 40))
  model$setParameter(Tm = c(init = 22, lb = 0, ub = 40))
  ##----------------------------------------------------------------
  # Set the initial value for the optimization
  model$setParameter(Ci = c(init = 8.2, lb = 1E-5, ub = 1E5))
  model$setParameter(Cm = c(init = 25, lb = 1E-5, ub = 1E5))
  model$setParameter(Ria = c(init = 3.5, lb = 1E-4, ub = 1E5))
  model$setParameter(Rim = c(init = 0.4, lb = 1E-4, ub = 1E5))
  
  model$setParameter(aw1 = c(init = 87, lb = 1E-5, ub = 400))
  model$setParameter(aw3 = c(init = 8, lb = 1E-5, ub = 400))
  
  model$setParameter(gamma7 = c(init = -2, lb = -100, ub = 100))
  model$setParameter(gamma8 = c(init = -4, lb = -100, ub = 100))
  model$setParameter(gamma9 = c(init = 3, lb = -100, ub = 100))
  model$setParameter(gamma10 = c(init = 6, lb = -100, ub = 100))
  
  
  model$setParameter(p11 = c(init = -9, lb = -30, ub = 10))
  model$setParameter(p22 = c(init = -0.4, lb = -30, ub = 10))
  model$setParameter(e11 = c(init = -5, lb = -50, ub = 10))
  ##----------------------------------------------------------------
  # Run the parameter optimization
  print(model)
  fit = model$estimate(data,firstorder = TRUE, threads=4)
  return(fit)
}