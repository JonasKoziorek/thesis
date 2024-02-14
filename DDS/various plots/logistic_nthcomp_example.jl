using DDS
using CairoMakie

logistic = DDS.logistic

begin
    LATEX_FONT_SIZE = 40
    FONTSIZE = 30
    RESOLUTION = (1200, 450)
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
    p = [3.8]

    funcs = [DDS.nth_composition(DDS.logistic, i) for i in 0:4]

    lin1 = lines!(ax, x, funcs[1].(x, p), color=BLUE, label=L"$n=0$", linewidth=LINEWIDTH)
    lin2 = lines!(ax, x, funcs[2].(x, p), color=RED, label=L"$n=1$", linewidth=LINEWIDTH)
    lin3 = lines!(ax, x, funcs[3].(x, p), color=GREEN, label=L"$n=2$", linewidth=LINEWIDTH)

    ax2 = Axis(fig[1,2])
    lin4 = lines!(ax2, x, funcs[4].(x, p), color=LIGHT_BLUE, label=L"$n=3$", linewidth=LINEWIDTH)
    lin5 = lines!(ax2, x, funcs[5].(x, p), color=PURPLE, label=L"$n=4$", linewidth=LINEWIDTH)

    ax.xlabel = L"$x$"
    ax.ylabel = L"$\mathbb{L}_{%$(p[1])}^{n}(x)$"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE

    ax2.xlabel = L"$x$"
    ax2.ylabel = L"$\mathbb{L}_{%$(p[1])}^{n}(x)$"
    ax2.xlabelsize = LATEX_FONT_SIZE
    ax2.ylabelsize = LATEX_FONT_SIZE

    Legend(fig[1, 3], [lin1, lin2, lin3, lin4, lin5], [L"$n = %$(i)$" for i = 0:4], framevisible = true)

    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_nthcomp_example.png"
    save(file_path, fig)
end