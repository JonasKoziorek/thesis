using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    param = [3.8]
end

begin
    total_n = 1000
    last_n = 200
    p_range = LinRange(3.82835, 3.8285, 2000)
    figure = Figure()
    left_p = 1+sqrt(8)-2.5*1e-5
    right_p = 1+sqrt(8)-1e-6
    bif_point = 0.15992881844625645
    n_order = 3
    ax = DDS.colorize_bifurcation_diagram_single!(figure[1,1], logistic, 0.5, param, 1, p_range, n_order, total_n, last_n, left_p, right_p, bif_point;param_name="")
    display(figure)
end

begin
    logistic = DDS.logistic
    x0=0.2
    x_range = (0.0, 1.0)
    param = [3.8]
    param_range = LinRange(3.60, 3.65, 300)
    param_index = 1

    orbit_limit = 12
    fig = Figure()
    ax = DDS.colorize_bifurcation_diagram!(fig, logistic, x0, param, x_range, param_range, param_index, orbit_limit)
    display(fig)
end