using ForwardDiff
using LinearAlgebra: norm, det, I
using DDS
using Distributions: Uniform
using StaticArrays
using BenchmarkTools

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
    logistic2(x, p) = MVector(p[1]*x[1]*(1-x[1]))
    # n = 12
    # func2 = DDS.nth_composition(logistic2, n)
    res = logistic2(z_p, λ)
    res=norm(res.-z_p)
    return res
end

function F_bif(func::F, z_b, C_pp, n, μ=1) where {F<:Function}
    param = collect(z_b)
    objective_func(x) = F_pp(func, x, param)
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

function update_state!(velocities, positions, w, c1, c2, best_positions, global_best_position)
    r1, r2 = rand(Uniform(0.0,1.0)), rand(Uniform(0.0,1.0))
    velocities .= w .* velocities .+ (c1 .* r1) .* (best_positions .- positions) .+ (c2 .* r2) .* (global_best_position .- positions)
    positions .+= velocities

end

function evolve_particle!(f::F, i, positions, best_positions, best_scores, global_best_score, global_best_position) where {F<:Function}
    slice = @view positions[i, :]
    score= f(slice)
    if score < best_scores[i]
        best_scores[i] = score
        best_positions[i, :] .= slice
    end
    if score < global_best_score
        global_best_score = score
        global_best_position .= slice
    end
    return global_best_score
end


function pso(f::F, n::Int64, bounds::Vector{Float64}, num_particles::Int64, num_iterations::Int64, w::Float64, c1::Float64, c2::Float64, tol::Float64) where {F<:Function}
    a, b = bounds
    num_particles = 10
    n = 1
    positions = @MMatrix rand(Uniform(a, b), num_particles, n)
    velocities = @MMatrix zeros(num_particles, n)
    best_positions = deepcopy(positions)
    best_scores = Vector{Float64}(undef, num_particles)

    global_best_position = @MVector rand(Uniform(a, b), n)
    global_best_score = Inf

    for _ = 1:num_iterations
        for i in 1:num_particles
            global_best_score = evolve_particle!(f, i, positions, best_positions, best_scores, global_best_score, global_best_position)
        end
        if global_best_score < tol
            break
        end
        update_state!(velocities, positions, w, c1, c2, best_positions, global_best_position)
    end
    return global_best_position, global_best_score
end

begin
function test2()
    logistic_dim = 1
    param = [3.235]
    n = 2
    logistic2(x,p) = MVector(p[1]*x[1]*(1-x[1]))
    nth_logistic = DDS.nth_composition(logistic2, n)
    objective_func = obj_F_pp(nth_logistic, param)

    x_range = [0.0, 1.0]
    num_particles = 10
    num_iterations = 100
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5

    @time best_position, best_score = pso(objective_func, logistic_dim, x_range, num_particles, num_iterations, w, c1, c2, tol)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
    # @show @code_warntype pso(objective_func, logistic_dim, x_range, num_particles, num_iterations, w, c1, c2, tol)
end
test2()
end

begin
function test2()
    logistic_dim = 1
    logistic2(x, p) = MVector(p[1]*x[1]*(1-x[1]))

    C_pp = 1e-5
    C_bif = 1e-3

    n = 3
    n = 12
    nth_logistic = DDS.nth_composition(logistic2, n)
    objective_func2 = obj_F_bif(nth_logistic, C_pp, logistic_dim)

    x_range = [3.581, 3.5825]
    num_particles = 10
    num_iterations = 100
    w = 0.729
    c1 = 1.494
    c2 = c1

    @time best_position, best_score = pso(objective_func2, logistic_dim, x_range, num_particles, num_iterations, w, c1, c2, C_bif)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end
test2()
test2()
end

begin
function test()
    logistic = (x,p) -> MVector(p[1]*x[1]*(1-x[1]))
    nth_logistic = DDS.nth_composition(logistic, 12)
    x = MVector(0.5)
    p = MVector(0.5)
    @time nth_logistic(x, p)
end
test()
end