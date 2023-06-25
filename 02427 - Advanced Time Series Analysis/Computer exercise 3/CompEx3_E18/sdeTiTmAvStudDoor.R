## Uses splines to model window area
## Uses stud to model students present
## Include students opening doors 


sdeTiTmAvStudDoor <- function(data, yTi,Ph){
  data$yTi <- yTi
  data$Ph <- Ph
  # Generate a new object of class ctsm
  model = ctsm()
  
  # Add a system equation and thereby also a state
  # Gv in Ti: Aw/Ci*Gv or Tm: Aw/Cm*Gv
  model$addSystem(dTi ~  1/Ci*(1/Ria*(Ta-Ti) + 1/Rim*(Tm-Ti) + 1/DoorFlow*stud*(Ta-Ti)  + ha*Ph + (aw1*bs1 + aw2*bs2 + aw3*bs3 + aw4*bs4 + aw5*bs5)*Gv)*dt + (stud*sigmaStud + exp(p11))*dw1)
  model$addSystem(dTm ~  1/Cm*(1/Rim*(Ti-Tm)+(1-ha)*Ph)*dt + exp(p22)*dw2)
  # Set the names of the inputs
  model$addInput(Ta,Gv,Ph,bs1,bs2,bs3,bs4,bs5,stud)
  # Set the observation equation: Ti is the state, yTi is the measured output
  model$addObs(yTi ~ Ti)
  # Set the variance of the measurement error
  model$setVariance(yTi ~ exp(e11))
  ##----------------------------------------------------------------
  # Set the initial value (for the optimization) of the value of the state at the starting time point
  model$setParameter(Ti = c(init = 15, lb = 0, ub = 40))
  model$setParameter(Tm = c(init = 15, lb = 0, ub = 40))
  ##----------------------------------------------------------------
  # Set the initial value for the optimization
  model$setParameter(Ci = c(init = 1, lb = 1E-5, ub = 1E5))
  model$setParameter(Cm = c(init = 1000, lb = 1E-5, ub = 1E5))
  model$setParameter(Ria = c(init = 20, lb = 1E-4, ub = 1E5))
  model$setParameter(Rim = c(init = 20, lb = 1E-4, ub = 1E5))
  
  model$setParameter(DoorFlow = c(init = 20, lb = 1E-4, ub = 1E5))
  
  #model$setParameter(Aw = c(init = 6, lb = 1E-2, ub = 7.5+4.8+5))
  
  model$setParameter(aw1 = c(init = 35, lb = 20, ub = 50))
  model$setParameter(aw2 = c(init = 0.1, lb = 1E-2, ub = 10))
  model$setParameter(aw3 = c(init = 8, lb = 1E-2, ub = 10))
  model$setParameter(aw4 = c(init = 8, lb = 1E-2, ub = 10))
  model$setParameter(aw5 = c(init = 10, lb = 1E-2, ub = 15))
  
  
  model$setParameter(ha = c(init = 0.9, lb = 0, ub = 1))
  
  model$setParameter(sigmaStud = c(init = 1, lb = -5, ub = 5))
  
  model$setParameter(p11 = c(init = 1, lb = -5, ub = 5))
  model$setParameter(p22 = c(init = 1, lb = -5, ub = 5))
  model$setParameter(e11 = c(init = -1, lb = -50, ub = 10))
  ##----------------------------------------------------------------    
  
  # Run the parameter optimization
  
  fit = model$estimate(data,firstorder = TRUE)
  return(fit)
}
