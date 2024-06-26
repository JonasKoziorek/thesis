using DDS
using CairoMakie

begin
    LATEX_FONT_SIZE = 30
    FONTSIZE = 25
    RESOLUTION = (950, 500)

    x0=0.5
    param = [3.8]
    logistic = DDS.logistic

    param_index = 1
    # param_range = LinRange(3.55, 3.66, 700)
    param_range = LinRange(3.58, 3.66, 4000)
    x_range = (0.0, 1.0)
    orbit_limit = 16
    bifurcation_intervals = DDS.localize_bifurcation(
        logistic, 
        x0,
        param_index, 
        param_range, 
        orbit_limit, 
        x_range
    )

    fig=Figure(resolution=RESOLUTION, fontsize=FONTSIZE)
    param_range2 = LinRange(param_range[1], param_range[end], 2000)
    param_index = 1
    total_n = 1000
    last_n = 100

    ax = DDS.bifurcation_diagram!(fig[1,1], logistic, x0, param, param_index, param_range2, total_n, last_n;ax_aspect=2)
    ax.xlabel = L"r"
    ax.ylabel = L"\mathcal{T}_{%$(total_n-last_n)}^{%$(total_n)}(\mathcal{L}_{r}, %$(x0))"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    ax.limits = (param_range[1], param_range[end], nothing, nothing)
    ax.xticks = LinRange(param_range[1], param_range[end], 6)

    # colors = [DDS.RED, DDS.BLUE]
    colors = [DDS.RED, DDS.RED]
    i = 0
    height_ = [0.25, 1.0]
    for (l, r, _) in bifurcation_intervals
        color = colors[i%2+1]
        lines!(ax, [l, l], [height_...], color="#FF0000", linewidth=3)
        lines!(ax, [r, r], [height_...], color="#FF0000", linewidth=3)
        i+=1
    end
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "bif_diag_search_example.png"
    save(file_path, fig)

    file_path = "/mnt/c/Users/pepaz/Documents/SSZ/Prezentace/images/bif_search.png"
    save(file_path, fig)
end