using DDS
using CairoMakie

logistic = DDS.logistic

begin
    x0 = 0.5
    p = [3.85]
    p_range = LinRange(3.54, 3.55, 1000)
    DDS.bifurcation_diagram(logistic, x0, p, 1, p_range, 1000, 50;ax_aspect=2)
end

begin
    x0 = 0.5
    param = [3.545]
    order = 8

    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0, 1)
    fps = DDS.fixed_points(logistic, param, order, x_range)
    sfps = DDS.stable_fixed_points(logistic, param, order, x_range)

    fig = Figure(resolution=(1000,600))

    total_n = 1
    starting_x = 0
    ax_aspect = 2
    identity_line = true

    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(0.875,0.89, 2000), param, order, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    fps = filter!(x->x>0.875, fps)
    sfps = filter!(x->x>0.875, sfps)
    scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE)
    scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED)
    display(fig)
end;

begin
    x0 = fps[2]
    N = 100
    DDS.trajectory(DDS.logistic, x0, param, N, 1;ax_aspect=2)
end