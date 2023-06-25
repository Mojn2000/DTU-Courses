using JuMP
using CPLEX
using Printf
using LinearAlgebra

D = [1 1 ; -1 -1]
d = [8 -2]

## EX 6.1
model61 = Model(CPLEX.Optimizer)

#Definition of variables
@variable(model61, x[i=1:3])
@variable(model61, lambda[j=1:2])

#Minimize cost
c = [-10;-20;-15]
@objective(model61, Min, dot(c,x))

# bounds
x_lb = [-2;0;-10]
x_ub = [10;15;10]
lambda_lb =  [0;0]
@constraint(model61,x_lb .<= x)
@constraint(model61,x_ub .>= x)
@constraint(model61,lambda_lb .<= lambda)

# non uncertain
vec = [7;-2;-2]
@constraint(model61, dot(vec,x)>=5)

# uncertain
@constraint(model61, 5*x[1]+dot(d,lambda)<=10)
@constraint(model61, D'*lambda.>=x[2:3])

optimize!(model61)
-objective_value(model61)

## EX 6.2
model62 = Model(CPLEX.Optimizer)

#Definition of variables
@variable(model62, x[i=1:3])
@variable(model62, y[i=1:3]>=0)
@variable(model62, mu[i=1:3]>=0)
@variable(model62, lambda>=0)

#Minimize cost
c = [-10;-20;-15]
@objective(model62, Min, dot(c,x))

# bounds
x_lb = [-2;0;-10]
x_ub = [10;15;10]
@constraint(model62,x_lb .<= x)
@constraint(model62,x_ub .>= x)

# non uncertain
vec = [7;-2;-2]
@constraint(model62, dot(vec,x)>=5)

# uncertain
vec_mean = [4.5 ; 5.5; 3]
vec_dev = [3.5; 3.5; 2]
I = collect(1:3)
@constraint(model62, vec_mean'*x+2*lambda+sum(mu[i] for i in I)<=10)
@constraint(model62, [i in I], lambda+mu[i]>=vec_dev[i]*y[i])
@constraint(model62, [i in I], x[i]<=y[i])
@constraint(model62, [i in I], x[i]>=-y[i])

optimize!(model62)
-objective_value(model62)