using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    param = [3.8]
end

begin 
    p_range = LinRange(3.82828, 3.82848, 70)
    figure = Figure()
    n_order = 3
    @time ax = DDS.colorize_bifurcation_diagram!(figure[1,1], logistic, 0.5, param, (0.0, 1.0), p_range, 1, n_order)
    display(figure)
end

begin
    logistic = DDS.logistic
    x0=0.2
    x_range = (0.0, 1.0)
    param = [3.8]
    param_range = LinRange(3.6263, 3.6267, 70)
    param_index = 1

    orbit_limit = 16
    fig = Figure()
    @time ax = DDS.colorize_bifurcation_diagram!(fig, logistic, x0, param, x_range, param_range, param_index, orbit_limit)
    display(fig)
end

begin
    x0=0.2
    x_range = (0.0, 1.0)
    param = [3.8]
    # param_range = LinRange(3.6, 3.8, 6002)
    param_range = LinRange(3.62, 3.65, 6000)
    param_index = 1

    orbit_limit = 20
    fig = Figure()
    @time ax = DDS.colorize_bifurcation_diagram!(fig, DDS.logistic, x0, param, x_range, param_range, param_index, orbit_limit)
    display(fig)
end

# random map as other example
begin
    func(x, p) = p[1]*x*(1-x^4)
    x0=0.2
    x_range = (0.0, 1.0)
    param = [1.8]
    param_range = LinRange(1.5, 2.0, 1000)
    param_index = 1

    orbit_limit = 10
    fig = Figure()
    @time ax = DDS.colorize_bifurcation_diagram!(fig, func, x0, param, x_range, param_range, param_index, orbit_limit)
    display(fig)
end