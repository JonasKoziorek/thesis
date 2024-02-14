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

begin
function test()
    dim = 1
    dim_params = 1
    logistic = System{dim, dim_params, Float64}(logistic_rule, logistic_jacobian, MVector(0.8), MVector(3.895))
    step!(logistic, 100)
    state!(logistic, MVector(0.5))
    params!(logistic, MVector(3.895))
    m = 12
    jacobian!(logistic, m)
end
test()
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

struct PSOData
    positions
    velocities
    best_positions
    best_scores
    global_best_position
    global_best_score
    w::Float64
    c1::Float64
    c2::Float64
    lower_bound::Float64
    upper_bound::Float64

    # positions::MMatrix{N, M, T}
    # velocities::MMatrix{N, M, T}
    # best_positions::MMatrix{N, M, T}
    # best_scores::MVector{M, T}
    # global_best_position::MVector{N, T}
    # global_best_score::MVector{1, T}
    # w::T
    # c1::T
    # c2::T
    # lower_bound::T
    # upper_bound::T

    # PSOData{N, M, T}(
    #     w::T, 
    #     c1::T, 
    #     c2::T, 
    #     lower_bound::T, 
    #     upper_bound::T,
    #     n,
    #     m
    # ) where {N, M, T} = new(
    #         @MMatrix rand(Uniform(lower_bound, upper_bound), N, M), 
    #         @MMatrix zeros(N, M),
    #         @MMatrix rand(Uniform(lower_bound, upper_bound), N, M), 
    #         Vector{T}(undef, N),
    #         @MVector rand(Uniform(lower_bound, upper_bound), M),
    #         MVector(Inf),
    #         w, 
    #         c1, 
    #         c2, 
    #         lower_bound, 
    #         upper_bound
    #     )
end

function fill_PSOData(lower_bound, upper_bound, ::Val{N}, ::Val{M}) where {N, M}
    pos = @MMatrix rand(Uniform(lower_bound, upper_bound), N, M)
    vel = @MMatrix zeros(N, M)
    bpos = @MMatrix rand(Uniform(lower_bound, upper_bound), N, M)
    bscore = Vector{Float64}(undef, N)
    gpos = @MVector rand(Uniform(lower_bound, upper_bound), M)
    gscore = Inf
    return pos, vel, bpos, bscore, gpos, gscore
end

function fill_PSOData(w::T, c1::T, c2::T, lower_bound::T, upper_bound::T, ::Val{N}, ::Val{M}) where {T, N, M}
    positions = @MMatrix rand(Uniform(lower_bound, upper_bound), N, M)
    velocities = @MMatrix zeros(N, M)
    best_positions = @MMatrix rand(Uniform(lower_bound, upper_bound), N, M)
    best_scores = Vector{T}(undef, N)
    best_global_position = @MVector rand(Uniform(lower_bound, upper_bound), M)
    best_global_score = MVector(Inf)
    PSOData( positions,
        velocities,
        best_positions,
        best_scores,
        best_global_position,
        best_global_score,
        w, 
        c1, 
        c2, 
        lower_bound, 
        upper_bound
    )
end
N = 50
M = 5
fill_PSOData(0.729, 1.494, 1.494, 0.0, 1.0, Val(N), Val(M));

function pso(f::F, n::Int64, bounds::Vector{Float64}, num_particles::Int64, num_iterations::Int64, w::Float64, c1::Float64, c2::Float64, tol::Float64) where {F<:Function}
    a, b = bounds
    n = 1
    num_particles = 10
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

function F_pp(s::System, x, param, n)
    state!(s, x)
    params!(s, param)
    step!(s, n)
    return norm(s.state.-x)
end

