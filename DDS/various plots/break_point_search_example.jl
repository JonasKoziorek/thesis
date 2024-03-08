using DDS
using CairoMakie

begin
    LATEX_FONT_SIZE = 30
    FONTSIZE = 25
    RESOLUTION = (950, 500)

    a, b = 3.825, 3.83
    n_order = 3
    x0 = 0.5
    param = [3.8]

    partition = 2
    max_iter = 10*partition
    x_range = (0.0, 1.0)
    total_n = 1000
    last_n = 100
    fig=Figure(resolution=RESOLUTION, fontsize=FONTSIZE)
    ax = DDS.plot_intermittency_region(
        fig[1,1],
        DDS.logistic,
        x0,
        param,
        (a, b),
        n_order,
        x_range;
        max_iter=max_iter,
        partition=partition,
        total_n=total_n,
        last_n=last_n
    )
    ax.xlabel = L"r"
    ax.ylabel = L"T_{%$(total_n-last_n)}^{%$(total_n)}(\mathbb{L}_{r}, %$(x0))"
    ax.ylabelsize = LATEX_FONT_SIZE
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.aspect=2
    ax.limits = (a, b, nothing, nothing)
    ax.xticks = LinRange(a, b, 6)
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "break_point_search_example.png"
    save(file_path, fig)
end