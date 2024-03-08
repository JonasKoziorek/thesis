using DDS
using CairoMakie

begin
    LATEX_FONT_SIZE = 30
    FONTSIZE = 20
    RESOLUTION = (950, 500)

    logistic = DDS.logistic
    x0=0.5
    x_range = (0.0, 1.0)
    param = [3.8]
    param_range = LinRange(3.6263, 3.6267, 70)
    param_index = 1
    orbit_limit = 16

    fig = Figure(resolution=RESOLUTION, fontsize=FONTSIZE)
    total_n = 1000
    last_n = 100
    ax = DDS.colorize_bifurcation_diagram!(fig, logistic, x0, param, x_range, param_range, param_index, orbit_limit;total_n=total_n, last_n=last_n)
    ax.xlabel = L"r"
    ax.ylabel = L"T_{%$(total_n-last_n)}^{%$(total_n)}(\mathbb{L}_{r}, %$(x0))"
    ax.ylabelsize = ax.xlabelsize = LATEX_FONT_SIZE
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_coloring_example.png"
    save(file_path, fig)
end