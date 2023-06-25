#Import packages
using CSV
using DataFrames
using Printf
using JuMP
using Gurobi
using Plots

#Wood suppliers
W = collect(1:15)
#Time periods
T = collect(0:52)
#Scenarios
S = collect(1:5)
#Storage sites
K = collect(1:4)

#Paper demand data
#Read demand data from demand.csv file
#Access demand by calling d[s,t]
cd("/Users/mads/Google Drev/Skole/Uni/10_semester/Decision making under uncertainty/Group assignment/")
df_d = CSV.read("reduced-scenarios.csv", DataFrame, delim=";", header=true)
d = Array(df_d)
print(d)

#Eta - wood to paper factor - You need eta tons of wood to produce one ton of paper
eta = 2.6

#Lower bound on weekly amount wood [in tons wood] per supplier w, call by a_LB[w]
a_LB = [400 500 750 1800	800	700	550	1000	580	750	800	900	950	450	550]
#Upper bound on weekly amount wood [in tons wood] per supplier w, call by a_UB[w]
a_UB = [600 600 850 2000	900	700	650	1200	780	750	900	1000	1050	550	600]

#Price per ton wood per supplier w [EUR/ton], call by C_D[w]
C_D = [30	35	40	41	27	25	42	45	50	26	25	26	50	40	23]

#Storage limit paper [in tons paper], call by L_P[w]
L_P = 50000

#Storage price per ton paper [EUR/ton]
C_P = 1.3

#Storage limit wood [in tons wood] per storage site k, call by L_W[k]
L_W = [10000, 20000, 75000, 50000]

#Storage price for wood [EUR/ton] per storage site k_production,call by C_W[k]
C_W = [1,0.5,0.3,1.5]
#C_W = [1,0.5,1.3,1.5]

#Production capacity in tons processed wood
U = 16000

#Probabilities per scenario s, call by prob[s]
prob = [0.32 0.06 0.26 0.28 0.08]

#Penalty cost
phi = 10000
#phi = 250

#Declare model with Gurobi solver
model = Model(Gurobi.Optimizer)

#First stage variable
@variable(model, 0<=a[W,T])
@variable(model, theta[W], Bin)

#Second stage variables
@variable(model, 0<=x[T,S])
@variable(model, 0<=m[T,S])
@variable(model, 0<=u[K,T,S])
@variable(model, 0<=p[T,S])


#Declare objective function
@objective(model, Min, sum(prob[s]*(
sum(sum(a[w,t]*C_D[w] for t=T) for w=W)+
sum(x[t,s]*C_P + m[t,s]*phi for t=T)+
sum(sum(u[k,t,s]*C_W[k] for t=T) for k=K)) for s=S))

#Supplier constraint
@constraint(model,[w=W, t=T[2:end]], a[w,t] >= theta[w]*a_LB[w])
@constraint(model,[w=W, t=T[2:end]], a[w,t] <= theta[w]*a_UB[w])

#Production limit
@constraint(model,[t=T,s=S], p[t,s] <= U)

#Paper stock
@constraint(model,[t=T[2:end],s=S], x[t,s] == x[t-1,s] + p[t,s] - d[s,t] + m[t,s])
@constraint(model,[t=T,s=S], x[t,s] <= L_P)

#Wood stock
@constraint(model,[t=T[2:end],s=S], sum(u[k,t,s] for k=K) == sum(a[w,t] for w=W) + sum(u[k,t-1,s] for k=K) - p[t,s]*eta)
@constraint(model,[k=K,t=T,s=S], u[k,t,s] <= L_W[k])

#Initial stock
@constraint(model,[w=W], a[w,0] == 0)
@constraint(model,[s=S], p[0,s] == 0)
@constraint(model,[s=S], x[0,s] == 0)
@constraint(model,[k=K,s=S], u[k,0,s] == 0)

#Optimize model
optimize!(model)


#Plot solution
#Supply of wood
data = value.(a).data
data = data[:,2:53]
heatmap(1:size(data,2),
    1:size(data,1), data,
    c=cgrad([:blue, :white,:red, :yellow]),
    xlabel="Week", ylabel="Supplier",
    title="Delivery of wood")

plot(data[1,:], xlabel = "Week", ylabel = "Delivery", labels = "Supplier 1")
for w=W[2:end]
    plot!(data[w,:], labels = string("Supplier ",w))
