using JuMP
using CPLEX
using Printf
using Plots

#Time periods
T = collect(1:4)

#Production targets [number of birthday cards per period]
L = [27400	42000	31800	43000]

#Capacity installation cost per unit [one pack]
C_K = 600

#Bounds on capacity installation [given in numbers of packs]
U_LB = 30
U_UB = 120

#Price per pack of paper [EUR/pack]
C_P = 2.3

#Quality variation
eps_mean = 500
eps_dev = 100

## EX 5.2
model52 = Model(CPLEX.Optimizer)

#Definition of variables
@variable(model52, 0<=x[t in T])
@variable(model52, U_LB<=y<=U_UB)


#Minimize cost
@objective(model52, Min, sum(x[t]*C_P for t in T)+y*C_K)

# Production limitation constraint
@constraint(model52, [t in T], x[t]<=y)

# Production target constraint
@constraint(model52, [t in T], x[t]*(eps_mean-eps_dev)>=L[t])

optimize!(model52)

objective_value(model52)
cap_RO = value.(y)

week_production = convert(Array{Float64}, value.(x))
plot(T,week_production, color = "blue", label = "Weekly purchase", xlabel = "Week", ylabel = "Units of paper", ylim = [60,120])
scatter!(T,week_production, color = "blue", label = "")
hline!([cap_RO], label = "Max capacity", color = "blue", linestyle=:dash)


# ARO
#Number of birthday cards resulting from one pack of paper from SuperPaper [given in number of birthday cards]
sigma = 650

#Price per extra pack of paper [EUR/pack]
gamma = 3.5

#Maximum number of packs of paper from SuperPaper [given in number of packs]
U = 20

## EX 5.4
model54 = Model(CPLEX.Optimizer)

#Definition of variables
@variable(model54, 0<=x[t in T])
@variable(model54, U_LB<=y<=U_UB)
@variable(model54, xE[t in T])
@variable(model54, QE[t in T])
@variable(model54, 0<=phi[t in T])
@variable(model54, 0<=alpha[t in T])
@variable(model54, 0<=theta[t in T])
@variable(model54, beta)


#Minimize cost
@objective(model54, Min, sum(x[t]*C_P for t in T)+y*C_K+beta)

@constraint(model54, beta>=sum(gamma*xE[t]+alpha[t] for t in T))
@constraint(model54,[t in T], -alpha[t]<=gamma*QE[t])
@constraint(model54,[t in T], alpha[t]>=gamma*QE[t])

# Production limitation constraint
@constraint(model54, [t in T], x[t]+xE[t]+phi[t]<=y)
@constraint(model54, [t in T], -phi[t]<=QE[t])
@constraint(model54, [t in T], phi[t]>=QE[t])

# Production target constraint
@constraint(model54, [t in T], x[t]*eps_mean+xE[t]*sigma-theta[t]>=L[t])
@constraint(model54, [t in T], -theta[t]<=eps_dev*x[t]+sigma*QE[t])
@constraint(model54, [t in T], theta[t]>=eps_dev*x[t]+sigma*QE[t])

# ARO variable
@constraint(model54, [t in T], xE[t]-phi[t]>=0)
@constraint(model54, [t in T], xE[t]+phi[t]<=U)


optimize!(model54)

objective_value(model54)

week_production_x = convert(Array{Float64}, value.(x))
week_production_xE = convert(Array{Float64}, value.(xE))
week_production_QE = convert(Array{Float64}, value.(QE))
week_production_xExtra = week_production_xE-week_production_QE
cap_ARO = value.(y)

plot(T,week_production_x+week_production_xExtra, color = "green", label = "Weekly purchase", xlabel = "Week", ylabel = "Units of paper")
scatter!(T,week_production_x+week_production_xExtra, color = "green", label = "")
hline!([cap_ARO], label = "Max capacity", color = "green", linestyle=:dash)

# Comparison
plot(T,week_production_x+week_production_xExtra, color = "green", label = "Weekly purchase ARO", xlabel = "Week", ylabel = "Units of paper")
scatter!(T,week_production_x+week_production_xExtra, color = "green", label = "")
plot!(T,week_production, color = "blue", label = "Weekly purchase RO")
scatter!(T,week_production, color = "blue", label = "")
hline!([cap_ARO], label = "Max capacity ARO", color = "green", linestyle=:dash)
hline!([cap_RO], label = "Max capacity RO", color = "blue", linestyle=:dash)

T_vec = convert(Array{Float64}, [1;2;3;4])
bar(T_vec.-0.2,week_production_x+week_production_xExtra, bar_width=0.4
,legend=:topleft, label = "ARO, Ad hoc", ylabel = "Units of paper bought", xlabel = "Weeks")
bar!(T_vec.-0.2,week_production_x,bar_width = 0.4, label = "ARO, Planned")
bar!(T_vec.+0.2,week_production,bar_width = 0.4, label = "RO, Planned")

T_vec = convert(Array{Float64}, [1;2;3;4])
bar(T_vec.-0.2,C_P*week_production_x+gamma.*week_production_xExtra, bar_width=0.4
 ,legend=:topleft, label = "ARO, Ad hoc", ylabel = "Purchasing Cost", xlabel = "Weeks")
bar!(T_vec.-0.2,C_P*week_production_x,bar_width = 0.4, label = "ARO, Planned")
bar!(T_vec.+0.2,C_P*week_production,bar_width = 0.4, label = "RO, Planned")

