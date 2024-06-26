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

    max_iter = 20
    x_range = (0.0, 1.0)
    total_n = 1000
    last_n = 100
    fig=Figure(resolution=RESOLUTION, fontsize=FONTSIZE)
    ax = DDS.plot_NLS(
        fig[1,1],
        DDS.logistic,
        x0,
        param,
        (a, b),
        n_order,
        x_range;
        max_iter=max_iter,
        total_n=total_n,
        last_n=last_n,
        color1="#FF0000",
        color2="#FF0000",
    )
    ax.xlabel = L"r"
    ax.ylabel = L"\mathcal{T}_{%$(total_n-last_n)}^{%$(total_n)}(\mathcal{L}_{r}, %$(x0))"
    ax.ylabelsize = LATEX_FONT_SIZE
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.aspect=2
    ax.limits = (a, b, nothing, nothing)
    ax.xticks = LinRange(a, b, 6)
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "break_point_search_example.png"
    save(file_path, fig)

    file_path = "/mnt/c/Users/pepaz/Documents/SSZ/Prezentace/images/break_point_search_example.png"
    save(file_path, fig)
end