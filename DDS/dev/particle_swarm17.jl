using LinearAlgebra

struct Particle
    velocity::Array{Float64, 2}
    position::Array{Float64, 2}
    pbest::Array{Float64, 2}
    gbest::Array{Float64, 2}
end

function rosenbrock(x)
    x^2 - 10 * cos(2π * x)
end


function pso(f, x0, pso_params)
    N = length(x0)
    swarm = Array{Particle, N}(undef)

    for i = 1:N
        swarm[i].position = x0[i]
        swarm[i].velocity = rand(2) - 0.5
        swarm[i].pbest = swarm[i].position

        if f(swarm[i].position) < f(swarm[i].gbest)
            swarm[i].gbest = swarm[i].position
        end
    end

    gbest = swarm[1].gbest
    for iter = 1:pso_params["max_iter"]
        for i = 1:N
            # Update velocity
            swarm[i].velocity = pso_params["w"] * swarm[i].velocity + pso_params["c1"] * rand(2) * (swarm[i].pbest - swarm[i].position) + pso_params["c2"] * rand(2) * (gbest - swarm[i].position)

            # Update position
            swarm[i].position += swarm[i].velocity

            # Update personal best
            if f(swarm[i].position) < f(swarm[i].pbest)
                swarm[i].pbest = swarm[i].position
            end
        end

        # Update global best
        for i = 1:N
            if f(swarm[i].pbest) < f(gbest)
                gbest = swarm[i].pbest
            end
        end
    end

    return gbest
end

begin
    pso_params = Dict("max_iter" => 1000, "w" => 0.7298, "c1" => 1.4962, "c2" => 1.4962)
    x0 = [-2.048, -1.568] # Initial guess
    gbest = pso(rosenbrock, x0, pso_params)
    println("Global best:", gbest)
end