using DDS
using Metaheuristics
using JuMP, Ipopt
using CairoMakie
using NLsolve

function logistic_new(x, p)
    return p[1]*x*(1-x)
end

begin
    x = 0.5
    p = [3.835]

    order = 3
    logistic_a = DDS.nth_composition(logistic_new, order)
    logistic_b = DDS.nth_composition(logistic_new, order-1)

    fig = Figure()
    ax = Axis(fig[1,1])
    # lines!(ax, LinRange(0,1,100), [logistic_new(x, p)-x for x in LinRange(0,1,100)], color=:blue)
    # lines!(ax, LinRange(0,1,100), [logistic_new(x, p)/x-1 for x in LinRange(0,1,100)], color=:green)

    lines!(ax, LinRange(0,1,1000), [logistic_a(x, p) for x in LinRange(0,1,1000)], color=:green)
    lines!(ax, LinRange(0,1,100), LinRange(0,1,100), color=:black)
    # lines!(ax, LinRange(0,1,100), [logistic_a(x, p)/x - 1 for x in LinRange(0,1,100)], color=:red)
    lines!(ax, [0, 1], [0, 0], color=:black)
    display(fig)
end

function nth_string(n, x="x", p="p")
    x = string_log(x, p)
    p = "p"
    if n == 1
        return x
    end
    return nth_string(n-1, x, p)
end

function string_log(x, r)
    return "($r)*($x)*(1-($x))"
end

function L(x, p)
    return p*x*(1-x)
end

L3(x, p) = L(L(L(x, p), p), p)

function f(x)
    x, y, z, r = x
    return [
        L(z, r),
        L(x,r),
        L(y,r),
        r^3*(1-2*z)*(1-2*y)*(1-2*x)-1
    ]
end

sol = nlsolve(f, [ 0.1, 1.2, 0.5, 0.7])
sol.zero
println(sol.zero)


begin
model = Model(Ipopt.Optimizer)
@variable(model, 0 <= x <= 1)
@variable(model, 3.5 <= r <= 4.0)
@NLobjective(model, Min, (L3(x,r)-x)^2 + (L3(L(x, r), r)-L(x,r))^2 + (L3(L(L(x, r), r), r)-L(L(x, r), r))^2 + (r^3*(1-2*x)*(1-2*L(x, r))*(1-2*L(L(x, r), r))-1)^2)
optimize!(model)
println(value(r))
end
# println(value(x))
# println(value(L(x, value(r))))


function objective(input)
    x, r = input
    result = (L3(x,r)-x)^2 + (L3(L(x, r), r)-L(x,r))^2 + (L3(L(L(x, r), r), r)-L(L(x, r), r))^2 + (r^3*(1-2*x)*(1-2*L(x, r))*(1-2*L(L(x, r), r))-1)^2
    return result
end

function objective(input; order=3)
    x, r = input
    T1 = DDS.itera0e(L, x, r, order-1)
    L_n = DDS.nth_composition(L, order)
    T2 = L_n.(T1, r)
    J = DDS.jacobian(L_n)
    result = sum((T2.-T1) .^ 2) + (J(x, r)-1)^2
    return result
end

f(x) = objective(x; order=3)
bounds = BoxConstrainedSpace(lb = [0.0;3.6], ub = [1.0;4.0])
result = optimize(f, bounds, ECA())
x = result.best_sol.x

g(x) = objective(x;order=12)
bounds = BoxConstrainedSpace(lb = [0.0;3.581], ub = [1.0;3.5825])
result = optimize(g, bounds, ECA())
x = result.best_sol.x



using Plots
begin
    x = LinRange(0.0, 1.0, 1000)
    p = LinRange(3.0, 4.0, 1000)
    z = Float64[]
    for i in x
        for j in p
            push!(z, objective([i, j];order=3))
        end
    end
    Plots.plot(x, p, z,st=:surface,camera=(90,0))
end

using PyPlot
pygui(true)

begin
    x = LinRange(0.0, 1.0, 1000)
    p = LinRange(0.0, 4.0, 1000)
    z = Float64[]
    for i in x
        for j in p
            push!(z, objective([i, j];order=3))
        end
    end
    z = reshape(z, 1000, 1000)
    
    PyPlot.surf(z)
end