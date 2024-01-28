using ForwardDiff
using LinearAlgebra
using DDS
using Distributions: Uniform

function F_pp(n::Int, z_p, λ)
    func = DDS.nth_composition(DDS.logistic, n)
    return norm(func(z_p, λ) - z_p)
end

function F_bif(n, z_b, C_pp=1e-5, μ=1) where {F<:Function}
    x_range = [0.0, 1.0]
    num_particles = 10
    num_iterations = 100
    w = 0.729
    c1 = 1.494
    c2 = c1
    x0, _ = pso1(n, z_b, x_range, num_particles, num_iterations, w, c1, c2, C_pp)
    func = DDS.nth_composition(DDS.logistic, n)

    cost :: Float64 = Inf
    if F_pp(n, x0, z_b) <= C_pp
        cost = abs(ForwardDiff.derivative(x->func(x, z_b), x0)-μ)
    end
    return cost
end


function pso1(n::Int, param, bounds, num_particles::Int, num_iterations::Int, w::Float64, c1::Float64, c2::Float64, tol::Float64)
    a, b = bounds
    positions = rand(Uniform(a,b), num_particles)
    velocities = zeros(num_particles)
    best_positions = rand(Uniform(a,b), num_particles)
    best_scores = Inf .* ones(num_particles)
    global_best_position, global_best_score = rand(Uniform(a, b)), Inf

    for _ = 1:num_iterations
        for i in 1:num_particles
            score = F_pp(n, positions[i], param)
            if score < best_scores[i]
                best_scores[i] = score
                best_positions[i] = positions[i]
            end
            if score < global_best_score
                global_best_score = score
                global_best_position = positions[i]
            end
        end
        if global_best_score < tol
            break
        end
        for j in 1:num_particles
            r1, r2 = rand(Uniform(0.0,1.0)), rand(Uniform(0.0,1.0))
            velocities[j] = w .* velocities[j] .+ (c1 .* r1) .* (best_positions[j] .- positions[j]) .+ (c2 .* r2) .* (global_best_position .- positions[j])
            positions[j] = positions[j] .+ velocities[j]
        end
    end

    return global_best_position, global_best_score
end

function pso2(n::Int, bounds, num_particles::Int, num_iterations::Int, w::Float64, c1::Float64, c2::Float64, tol::Float64)
    a, b = bounds
    positions = rand(Uniform(a,b), num_particles)
    velocities = zeros(num_particles)
    best_positions = rand(Uniform(a,b), num_particles)
    best_scores = Inf .* ones(num_particles)
    global_best_position, global_best_score = rand(Uniform(a, b)), Inf

    for _ = 1:num_iterations
        for i in 1:num_particles
            score = F_bif(n, positions[i])
            if score < best_scores[i]
                best_scores[i] = score
                best_positions[i] = positions[i]
            end
            if score < global_best_score
                global_best_score = score
                global_best_position = positions[i]
            end
        end
        if global_best_score < tol
            break
        end
        for j in 1:num_particles
            r1, r2 = rand(Uniform(0.0,1.0)), rand(Uniform(0.0,1.0))
            velocities[j] = w .* velocities[j] .+ (c1 .* r1) .* (best_positions[j] .- positions[j]) .+ (c2 .* r2) .* (global_best_position .- positions[j])
            positions[j] = positions[j] .+ velocities[j]
        end
    end

    return global_best_position, global_best_score
end

begin
    # logistic2(x, p) = SVector(p[1]*x[1]*(1-x[1]))
    param = (3.235)
    n = 3
    # nth_logistic = DDS.nth_composition(logistic2, n)
    # objective_func = obj_F_pp(nth_logistic, param)

    x_range = [0.0, 1.0]
    num_particles = 30
    num_iterations = 300
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5

    @time best_position, best_score = pso1(n, param, x_range, num_particles, num_iterations, w, c1, c2, tol)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end

begin
    C_pp = 1e-5
    C_bif = 1e-5

    # x_range = [3.825, 3.83]
    # n = 3


    x_range = [3.581, 3.5825]
    n = 12

    # x_range = [3.700, 3.702]
    # n = 7


    num_particles = 10
    num_iterations = 100
    w = 0.729
    c1 = 1.494
    c2 = c1

    @time best_position, best_score = pso2(n, x_range, num_particles, num_iterations, w, c1, c2, C_bif)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end