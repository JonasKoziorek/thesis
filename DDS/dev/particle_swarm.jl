using ForwardDiff
using LinearAlgebra
using DDS
using Distributions: Uniform
using StaticArrays: SVector

mutable struct Particle
    position::Vector{Float64}
    velocity::Vector{Float64}
    best_position::Vector{Float64}
    best_score::Float64
end

function update_velocity(particle::Particle, global_best::Vector{Float64}, w::Float64, c1::Float64, c2::Float64)
    r1, r2 = rand(Uniform(0.0,1.0)), rand(Uniform(0.0,1.0))
    new_velocity = w .* particle.velocity .+ c1 .* r1 .* (particle.best_position .- particle.position) .+ c2 .* r2 .* (global_best .- particle.position)
    return new_velocity
end

function update_position(particle::Particle)
    new_position = particle.position .+ particle.velocity
    return new_position
end

function obj_F_pp(func::F, param) where {F<:Function}
    objective_function = let func = func, param = param
        x -> F_pp(func, x, param)
    end
    return objective_function
end

function obj_F_bif(func::F, C_pp, μ=1) where {F<:Function}
    objective_function = let func = func, C_pp = C_pp, μ = μ
        p -> F_bif(func, p, C_pp, μ)
    end
    return objective_function
end

function F_pp(func::F, z_p::Vector{Float64}, λ::Vector{Float64}) where {F<:Function}
    return norm(func(z_p, λ).-z_p)
end

function F_bif(func::F, z_b, C_pp, μ=1) where {F<:Function}
    objective_func(x) = F_pp(func, x, z_b)
    x_range = [0.0, 1.0]
    num_particles = 30
    num_iterations = 300
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5
    x0, _ = pso(objective_func, x_range, num_particles, num_iterations, w, c1, c2, tol)
    cost :: Float64 = Inf
    if F_pp(func, x0, z_b) <= C_pp
        cost = abs(det(ForwardDiff.jacobian(x->func(x, z_b), x0)-μ*I)) 
    end
    return cost
end


function pso(f::F, bounds::Vector{Float64}, num_particles::Int, num_iterations::Int, w::Float64, c1::Float64, c2::Float64, tol::Float64) where {F<:Function}
    particles = [
        Particle([rand(Uniform(bounds...))], [0.0], [rand(Uniform(bounds...))], Inf) for _ = 1:num_particles
        ]
    global_best_position, global_best_score = [rand(Uniform(bounds...))], Inf

    q = 0
    for _ = 1:num_iterations
        for p in particles
            score = f(p.position)
            q+=1
            if score < p.best_score
                p.best_score = score
                p.best_position = p.position
            end
            if score < global_best_score
                global_best_score = score
                global_best_position = p.position
            end
        end
        if global_best_score < tol
            break
        end
        @time for p in particles
            p.velocity = update_velocity(p, global_best_position, w, c1, c2)
            p.position = update_position(p)
        end
    end
    println(q)
    return global_best_position, global_best_score
end

function test()
    logistic2(x, p) = SVector(p[1]*x[1]*(1-x[1]))
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

    @time best_position, best_score = pso(objective_func, x_range, num_particles, num_iterations, w, c1, c2, tol)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end
test()

begin

    C_pp = 1e-5
    C_bif = 1e-3

    logistic2(x, p) = SVector(p[1]*x[1]*(1-x[1]))
    n = 3
    n = 12
    nth_logistic = DDS.nth_composition(logistic2, n)
    objective_func2 = obj_F_bif(nth_logistic, C_pp)

    x_range = [3.581, 3.5825]
    num_particles = 30
    num_iterations = 300
    w = 0.729
    c1 = 1.494
    c2 = c1

    @time best_position, best_score = pso(objective_func2, x_range, num_particles, num_iterations, w, c1, c2, C_bif)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end