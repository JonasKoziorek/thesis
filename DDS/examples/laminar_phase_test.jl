using DDS
using CairoMakie: scatter!, Figure, display
using Plots: scatterhist, plot!

begin
    x01 = 0.15992881844625645
    param = [3.828]
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

    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0, 1)
    # @time fps = DDS.fixed_points(logistic, param, order, x_range)
    sfps = DDS.stable_fixed_points(logistic, param, order, x_range)

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

    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    # scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE)
    scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED)
    scatter!(ax, preinjections, Float64[nth_logistic(x, param) for x in preinjections], color=:red, markersize=7)
    display(fig)
end;

begin
    data = Float64[]
    for _ in 1:N
        x = 1-rand()
        while true
            x = nth_logistic(x, param)
            if abs(x0-x) <= c
                push!(data, x-x0)
                break
            end
        end
    end
    alpha = -0.483550
    xh = -0.0024028
    b = 1.2
    f(x) = b*(x-xh)^alpha
    x = range(-0.0024, c, Ns)
    scatterhist(data, bins=x, markersize=1)
    plot!(x, f.(x), color=:red)
end