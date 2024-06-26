using DDS
using CairoMakie


begin
    logistic = DDS.logistic
    LATEX_FONT_SIZE = 30
    FONTSIZE = 20

    fig = Figure(
        resolution = (900, 500),
        fontsize=FONTSIZE,
    )

    total_n = 5000
    last_n = 500
    p = [4.5]
    x0 = 0.5
    p_range = LinRange(2.81, 3.87, 1000)
    ax = DDS.bifurcation_diagram!(
        fig[1,1], logistic, x0, p, 1, p_range, total_n, last_n;
        # title="Bifurcation diagram of logistic map\n$total_n total iterations, plotting last $last_n interations, x0=$x0",
        ax_aspect=2,
        xticks = LinRange(2.81, 3.87, 6),
        color="#FF0000"
    )
    ax.xlabel = L"r"
    ax.ylabel = L"\mathcal{T}_{%$(total_n-last_n)}^{%$(total_n)}(\mathcal{L}_{r}, %$(x0))"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE

    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_bif_diag_example.png"
    save(file_path, fig)

    file_path = "/mnt/c/Users/pepaz/Documents/SSZ/Prezentace/images/bifurcationdiagram.png"
    save(file_path, fig)
end