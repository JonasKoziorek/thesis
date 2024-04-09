using Distributions
using LinearAlgebra
using CairoMakie
using CairoMakie.Makie.GeometryBasics
using ForwardDiff

begin
    μ = [0, 0]
    Σ = [3 0 ; 0 6]
    N = MvNormal(μ, Σ)
    y = rand(N, 5000)


    fig = Figure(size=(600, 600))
    ax = Axis(fig[1,1])
    scatter!(ax, y[1, :], y[2, :], markersize = 3, color = (:blue, 0.4))

    ax.limits = (-10, 10, -10, 10)

    x = LinRange(a, b, 500)
    y = LinRange(c, d, 500)
    Z = [pdf(N, [x, y]) for x in x, y in y]
    contour!(ax, x, y, Z, linewidth = 2.0, levels=0:0.004:1, colormap = :darkrainbow)

    evals = eigvals(Σ)
    evecs = eigvecs(Σ)

    for (i, eval) in enumerate(evals)
        h = hcat(μ, μ + eval * evecs[:, i])
        lines!(ax, h, linewidth = 4, color=:red)
    end

    display(fig)
end

function kalmanstep2(μ0,Σ0, A, B, H, Q, R, y)
    μ1 = A*μ0
    Σ1 = A*Σ0*A' + Q
    K = Σ1*H'*inv(H*Σ1*H' + R)
    μ = μ1 + K*(y - H*μ1)
    Σ = (I - K*H)*Σ1
    return μ, Σ
end

function f(x, c)
    x, y, vx, vy = x
    return [
        vx,
        vy,
        c/sqrt((x^2 + y^2))^3 * x,
        c/sqrt((x^2 + y^2))^3 * y,
    ]
end

function g(x)
    x, y, vx, vy = x
    return [x, y]
end

function J(f, x)
    return ForwardDiff.jacobian(f, x)
end

function kalmanstep(μ0, Σ0, f, g, Q, R, y, c)
    F = J(x->f(x, c), μ0)
    μ1 = f(μ0, c)
    Σ1 = F*Σ0*F' + Q
    G = J(g, μ1)
    K = Σ1*G'*inv(G*Σ1*G' + R)
    μ = μ1 + K*(y - g(μ1))
    Σ = (I - K*G)*Σ1
    return μ, Σ
end

function kalman(μ0, Σ0, f, g, Q, R, ys, c)
    μ = μ0
    Σ = Σ0
    μs = typeof(μ)[]
    Σs = typeof(Σ)[]
    for y in ys
        μ, Σ = kalmanstep(μ, Σ, f, g, Q, R, y, c)
        push!(μs, μ)
        push!(Σs, Σ)
    end
    return μs, Σs
end

begin
    G = 10 # gravitational constant
    M = 100 # mass of the body
    μ = G*M # gravitational parameter
    Δt = 0.0005 # time step
    # f(r) = -μ/(r^3)

    radius = 5
    iter = 3
    x = [-11, 0, 0.0, -sqrt(μ/11)]
    # x = [-11, 0, 0.0, -sqrt(μ/11)+3]
    # x = [-11, 0, 0.0, -sqrt(μ/11)-3.7]
    A(c) =  [
        1 0 Δt  0 ;
        0 1  0 Δt ;
        Δt*c 0  1  0 ;
        0 Δt*c  0  1 ;
    ]

    B(c) = [
         0 0 0 0;
         0 0 0 0;
         Δt*c 0 0 0;
         0 Δt*c 0 0;
    ]

    H = [
        1 0 0 0;
        0 1 0 0;
    ]

    y = H*x
    ys = Vector{Float64}[y]
    for i in 1:iter
        # c = f(norm(x[1:2]))
        # x = A(c)*x
        x += Δt*f(x,-μ)
        y = H*x
        if norm(y) < radius
            println("Crash: $i")
            break
        end
        push!(ys, y)
    end

    fig = Figure(size = (600, 600))
    ax = Axis(fig[1,1])
    data = Tuple{Float64, Float64}[(z[1], z[2]) for z in ys]
    lines!(ax, data, linewidth = 2, color = :blue)
    poly!(ax, Circle(Point2f(0, 0), radius), color = :orange)

    display(fig)
end

begin
    Q = zeros(4, 4)
    R = collect(Diagonal([0.001, 0.001]))
    μ0 = [-11.0, 0.0, 0.0, -sqrt(μ/11.0)]
    Σ = collect(Diagonal([0.0, 0.0, 0.0, 0.0]))
    μs, Σs = kalman(μ0, Σ, f, g, Q, R, ys, -μ)

    data = Tuple{Float64, Float64}[(z[1], z[2]) for z in μs]
    lines!(ax, data, linewidth = 2, color = :red)
    display(fig)
end