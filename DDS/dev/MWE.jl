using BenchmarkTools
using LinearAlgebra: norm

function nth_composite(func::F, x0, params, n_order) where {F<:Function}
    x = x0
    for _ = 1:n_order
        x = func(x, params)
    end
    return x
end

function nth_composition(func::F, n_order) where {F<:Function}
    f = let func=func, n_order=n_order
        (x, params) -> nth_composite(func, x, params, n_order)
    end
    return f
end

function F_pp(func::F, z_p::Vector{Float64}, λ::Vector{Float64}) where {F<:Function}
    return norm(func(z_p, λ).-z_p)
end

function logistic(x, p)
    return (p[1]*x[1]*(1-x[1]))
end

begin
    nth_logistic = nth_composition(logistic, 2)
    x = [0.5]
    param = [0.3]
    @time logistic(x, param)
    @time nth_logistic([0.5], [0.3])
    @time nth_logistic(x, param)
    @time nth_composite(logistic, x, param, 2)
    @time F_pp(nth_logistic, x, param)
end