end
fig = plot!()
savefig(fig, "RP-solA.png")

# paper of stock
data = value.(x).data
data = data[2:53,:]
plot(data[:,1], xlabel = "Week", ylabel = "Paper on stock", labels = "Scenario 1")
for s=S[2:end]
    plot!(data[:,s], labels = string("Scenario ",s))
end
fig = plot!()
savefig(fig, "RP-solPaper.png")

# Wood on stock
data = value.(u).data
data = data[:,2:53,:]
plot(data[:,:,1]', xlabel = "Week", ylabel = "Wood on stock", layout = 4,
title = ["Warehouse 1" "Warehouse 2" "Warehouse 3" "Warehouse 4"], color = 1, labels = ["" "Scenario 1" "" ""],
tickfont=6, guidefontsize=8,titlefontsize=10)
for s=S[2:end]
    plot!(data[:,:,s]', layout = 4,
    color = s, labels = ["" string("Scenario ",s) "" ""],
    tickfont=6, guidefontsize=8,titlefontsize=10)
end
fig = plot!()
savefig(fig, "RP-solWood.png")

# Deficit
data = value.(m).data
data = data[2:53,:]
plot(data[:,1], xlabel = "Week", ylabel = "Missing paper", color = 1, labels = "Scenario 1")
for s=S[2:end]
    plot!(data[:,s], color = s, labels = string("Scenario ",s))
end
fig = plot!()
savefig(fig, "RP-solM.png")

# Production
data = value.(p).data
data = data[2:53,:]
plot(data[:,1], xlabel = "Week", ylabel = "Production of paper", color = 1, labels = "Scenario 1")
for s=S[2:end]
    plot!(data[:,s], color = s, labels = string("Scenario ",s))
end
fig = plot!()
savefig(fig, "RP-solP.png")

