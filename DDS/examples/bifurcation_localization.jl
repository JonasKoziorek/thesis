using DDS
using CairoMakie

begin
    x0=0.5
    param = [3.8]
    logistic = DDS.logistic

    param_index = 1
    param_range = LinRange(3.55, 3.66, 600)
    # param_range = LinRange(3.64, 3.65, 100)
    x_range = (0.0, 1.0)
    orbit_limit = 16
    @time bifurcation_intervals = DDS.localize_bifurcation(
        logistic, 
        param_index, 
        param_range, 
        orbit_limit, 
        x_range
    )

    fig = Figure()
    param_range2 = LinRange(param_range[1], param_range[end], 1000)
    param_index = 1
    total_n = 1000
    last_n = 100
    ax = DDS.bifurcation_diagram!(fig[1,1], logistic, x0, param, param_index, param_range2, total_n, last_n;ax_aspect=3)
    # colors = [:red, :blue]
    colors = [:red, :red]
    i = 0
    for (l, r, _) in bifurcation_intervals
        color = colors[i%2+1]
        lines!(ax, [l, l], [x_range...], color=color)
        lines!(ax, [r, r], [x_range...], color=color)
        i+=1
    end
    display(fig)
end