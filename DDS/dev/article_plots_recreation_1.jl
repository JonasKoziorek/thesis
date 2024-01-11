# reconstructing plots from article Intermittency Reinjection in the Logistic Map from Elaskar and Del Rio

using DDS
using CairoMakie: scatter!, Figure, display, scatter
using Plots: scatterhist, plot!

begin
    x01 = 0.15992881844625645
    param = [1+sqrt(8)-0.0000001]
    # x02 = 0.5143552770619905
    # param = [3.8275]
    # x03 = 0.9563178419736238
    # param = [3.8284]
    x0 = x01
    c = 0.04
    Ns = 1000
    N = 10000

    logistic = DDS.logistic
    order = 3

    map = DDS.nth_composition(logistic, order)
    nth_logistic = (x, p) -> map(x+x0, p) - x0
    x_range = (-x0, 1-x0)
    # @time fps = DDS.fixed_points(logistic, param, order, x_range)
    # sfps = DDS.stable_fixed_points(logistic, param, order, x_range)

    inter_range = LinRange(3.8275, 1+sqrt(8)-1e-10, 1000)
    Ls = [nth_logistic(0, [p])^(-0.5) for p in inter_range]

    preinjections = Float64[]
    for x in LinRange(0, 1, 10000)
        xn = nth_logistic(x, param)
        if abs(x0-xn) <= c && abs(x0-x) > c
            push!(preinjections, x)
        end
    end

    fig = Figure(resolution=(1000,600))

    total_n = 1
    starting_x = 0
    ax_aspect = 2
    identity_line = true

    ax = DDS.plot_nth_composition!(fig[1,1], nth_logistic, LinRange(x_range..., 2000), param, 1, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    # scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE)
    # scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED)
    # scatter!(ax, preinjections, Float64[nth_logistic(x, param) for x in preinjections], color=:red, markersize=7)
    display(fig)
    eps_ = nth_logistic(0, param)
    L = eps_^(-0.5)
    println("eps: $(round(eps_, digits=9))\nL: $(L)")
end;


begin
    total_n = 10000
    display(DDS.trajectory(logistic, x0, param, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(1500,500), 
        xtick_period=3000, 
        linewidth=0.05, 
        title="Logistic map for r=$(param[1]), x0=$(x0)"
    ))
end

# # seems to be in infinite loop
# begin
#     data = Float64[]
#     for _ in 1:N
#         x = 1-rand()
#         while true
#             x = nth_logistic(x, param)
#             if abs(x0-x) <= c
#                 push!(data, x-x0)
#                 break
#             end
#         end
#     end
#     alpha = -0.483550
#     xh = -0.0024028
#     b = 1.2
#     f(x) = b*(x-xh)^alpha
#     x = range(-0.0024, c, Ns)
#     scatterhist(data, bins=x, markersize=1)
#     plot!(x, f.(x), color=:red)
# end

begin
    F(x, r) = -x0 + r[1]^3 * (1-(x-x0))*(x+x0)*(1+r[1]*(-1+(x+x0))*(x+x0))*(1+r[1]^2*(-1+(x+x0))*(x+x0)*(1+r[1]*(-1+(x+x0))*(x+x0)))
    x0 = x01

    x_range = (x0, 1+x0)

    fig = Figure(resolution=(1000,600))

    ax_aspect = 2
    identity_line = true

    ax = DDS.plot_nth_composition!(fig[1,1], F, LinRange(x_range..., 2000), param, 1, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    display(fig)
end