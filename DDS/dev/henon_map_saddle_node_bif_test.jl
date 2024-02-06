using StaticArrays
using ForwardDiff
using LinearAlgebra
using DDS
using Distributions: Uniform
using BenchmarkTools

struct System{N, M, T}
    rule
    jacob_rule
    dim::Int64
    state::MVector{N, T}
    params::MVector{M, T}
    J::MMatrix{N, N, T}

    System{N, M, T}(rule, jacob_rule, state::MVector{N, T}, params::MVector{M, T}) where {N, M, T}= new(rule, jacob_rule, length(state), state, params, @MMatrix ones(N, N))
end

function logistic_rule(out, x, p)
    out[1] = p[1]*x[1]*(1-x[1])
    return nothing
end

function logistic_jacobian(out, x, p)
    out[1, 1] *= p[1]*(1-2*x[1])
    return nothing
end

function reset_J(s::System)
    for i in 1:s.dim
        for j in 1:s.dim
            s.J[i, j] = 1
        end
    end
end

function trajectory(s::System, m::Int64, n::Int64=1)
    T = [typeof(s.state)(undef) for _ in 1:m+1] 
    T[1] .= s.state
    for i in 2:m+1
        step!(s, n)
        T[i] .= s.state
    end
    return T
end

function jacobian!(s::System, n::Int64=1)
    reset_J(s)
    for _ = 0:(n-1)
        s.jacob_rule(s.J, s.state, s.params)
        step!(s, 1)
    end
end

function step!(system::System, n::Int64=1)
    for i in 1:n
        system.rule(system.state, system.state, system.params)
    end
end

function state!(s::System, state)
    s.state .= state
    return nothing
end

function params!(s::System, params)
    s.params .= params
    return nothing
end

function update_state!(velocities, positions, w, c1, c2, best_positions, global_best_position)
    r1, r2 = rand(Uniform(0.0,1.0)), rand(Uniform(0.0,1.0))
    velocities .= w .* velocities .+ (c1 .* r1) .* (best_positions .- positions) .+ (c2 .* r2) .* (global_best_position' .- positions)
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


function pso(f::F, ::Val{n}, bounds::Vector{Float64}, num_particles::Int64, num_iterations::Int64, w::Float64, c1::Float64, c2::Float64, tol::Float64) where {F<:Function, n}
    a, b = bounds
    num_particles = 30
    positions = @MMatrix rand(Uniform(a, b), num_particles, n)
    velocities = @MMatrix zeros(num_particles, n)
    best_positions = @MMatrix rand(Uniform(a, b), num_particles, n)
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

function pso2(f::F, ::Val{n}, bounds::Vector{Float64}, num_particles::Int64, num_iterations::Int64, w::Float64, c1::Float64, c2::Float64, tol::Float64) where {F<:Function, n}
    a, b = bounds
    a, b= 1.29, 1.302
    c, d = 0.3, 0.3
    num_particles = 30
    positions = @MMatrix zeros(num_particles, n)
    velocities = @MMatrix zeros(num_particles, n)
    best_positions = @MMatrix zeros(num_particles, n)
    best_scores = Vector{Float64}(undef, num_particles)
    for i= 1:num_particles
        positions[i, 1] = rand(Uniform(a,b))
        # positions[i, 2] = rand(Uniform(c,d))
        positions[i, 2] = 0.3
        best_positions[i, 1] = rand(Uniform(a,b))
        # best_positions[i, 2] = rand(Uniform(c,d))
        best_positions[i, 2] = 0.3
    end

    # global_best_position = MVector(rand(Uniform(a, b)), rand(Uniform(c, d)))
    global_best_position = MVector(rand(Uniform(a, b)), 0.3)
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

function F_pp(s::System, x, param, n)
    state!(s, x)
    params!(s, param)
    step!(s, n)
    return norm(s.state.-x)
end

function F_bif(s::System, param, C_pp, n, μ=1)
    objective_function(x) = F_pp(s, x, param, n)
    x_range = [-2.0, 2.0]
    num_particles = 10
    num_iterations = 100
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5
    x0, _ = pso(objective_function, Val(s.dim), x_range, num_particles, num_iterations, w, c1, c2, tol)
    cost :: Float64 = Inf
    if objective_function(x0) <= C_pp
        state!(s, x0)
        jacobian!(s, n)
        sub_diag!(s, μ)
        cost = abs(det(s.J)) 
    end
    return cost
end

function sub_diag!(s::System, c)
    for i = 1:s.dim
        s.J[i, i] = c
    end
    return nothing
end

begin
function test2()
    dim = 1
    dim_params = 1
    n = 12
    param = MVector(3.235)
    logistic = System{dim, dim_params, Float64}(logistic_rule, logistic_jacobian, MVector(0.7), MVector(3.895))
    obj_func(x) = F_pp(logistic, x, param, n)

    x_range = [0.0, 1.0]
    num_particles = 10
    num_iterations = 100
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5

    @time best_position, best_score = pso(obj_func, Val(dim), x_range, num_particles, num_iterations, w, c1, c2, tol)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
    # @show @code_warntype pso(objective_func, logistic_dim, x_range, num_particles, num_iterations, w, c1, c2, tol)
end
test2()
end

begin
function test2()
    dim = 1
    dim_params = 1

    n = 12
    param_range = [3.581, 3.5825]

    param = MVector(3.235)
    logistic = System{dim, dim_params, Float64}(logistic_rule, logistic_jacobian, MVector(0.7), MVector(3.895))

    C_pp = 1e-5
    C_bif = 1e-5

    objective_func(param) = F_bif(logistic, param, C_pp, n)

    num_particles = 10
    num_iterations = 100
    w = 0.729
    c1 = 1.494
    c2 = c1

    @time best_position, best_score = pso(objective_func, Val(dim), param_range, num_particles, num_iterations, w, c1, c2, C_bif)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end
test2()
end

function henon_rule(out, x, p)
    out[1] = 1.0 - p[1]*x[1]^2 + x[2]
    out[2] = p[2]*x[1]
    return nothing
end

function henon_jacob(out, x, p)
    out[1,1] = -2*p[1]*x[1]
    out[2,1] = p[2]
    out[1,2] = 1.0
    out[2,2] = 0.0
    return nothing
end

begin
function test()
    dim = 2
    dim_params = 2
    n = 4
    param = MVector(1.4, 0.3)
    henon = System{dim, dim_params, Float64}(henon_rule, henon_jacob, MVector(0.1, 0.1), param)

    x_range = [0.0, 1.0]
    num_particles = 10
    num_iterations = 100
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5

    obj_func(x) = F_pp(henon, x, param, n)

    @time best_position, best_score = pso(obj_func, Val(dim), x_range, num_particles, num_iterations, w, c1, c2, tol)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end
test()
end

begin
function test2()
    dim = 2
    dim_params = 2
    n = 7
    param = MVector(1.4, 0.3)
    henon = System{dim, dim_params, Float64}(henon_rule, henon_jacob, MVector(0.1, 0.1), param)

    param_range = [1.44, 1.55]
    num_particles = 30
    num_iterations = 300
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5

    C_pp = 1e-5
    C_bif = 1e-5
    objective_func(param) = F_bif(henon, param, C_pp, n)

    @time best_position, best_score = pso2(objective_func, Val(dim), param_range, num_particles, num_iterations, w, c1, c2, C_bif)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end
test2()
end