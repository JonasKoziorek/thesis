using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    x0=0.5
    x_range = (0.0, 1.0)
    param = [3.8]
    param_range = LinRange(3.6, 3.9, 300)
    param_index = 1
end

begin
    orbit_limit = 12
    @time bifurcation_intervals = DDS.localize_bifurcation(
        logistic, 
        x0,
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
        max_iter = 20
        left_boundary, right_boundary = DDS.NLS(logistic, (a, b), n_order, x_range; max_iter=max_iter)
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
    @time fig = Figure()
    @time ax = Axis(fig[1,1])
    param_range2 = param_range
    color_ranges = []
    for i in eachindex(boundaries)
        left_p, right_p, order = boundaries[i]
        left_p, right_p, bif_point = DDS.specify_intermittency_bounds(logistic, x_range, left_p, right_p, order, (50, 150), (900, 1100))
        param_range2 = DDS.cut_param_range(param_range2, left_p, right_p)
        strip_ = DDS.colorize_strip(logistic, x0, param, param_index, order, left_p, right_p, bif_point)
        scatter!(ax, strip_.data; marker=:circle, color=strip_.colors, colormap = :rainbow, markersize=3, colorrange = strip_.color_range)
        append!(color_ranges, strip_.color_range)
    end
    plotting_data = DDS.bifurcation_data(logistic, x0, param, param_index, param_range2, 1000, 100)
    scatter!(ax, plotting_data, marker = :circle, markersize = 1.0, color = :black)
    Colorbar(fig[1,2], colorrange = (minimum(color_ranges), maximum(color_ranges)), colormap = :rainbow, label="average laminar phase length")
    display(fig)
end