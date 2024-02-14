using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    x0=0.2
    x_range = (0.0, 1.0)
    param = [3.8]
    param_range = LinRange(3.6263, 3.6267, 70)
    param_index = 1
    orbit_limit = 16

    fig = Figure()
    ax = DDS.colorize_bifurcation_diagram!(fig, logistic, x0, param, x_range, param_range, param_index, orbit_limit)
    ax.xlabel = L"p"
    ax.ylabel = L"\mathbb{L}_{r}"
    ax.ylabelsize = 22
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_coloring_example.png"
    save(file_path, fig)
end