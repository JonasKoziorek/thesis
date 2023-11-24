using DDS
using CairoMakie

begin
    x0=0.5
    param = [3.8]
    logistic = DDS.logistic

    param_index = 1
    param_range = LinRange(3.43, 3.66, 170)
    x_range = (0.0, 1.0)
    orbit_limit = 18
    bifurcation_intervals = DDS.localize_bifurcation(
        logistic, 
        param_index, 
        param_range, 
        orbit_limit, 
        x_range
    )

    fig = Figure()
    param_range2 = LinRange(param_range[1], param_range[end], 2000)
    param_index = 1
    total_n = 1000
    last_n = 100

    ax = DDS.bifurcation_diagram!(fig[1,1], logistic, x0, param, param_index, param_range2, total_n, last_n;ax_aspect=2)
    ax.ylabel = ""
    ax.xlabel = ""
    colors = [:red, :blue]
    i = 0
    height = [0.25, 1.0]
    for (l, r) in bifurcation_intervals
        color = colors[i%2+1]
        lines!(ax, [l, l], [height...], color=color)
        lines!(ax, [r, r], [height...], color=color)
        i+=1
    end
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "bif_diag_search_example.png"
    save(file_path, fig)
end