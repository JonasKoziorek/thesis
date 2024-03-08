using DDS
using CairoMakie

logistic = DDS.logistic

begin
    LATEX_FONT_SIZE = 40
    FONTSIZE = 30
    RESOLUTION = (800, 700)
    YTICKS = LinRange(0.0, 1.0, 5)
    POINT_SIZE = 10
    LINEWIDTH = 6
    width = 4

    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )
    xstar = 0.5143552770619905
    x_range = LinRange(0, 1, 1000) .- xstar
    x0=0.5
    p = [3.827]
    n_order = 3
    nth_logistic = DDS.nth_composition(logistic, n_order)
    shift(x, p) = nth_logistic(x+xstar, p)-xstar

    ax = DDS.plot_nth_composition!(fig[1,1], shift, x_range, p, 1, true)

    c = 0.03
    preinjections, reinjections = DDS.injections(nth_logistic, xstar, p, 1000, 0, 1, c)
    preinjections .-= xstar
    reinjections .-= xstar
    scatter!(ax, preinjections, Float64[shift(x, p) for x in preinjections], color=RED, markersize=POINT_SIZE)
    scatter!(ax, reinjections, Float64[shift(x, p) for x in reinjections], color=BLUE, markersize=POINT_SIZE)

    min = x_range[1]
    lines!(ax, [-c, c], [min, min], color=ORANGE, linewidth=LINEWIDTH)
    scatter!(ax, [(0, min)], color=GREEN, markersize=POINT_SIZE+8)

    ax.xlabel = L"$x$"
    ax.ylabel = L"$\mathcal{L}_{%$(p[1])}^{%$(n_order)}(x)$"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    ax.xticks = ax.yticks = round.(LinRange(0, 1, 6) .- xstar, digits=2)

    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "pre_reinjection_points_example{1}.png"
    save(file_path, fig)



    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )
    step = 1e-2
    x_range = LinRange(-c-step, c+step, 1000)
    ax = DDS.plot_nth_composition!(fig[1,1], shift, x_range, p, 1, true)

    filter!(preinjections -> x_range[end] > preinjections > x_range[1], preinjections)
    filter!(reinjections -> x_range[end] > reinjections > x_range[1], reinjections)
    scatter!(ax, preinjections, Float64[shift(x, p) for x in preinjections], color=RED, markersize=POINT_SIZE)
    scatter!(ax, reinjections, Float64[shift(x, p) for x in reinjections], color=BLUE, markersize=POINT_SIZE)

    min = x_range[1]
    lines!(ax, [-c, c], [min, min], color=ORANGE, linewidth=LINEWIDTH)
    scatter!(ax, [(0, min)], color=GREEN, markersize=POINT_SIZE+8)

    ax.xlabel = L"$x$"
    ax.ylabel = L"$\mathcal{L}_{%$(p[1])}^{%$(n_order)}(x)$"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    ax.limits = (-c-step, c+step, nothing, nothing)
    ax.xticks = round.(LinRange(-c-step, c+step, 5), digits=2)

    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "pre_reinjection_points_example{2}.png"
    save(file_path, fig)
end