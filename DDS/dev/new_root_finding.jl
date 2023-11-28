using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    param = [3.9]
    order = 12
    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0, 1)

    @time fps = DDS.fixed_points(logistic, param, order, x_range)
    @time fps2 = DDS.newton_fps(logistic, param, order, x_range)

    fig = Figure(resolution=(1000,600))

    total_n = 1
    starting_x = 0
    ax_aspect = 2
    identity_line = true

    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE)
    # scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED)

    ax = DDS.plot_nth_composition!(fig[1,2], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    scatter!(ax, fps2, Float64[nth_logistic(x, param) for x in fps2], color=DDS.RED)
    display(fig)
end;