function F_bif(s::System, param, C_pp, n, μ=1)
    objective_function(x) = F_pp(s, x, param, n)
    x_range = [0.0, 1.0]
    num_particles = 10
    num_iterations = 100
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5
    x0, _ = pso(objective_function, n, x_range, num_particles, num_iterations, w, c1, c2, tol)
    cost :: Float64 = Inf
    if objective_function(x0) <= C_pp
        state!(s, x0)
        jacobian!(s, n)
        cost = abs(det(s.J-μ*I)) 
    end
    return cost
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

    @time best_position, best_score = pso(obj_func, dim, x_range, num_particles, num_iterations, w, c1, c2, tol)
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

    @time best_position, best_score = pso(objective_func, dim, param_range, num_particles, num_iterations, w, c1, c2, C_bif)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end
test2()
end

struct PSOParams
    dim::Int64
    num_particles::Int64
    num_iterations::Int64
    w::Float64
    c1::Float64
    c2::Float64
    tol::Float64
end

function nlpso(f::F, range, inner_range, params, inner_params) where {F<:Function}
    l, r = range
    data = fill_PSOData(l, r, Val(params.num_particles), Val(params.dim))
    return nlpso_outer(f, inner_range, data, params, inner_params)
end

function fill_PSOData(lower_bound, upper_bound, ::Val{N}, ::Val{M}) where {N, M}
    pos = @MMatrix rand(Uniform(lower_bound, upper_bound), N, M)
    vel = @MMatrix zeros(N, M)
    bpos = @MMatrix rand(Uniform(lower_bound, upper_bound), N, M)
    bscore = Vector{Float64}(undef, N)
    gpos = @MVector rand(Uniform(lower_bound, upper_bound), M)
    gscore = Inf
    return pos, vel, bpos, bscore, gpos, gscore
end

function nlpso_inner(f::F, data, params::PSOParams) where {F<:Function}
    pos, vel, bpos, bscore, gpos, gscore = data
    for _ = 1:params.num_iterations
        for i in 1:params.num_particles
            gscore = evolve_particle!(f, i, pos, bpos, bscore, gscore, gpos)
        end
        if gscore < params.tol
            break
        end
        update_state!(vel, pos, params.w, params.c1, params.c2, bpos, gpos)
    end
    return gpos, gscore
end

function nlpso_outer(f::F, inner_range, data, params::PSOParams, inner_params) where {F<:Function}
    pos, vel, bpos, bscore, gpos, gscore = data
    l, r = inner_range
    inner_data = fill_PSOData(l, r, Val(params.num_particles), Val(params.dim))
    for _ = 1:params.num_iterations
        for i in 1:params.num_particles
            gscore = evolve_particle_inner!(f, i, pos, bpos, bscore, gscore, gpos, inner_data, inner_params)
        end
        if gscore < params.tol
            break
        end
        update_state!(vel, pos, params.w, params.c1, params.c2, bpos, gpos)
    end
    return gpos, gscore
end

function evolve_particle_inner!(f::F, i, positions, best_positions, best_scores, global_best_score, global_best_position, data, inner_params) where {F<:Function}
    slice = @view positions[i, :]
    score= f(slice, data, inner_params)
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

function F_bif_inner(s::System, param, n, data, inner_params, μ=1)
    objective_function(x) = F_pp(s, x, param, n)
    x0, _ = nlpso_inner(objective_function, data, inner_params)
    cost :: Float64 = Inf
    if objective_function(x0) <= inner_params.tol
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
    num_particles = 10
    num_iterations = 100
    w = 0.729
    c1 = 1.494
    c2 = c1
    C_pp = 1e-5
    C_bif = 1e-5

    n = 12
    param_range = [3.581, 3.5825]
    x_range = [0.0, 1.0]

    param = MVector(3.235)
    logistic = System{1, 1, Float64}(logistic_rule, logistic_jacobian, MVector(0.7), MVector(3.895))

    outer_params = PSOParams(logistic.dim, num_particles, num_iterations, w, c1, c2, C_bif)
    inner_params = PSOParams(logistic.dim, num_particles, num_iterations, w, c1, c2, C_pp)

    objective_func(param, data, inner_params) = F_bif_inner(logistic, param, n, data, inner_params)

    @time best_position, best_score = nlpso(objective_func, param_range, x_range, outer_params, inner_params)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end
test2()
end