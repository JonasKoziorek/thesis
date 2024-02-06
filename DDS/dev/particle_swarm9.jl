using ForwardDiff
using LinearAlgebra: norm, det, I
using DDS
using Distributions: Uniform
using StaticArrays: SVector, @SVector
using Setfield
using BenchmarkTools

mutable struct Structure{N, T}
    pos::SVector{N, T}
end

struct Structure2{N, T}
    pos::SVector{N, T}
end

begin
    @time SVector(0.5, 0.3, 3.2) .+ SVector(2.3, 34.2, 2.3)
    @time a = SVector(0.5, 0.3, 3.2) .+ SVector(2.3, 34.2, 2.3)
    @time structure = Structure{3, Float64}(a)
    @time structure.pos = a

    @time structure2 = Structure2{3, Float64}(a)
    @time structure2 = @set structure2.pos = SVector(0.0, 0, 0)
end

mutable struct Particle{N, T}
    position::SVector{N, T}
    velocity::SVector{N, T}
    best_position::SVector{N, T}
    best_score::T
end

function obj_F_pp(func::F, param) where {F<:Function}
    objective_function = let func = func, param = param
        x -> F_pp(func, x, param)
    end
    return objective_function
end

function obj_F_bif(func::F, C_pp, n, μ=1) where {F<:Function}
    objective_function = let func = func, C_pp = C_pp, μ = μ, n=n
        p -> F_bif(func, p, C_pp, n, μ)
    end
    return objective_function
end

function F_pp(func::F, z_p, λ) where {F<:Function}
    return norm(func(z_p, λ).-z_p)
end

function F_bif(func::F, z_b, C_pp, n, μ=1) where {F<:Function}
    objective_func(x) = F_pp(func, x, z_b)
    x_range = [0.0, 1.0]
    num_particles = 30
    num_iterations = 300
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5
    x0, _ = pso(objective_func, n, x_range, num_particles, num_iterations, w, c1, c2, tol)
    cost :: Float64 = Inf
    if F_pp(func, x0, z_b) <= C_pp
        cost = abs(det(ForwardDiff.jacobian(x->func(x, z_b), x0)-μ*I)) 
    end
    return cost
end


function pso(f::F, n::Int, bounds::Vector{Float64}, num_particles::Int, num_iterations::Int, w::Float64, c1::Float64, c2::Float64, tol::Float64) where {F<:Function}
    a, b = bounds
    particles = Vector{Particle{n, Float64}}(undef, num_particles)
    for i = 1:num_particles
        pos = @SVector rand(Uniform(a, b), n)
        vel = @SVector zeros(n)
        bpos = @SVector rand(Uniform(a, b), n)
        bscore = Inf
        particles[i] = Particle{n, Float64}(pos, vel, bpos, bscore)
    end
    global_best_position = @SVector rand(Uniform(a, b), n)
    global_best_score = Inf

    for _ = 1:num_iterations
        for i in 1:num_particles
            p = particles[i]
            score = f(p.position)
            if score < p.best_score
                p = @set p.best_score = score
                p = @set p.best_position = p.position
            end
            if score < global_best_score
                global_best_score = score
                global_best_position = p.position
            end
        end
        if global_best_score < tol
            break
        end
        for i in 1:num_particles
            p = particles[i]
            r1, r2 = rand(Uniform(0.0,1.0)), rand(Uniform(0.0,1.0))
            p = @set p.velocity = w .* p.velocity .+ (c1 .* r1) .* (p.best_position .- p.position) .+ (c2 .* r2) .* (global_best_position .- p.position)
            p = @set p.position =  p.position .+ p.velocity
        end
    end
    return global_best_position, global_best_score
end

begin
    logistic_dim = 1
    logistic2(x::SVector{1, Float64}, p) = SVector(p[1]*x[1]*(1-x[1]))
    param = [3.235]
    n = 2
    nth_logistic = DDS.nth_composition(logistic2, n)
    objective_func = obj_F_pp(nth_logistic, param)

    x_range = [0.0, 1.0]
    num_particles = 30
    num_iterations = 300
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5

    best_position, best_score = pso(objective_func, logistic_dim, x_range, num_particles, num_iterations, w, c1, c2, tol)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end

begin
    logistic_dim = 1
    logistic2(x, p) = SVector(p[1]*x[1]*(1-x[1]))

    C_pp = 1e-5
    C_bif = 1e-3

    n = 3
    n = 12
    nth_logistic = DDS.nth_composition(logistic2, n)
    objective_func2 = obj_F_bif(nth_logistic, C_pp, logistic_dim)

    x_range = [3.581, 3.5825]
    num_particles = 30
    num_iterations = 300
    w = 0.729
    c1 = 1.494
    c2 = c1

    @time best_position, best_score = pso(objective_func2, logistic_dim, x_range, num_particles, num_iterations, w, c1, c2, C_bif)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end