# Production
data = value.(p).data
data = data[2:53,:]
fig = plot(data[:,:], xlabel = "Week", ylabel = ["Production of paper" "" "" "Production of paper" ""],
labels = "" , layout = 5,
title = ["Scenario 1" "Scenario 2" "Scenario 3" "Scenario 4" "Scenario 5"], tickfont=6, guidefontsize=8,
titlefontsize=10, color = collect(1:5)')
savefig(fig, "RP-solP.png")

# Demand
data = d'
fig = plot(data[:,:], xlabel = "Week", ylabel = ["Demand of paper" "" "" "Demand of paper" ""],
labels = "" , layout = 5,
title = ["Scenario 1" "Scenario 2" "Scenario 3" "Scenario 4" "Scenario 5"], tickfont=6, guidefontsize=8,
titlefontsize=10, color = collect(1:5)')
savefig(fig, "demand.png")


## TASK 3
function objFun(a, x, u, m)
    return (sum(sum(a[w,t]*C_D[w] for t=T) for w=W)+
    sum(x[t]*C_P + m[t]*phi for t=T)+
    sum(sum(u[k,t]*C_W[k] for t=T) for k=K))
end

function SP()
    #Declare model with Gurobi solver
    model = Model(Gurobi.Optimizer)
    #First stage variable
    @variable(model, 0<=a[W,T])
    @variable(model, theta[W], Bin)
    #Second stage variables
    @variable(model, 0<=x[T,S])
    @variable(model, 0<=m[T,S])
    @variable(model, 0<=u[K,T,S])
    @variable(model, 0<=p[T,S])
    #Declare objective function
    @objective(model, Min, sum(prob[s]*(
    sum(sum(a[w,t]*C_D[w] for t=T) for w=W)+
    sum(x[t,s]*C_P + m[t,s]*phi for t=T)+
    sum(sum(u[k,t,s]*C_W[k] for t=T) for k=K)) for s=S))
    #Supplier constraint
    @constraint(model,[w=W, t=T[2:end]], a[w,t] >= theta[w]*a_LB[w])
    @constraint(model,[w=W, t=T[2:end]], a[w,t] <= theta[w]*a_UB[w])
    #Production limit
    @constraint(model,[t=T,s=S], p[t,s] <= U)
    #Paper stock
    @constraint(model,[t=T[2:end],s=S], x[t,s] == x[t-1,s] + p[t,s] - d[s,t] + m[t,s])
    @constraint(model,[t=T,s=S], x[t,s] <= L_P)
    #Wood stock
    @constraint(model,[t=T[2:end],s=S], sum(u[k,t,s] for k=K) == sum(a[w,t] for w=W) + sum(u[k,t-1,s] for k=K) - p[t,s]*eta)
    @constraint(model,[k=K,t=T,s=S], u[k,t,s] <= L_W[k])
    #Initial stock
    @constraint(model,[w=W], a[w,0] == 0)
    @constraint(model,[s=S], p[0,s] == 0)
    @constraint(model,[s=S], x[0,s] == 0)
    @constraint(model,[k=K,s=S], u[k,0,s] == 0)
    #Optimize model
    optimize!(model)
    return([value.(a), value.(x), value.(u), value.(m), value.(theta)])
end

function DP(d)
    #Declare model with Gurobi solver
    model = Model(Gurobi.Optimizer)
    #First stage variable
    @variable(model, 0<=a[W,T])
    @variable(model, theta[W], Bin)
    #Second stage variables
    @variable(model, 0<=x[T])
    @variable(model, 0<=m[T])
    @variable(model, 0<=u[K,T])
    @variable(model, 0<=p[T])
    #Declare objective function
    @objective(model, Min,
    sum(sum(a[w,t]*C_D[w] for t=T) for w=W)+
    sum(x[t]*C_P + m[t]*phi for t=T)+
    sum(sum(u[k,t]*C_W[k] for t=T) for k=K))
    #Supplier constraint
    @constraint(model,[w=W, t=T[2:end]], a[w,t] >= theta[w]*a_LB[w])
    @constraint(model,[w=W, t=T[2:end]], a[w,t] <= theta[w]*a_UB[w])
    #Production limit
    @constraint(model,[t=T], p[t] <= U)
    #Paper stock
    @constraint(model,[t=T[2:end]], x[t] == x[t-1] + p[t] - d[t] + m[t])
    @constraint(model,[t=T], x[t] <= L_P)
    #Wood stock
    @constraint(model,[t=T[2:end]], sum(u[k,t] for k=K) == sum(a[w,t] for w=W) + sum(u[k,t-1] for k=K) - p[t]*eta)
    @constraint(model,[k=K,t=T], u[k,t] <= L_W[k])
    #Initial stock
    @constraint(model,[w=W], a[w,0] == 0)
    @constraint(model, p[0] == 0)
    @constraint(model, x[0] == 0)
    @constraint(model,[k=K], u[k,0] == 0)
    #Optimize model
    optimize!(model)
    return([value.(a), value.(x), value.(u), value.(m), value.(theta)])
end

function DP2(d, a, theta)
    #Declare model with Gurobi solver
    model = Model(Gurobi.Optimizer)
    #First stage variable
    #@variable(model, 0<=a[W,T])
    #@variable(model, theta[W], Bin)
    #Second stage variables
    @variable(model, 0<=x[T])
    @variable(model, 0<=m[T])
    @variable(model, 0<=u[K,T])
    @variable(model, 0<=p[T])
    #Declare objective function
    @objective(model, Min,
    sum(sum(a[w,t]*C_D[w] for t=T) for w=W)+
    sum(x[t]*C_P + m[t]*phi for t=T)+
    sum(sum(u[k,t]*C_W[k] for t=T) for k=K))
    #Supplier constraint
    @constraint(model,[w=W, t=T[2:end]], a[w,t] >= theta[w]*a_LB[w])
    @constraint(model,[w=W, t=T[2:end]], a[w,t] <= theta[w]*a_UB[w])
    #Production limit
    @constraint(model,[t=T], p[t] <= U)
    #Paper stock
    @constraint(model,[t=T[2:end]], x[t] == x[t-1] + p[t] - d[t] + m[t])
    @constraint(model,[t=T], x[t] <= L_P)
    #Wood stock
    @constraint(model,[t=T[2:end]], sum(u[k,t] for k=K) == sum(a[w,t] for w=W) + sum(u[k,t-1] for k=K) - p[t]*eta)
    @constraint(model,[k=K,t=T], u[k,t] <= L_W[k])
    #Initial stock
    @constraint(model,[w=W], a[w,0] == 0)
    @constraint(model, p[0] == 0)
    @constraint(model, x[0] == 0)
    @constraint(model,[k=K], u[k,0] == 0)
    #Optimize model
    optimize!(model)
    return([a, value.(x), value.(u), value.(m)])
end

# Stochastic solutions
model = SP()
RP = [objFun(model[1], model[2][:,s], model[3][:,:,s], model[4][:,s]) for s=S]

# Wait and see solutions
WS = zeros(length(S))
for s=S
    model2 = DP(d[s,:])
    WS[s] = objFun(model2[1], model2[2], model2[3], model2[4])
end

# Find first stage based on mean demands
model_mean = DP([sum(d[s,t]*prob[s] for s in S) for t in T[2:end]])
EEV = zeros(length(S))
#model3 = DP2(d[1,:], model_mean[1], model_mean[5])
for s in S
    model3 = DP2(d[s,:], model_mean[1], model_mean[5])
    EEV[s] = objFun(model3[1], model3[2], model3[3], model3[4])
end

print(sum(RP[s]*prob[s] for s=S))
print(sum(WS[s]*prob[s] for s=S))
print(sum(EEV[s]*prob[s] for s=S))

EVPI = sum((WS[s] - RP[s])*prob[s] for s=S)
VSS = sum((RP[s] - EEV[s])*prob[s] for s=S)
print(EVPI)
print(VSS)


plot(RP[sortperm(RP)],prob[sortperm(RP)], labels = "RP", color = "blue", xlabel = "Cost [€]", ylabel = "Probability")
scatter!(RP[sortperm(RP)],prob[sortperm(RP)], labels = "", color = "blue")
plot!(sort(WS), prob[sortperm(WS)], labels = "WS", color = "red")
scatter!(sort(WS), prob[sortperm(WS)], color = "red", labels = "")
plot!(sort(EEV), prob[sortperm(EEV)], labels = "EEV", color = "green")
scatter!(sort(EEV), prob[sortperm(EEV)], color = "green", labels = "")


##DATA FOR TASK 4
#Samples for out-of-sample test
Samples = collect(1:100)

#Read out-of-sample demand data from oos_samples.csv file
#Access demand by calling oos_d[s,t] with s being the sample id and t being the period, call by oos_d[sample id,t]
df_oosd = CSV.read("oos_samples.csv", DataFrame, delim=",", header=true)
oos_d = Array(df_oosd)

# Stochastic solutions
model = SP()
oos_rp = zeros(length(Samples))
for s in Samples
    model4 = DP2(oos_d[s,:], model[1], model[5])
    oos_rp[s] = objFun(model4[1], model4[2], model4[3], model4[4])
end

# Find first stage based on mean demands
model_mean = DP([sum(d[s,t]*prob[s] for s in S) for t in T[2:end]])
oos_eev = zeros(length(Samples))
#model3 = DP2(d[1,:], model_mean[1], model_mean[5])
for s in Samples
    model5 = DP2(oos_d[s,:], model_mean[1], model_mean[5])
    oos_eev[s] = objFun(model5[1], model5[2], model5[3], model5[4])
end

# Wait and see solutions
oos_ws = zeros(length(Samples))
for s=Samples
    model6 = DP(oos_d[s,:])
    oos_ws[s] = objFun(model6[1], model6[2], model6[3], model6[4])
end

# in sample comparison
histogram(oos_rp, color = "red", labels = "Out of sample", bins = 20, alpha = 0.5,
ylabel = "Frequency", xlabel = "Objective function value")
histogram!(RP, color = "yellow", labels = "In sample", bins = 2, alpha = 0.5)
vline!([sum(oos_rp)/length(oos_rp)], color = "red", labels = "", linewidth = 2)
fig = vline!([sum(RP)/length(RP)], color = "yellow", labels = "", linewidth = 2)
savefig(fig, "insample_comp.png")

# out of sample comparison
histogram(oos_rp, color = "red", labels = "RP", bins = 20, alpha = 0.5,
ylabel = "Frequency", xlabel = "Objective function value")
histogram!(oos_eev, color = "green", labels = "EV", bins = 40, alpha = 0.5)
histogram!(oos_ws, color = "blue", labels = "WS", bins = 2, alpha = 0.5)
vline!([sum(oos_rp)/length(oos_rp)], color = "red", labels = "", linewidth = 2)
vline!([sum(oos_eev)/length(oos_eev)], color = "green", labels = "", linewidth = 2)
fig = vline!([sum(oos_ws)/length(oos_ws)], color = "blue", labels = "", linewidth = 2)
savefig(fig, "out_sample.png")
