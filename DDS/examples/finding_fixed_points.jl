using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    x0 = 0.5
    param = [3.8]
    order = 5

    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0, 1)
    seeds = DDS.create_seeds(logistic, param, 3, x_range)

    disttol = 1e-8
    bintol = 1e-5

    fig = Figure(resolution=(1000,600))
    @time fps = DDS.DL(logistic, param, order, seeds;disttol=disttol, bintol=bintol)

    total_n = 1
    starting_x = 0
    ax_aspect = 2
    identity_line = true
    # ax = DDS.plot_cobweb!(fig[1,1], logistic, x0, LinRange(x_range..., 2000), param, total_n, order, starting_x;ax_aspect = ax_aspect)

    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=ax_aspect)
    scatter!(ax, DDS.to_array(fps[order]), [nth_logistic(x, param) for x in DDS.to_array(fps[order])])
    display(fig)
end;