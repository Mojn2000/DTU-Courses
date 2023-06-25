## Uses splines to model window area

sdeTiTmAv2rooms <- function(data, yTi1,yTi2,Ph){
  data$yTi1 <- yTi1
  data$yTi2 <- yTi2
  data$Ph <- Ph
  
  # Generate a new object of class ctsm
  model = ctsm()
  
  # Add a system equation and thereby also a state
  # Gv in Ti: Aw/Ci*Gv or Tm: Aw/Cm*Gv
  model$addSystem(dTi1 ~  1/Ci1*(1/Ria*(Ta-Ti1) + 1/Rim*(Tm-Ti1) + 1/Ri1i2*(Ti1-Ti2) + Ph + (aw1*bs1 + aw3*bs3)*Gv)*dt + exp(p11)*dw11)
  model$addSystem(dTi2 ~  1/Ci2*(1/Rim*(Tm-Ti2) - 1/Ri1i2*(Ti1-Ti2) + Ph)*dt + exp(p12)*dw12)
  model$addSystem(dTm ~  1/Cm*(1/Rim*(Ti1+Ti2-2*Tm))*dt + exp(p22)*dw2)
  
  # Set the names of the inputs
  model$addInput(Ta,Gv,bs1,bs3,Ph)
  
  # Set the observation equation: Ti is the state, yTi is the measured output
  model$addObs(yTi1 ~ Ti1)
  model$addObs(yTi2 ~ Ti2)
  
  # Set the variance of the measurement error
  model$setVariance(yTi1 ~ exp(e11))
  model$setVariance(yTi2 ~ exp(e12))
  
  
  ##----------------------------------------------------------------
  # Set the initial value (for the optimization) of the value of the state at the starting time point
  model$setParameter(Ti1 = c(init = 23.6, lb = 0, ub = 40))
  model$setParameter(Ti2 = c(init = 22, lb = 0, ub = 40))
  
  model$setParameter(Tm = c(init = 22, lb = 0, ub = 40))
  ##----------------------------------------------------------------
  # Set the initial value for the optimization
  model$setParameter(Ci1 = c(init = 9, lb = 1E-5, ub = 1E5))
  model$setParameter(Ci2 = c(init = 21, lb = 1E-5, ub = 1E5))
  
  model$setParameter(Ri1i2 = c(init = 0.5, lb = 1E-5, ub = 1E5))
  
  model$setParameter(Cm = c(init = 200, lb = 1E-5, ub = 1E5))
  model$setParameter(Ria = c(init = 8700, lb = 1E-4, ub = 1E5))
  model$setParameter(Rim = c(init = 0.2, lb = 1E-4, ub = 1E5))
  
  model$setParameter(aw1 = c(init = 30, lb = 1E-5, ub = 400))
  model$setParameter(aw3 = c(init = 2.5E-5, lb = 1E-5, ub = 100))
  
  
  model$setParameter(p11 = c(init = -4, lb = -30, ub = 10))
  model$setParameter(p12 = c(init = -2.5, lb = -30, ub = 10))
  model$setParameter(p22 = c(init = -0.7, lb = -30, ub = 10))
  
  model$setParameter(e11 = c(init = -5, lb = -50, ub = 10))
  model$setParameter(e12 = c(init = -8, lb = -50, ub = 10))
  ##----------------------------------------------------------------
  # Run the parameter optimization
  
  fit = model$estimate(data,firstorder = TRUE, threads=8)
  return(fit)
}


