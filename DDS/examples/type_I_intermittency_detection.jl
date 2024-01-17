using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    x0=0.5
    x_range = (0.0, 1.0)
    param = [3.8]
    param_range = LinRange(3.6, 3.68, 300)
    param_index = 1
end

begin
    orbit_limit = 16
    @time bifurcation_intervals = DDS.localize_bifurcation(
        logistic, 
        param_index, 
        param_range, 
        orbit_limit, 
        x_range
    )

    fig = Figure()
    param_range2 = LinRange(param_range[1], param_range[end], 1000)
    total_n = 1000
    last_n = 100
    ax = DDS.bifurcation_diagram!(fig[1,1], logistic, x0, param, param_index, param_range2, total_n, last_n;ax_aspect=1)
    colors = [:red, :red]
    i = 0
    for (l, r, _) in bifurcation_intervals
        color = colors[i%2+1]
        lines!(ax, [l, l], [x_range...], color=color)
        lines!(ax, [r, r], [x_range...], color=color)
        i+=1
    end
    display(fig)
end

begin
    boundaries = []
    for (a, b, n_order) in bifurcation_intervals
        partition = 2
        max_iter = 10*partition
        left_boundary, right_boundary = DDS.intermittency_region(logistic, (a, b), n_order, x_range; roundtol=5, max_iter=max_iter, partition=partition)
        push!(boundaries, (left_boundary, right_boundary, n_order))
    end
    param_range2 = LinRange(param_range[1], param_range[end], 1000)
    total_n = 1000
    last_n = 100
    fig = Figure(resolution=(1200, 600))
    ax = DDS.bifurcation_diagram!(fig[1,1], logistic, x0, param, param_index, param_range2, total_n, last_n;ax_aspect=3)
    for (l, r, _) in boundaries
        lines!(ax, [l, l], [x_range...], color=:blue)
        lines!(ax, [r, r], [x_range...], color=:red)
    end
    display(fig)
end

begin
    index = 4
    param = [boundaries[index][2]]
    order = boundaries[index][3]

    nth_logistic = DDS.nth_composition(logistic, order)
    sfps = DDS.stable_fixed_points(logistic, param, order, x_range)
    bif_point = sfps[1]

    # param_range = LinRange(left_p-0.001, left_p+0.001, 300)
    total_n = 1000
    last_n = 200
    figure = Figure()
    left_p = boundaries[index][1] - 1e-4
    right_p = boundaries[index][1] - 1e-6
    ax = DDS.colorize_bif_diag!(figure[1,1], logistic, x0, param, param_index, param_range, order, total_n, last_n, left_p, right_p, bif_point;param_name="")
    ax.xlabel = ""
    ax.ylabel = ""
    display(figure)
end