using ForwardDiff
using LinearAlgebra: norm, det, I
using DDS
using Distributions: Uniform
using StaticArrays: SVector, @SVector, MVector, @MVector
using BenchmarkTools

struct Particle{N, T}
    position::MVector{N, T}
    velocity::MVector{N, T}
    best_position::MVector{N, T}
    best_score::MVector{1, T}
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
    return norm(func(z_p, λ)-z_p)
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
        pos = @MVector rand(Uniform(a, b), n)
        vel = @MVector zeros(n)
        bpos = @MVector rand(Uniform(a, b), n)
        bscore = MVector(Inf)
        particles[i] = Particle{n, Float64}(pos, vel, bpos, bscore)
    end
    global_best_position = @MVector rand(Uniform(a, b), n)
    global_best_score = MVector(Inf)
    position = MVector(0.0)
    velocity = [MVector(0.0), MVector(0.1)]

    for _ = 1:num_iterations
        for p in particles
            score = MVector(f(p.position))
            if score[1] < p.best_score[1]
                p.best_score .= score
                p.best_position .= p.position
            end
            if score[1] < global_best_score[1]
                global_best_score .= score
                global_best_position .= p.position
            end
        end
        if global_best_score[1] < tol
            break
        end
        for p in particles
            r1, r2 = rand(Uniform(0.0,1.0)), rand(Uniform(0.0,1.0))
            p.velocity .= w .* p.velocity .+ (c1 .* r1) .* (p.best_position .- p.position) .+ (c2 .* r2) .* (global_best_position .- p.position)
            p.position .=  p.position .+ p.velocity
        end
    end
    return global_best_position, global_best_score[1]
end

begin
function test2()
    logistic_dim = 1
    logistic2(x::MVector{1, Float64}, p) = MVector(p[1]*x[1]*(1-x[1]))
    param = [3.235]
    n = 2
    nth_logistic = DDS.nth_composition(logistic2, n)
    objective_func = obj_F_pp(nth_logistic, param)

    x_range = [0.0, 1.0]
    num_particles = 10
    num_iterations = 100
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5

    best_position, best_score = pso(objective_func, logistic_dim, x_range, num_particles, num_iterations, w, c1, c2, tol)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end
test2()
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

begin
function test()
    @time vec = MVector(1.0, 2.0)
    @time vec = MVector(1.0, 2.0)
    @time vec .= vec + vec
end
test()
end
begin
function test()
    @time vec = MVector(1.0)
    @time p = Particle{1, Float64}(vec, vec, vec, vec)
    @time p.position .= vec .+ vec .+ vec .* vec ./ vec .- vec
    @time p.position .= vec
    @time begin
        p.position .= vec
        p.position .+= vec
        p.position .+= vec
        p.position .*= vec
        p.position ./= vec
        p.position .-= vec
    end
end
test()
end