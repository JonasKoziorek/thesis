using DDS
using CairoMakie

logistic = DDS.logistic

begin
    LATEX_FONT_SIZE = 40
    FONTSIZE = 30
    RESOLUTION = (700, 450)
    YTICKS = LinRange(0.0, 1.0, 5)
    LIMITS = (nothing, nothing, 0.0, 1.0)
    BIF_AX_ASPECT = 0.210
    POINT_SIZE = 15
    LINEWIDTH = 3
    width = 4

    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )
    ax = Axis(fig[1,1])
    x = 0:0.0001:1
    x0=0.5
    starting_x = 50
    total_n = 50
    n_order = 1


    p = [4.0]
    lines!(ax, x, logistic.(x, p), color=BLUE, label=L"$r=%$(p[1])$", linewidth=LINEWIDTH)
    p = [3.0]
    lines!(ax, x, logistic.(x, p), color=RED, label=L"$r=%$(p[1])$", linewidth=LINEWIDTH)
    p = [2.0]
    lines!(ax, x, logistic.(x, p), color=GREEN, label=L"$r=%$(p[1])$", linewidth=LINEWIDTH)
    p = [1.0]
    lines!(ax, x, logistic.(x, p), color=LIGHT_BLUE, label=L"$r=%$(p[1])$", linewidth=LINEWIDTH)
    p = [0.0]
    lines!(ax, x, logistic.(x, p), color=PURPLE, label=L"$r=%$(p[1])$", linewidth=LINEWIDTH)

    ax.xlabel = L"$x$"
    ax.ylabel = L"$\mathbb{L}_{r}(x)$"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE

    fig[1, 2] = Legend(fig, ax, framevisible = true)

    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_graph_example.png"
    save(file_path, fig)
end