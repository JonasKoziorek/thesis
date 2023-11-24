using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    x0 = 0.5
    param = [3.5823]
    # param = [3.5814]
    param = [3.8]
    order = 10

    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0, 1)
    @time fps = DDS.fixed_points(logistic, param, order, x_range)
    @time sfps = DDS.stable_fixed_points(logistic, param, order, x_range)

    fig = Figure(resolution=(1000,600))

    total_n = 1
    starting_x = 0
    ax_aspect = 2
    identity_line = true

    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=ax_aspect)
    # scatter!(ax, (fps[order]), Float64[nth_logistic(x, param) for x in (fps[order])], color=DDS.BLUE)
    # scatter!(ax, (sfps[order]), Float64[nth_logistic(x, param) for x in (sfps[order])], color=DDS.RED)

    scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE)
    scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED)
    display(fig)
end;