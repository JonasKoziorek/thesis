using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    x0 = 0.5
    param = [3.70]
    order = 6

    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0, 1)
    fps = DDS.fixed_points(logistic, param, order, x_range; method=:DL)

    fig = Figure(resolution=(1000,500))

    ax_aspect = 2
    identity_line = true

    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    ax.ylabel = L"\mathbb{L}_{%$(param[1])}^{%$order}"
    scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE)
    display(fig)


    file_path = DDS.FIGURES_DIRECTORY * "upo_search_example.png"
    save(file_path, fig)
end;