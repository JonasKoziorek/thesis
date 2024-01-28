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
    x0, _ = inner_NLPSO(n, z_b, x_range, num_particles, num_iterations, w, c1, c2, C_pp)
    func = DDS.nth_composition(DDS.logistic, n)

    cost :: Float64 = Inf
    if F_pp(n, x0, z_b) <= C_pp
        cost = abs(ForwardDiff.derivative(x->func(x, z_b), x0)-μ)
    end
    return cost
end


function inner_NLPSO(n::Int, param, bounds, num_particles::Int, num_iterations::Int, w::Float64, c1::Float64, c2::Float64, tol::Float64)
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

function NLPSO(n::Int, bounds, num_particles::Int, num_iterations::Int, w::Float64, c1::Float64, c2::Float64, tol::Float64)
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