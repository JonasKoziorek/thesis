function calculate_average_laminar_length(map, x0)
    map_shift(x, p) = map(x + x0, p) - x0
    return p -> 1 / sqrt(map_shift(0, [p]))
end

function colorize_strip(func, x0, param, param_index, n_order, left_p, right_p, bif_point, index_x=1)
    nth_func = DDS.nth_composition(func, n_order)
    avg_lam_len = calculate_average_laminar_length(nth_func, bif_point)
    new_params = adaptive_range_interval(left_p, right_p)
    max_iter = Int64(floor(avg_lam_len(right_p)))
    plotting_data = bifurcation_data(func, x0, param, param_index, new_params, max_iter, max_iter-1, index_x)
    colorrange = [avg_lam_len(left_p), avg_lam_len(right_p)]
    colors = [avg_lam_len(param) for (param, _) in plotting_data if left_p <= param <= right_p]
    return (
        data = plotting_data,
        crange = colorrange,
        colors = colors,
    )
end

function colorize_bifurcation_diagram!(figure, map, x0, param, x_range, param_range, param_index, orbit_limit)
    bifurcation_intervals = DDS.localize_bifurcation(
        map, 
        param_index, 
        param_range, 
        orbit_limit, 
        x_range
    )
    boundaries = []
    for (a, b, n_order) in bifurcation_intervals
        partition = 2
        max_iter = 10 * partition
        left_boundary, right_boundary = DDS.intermittency_region(map, (a, b), n_order, x_range; roundtol=5, max_iter=max_iter, partition=partition)
        push!(boundaries, (left_boundary, right_boundary, n_order))
    end

    ax = Axis(figure[1, 1])
    param_range2 = LinRange(param_range[1], param_range[end], 1500)
    color_ranges = []
    for (i, (left_p, right_p, order)) in enumerate(boundaries)
        left_p, right_p, bif_point = DDS.find_boundary(map, x_range, left_p, right_p, order, (50, 150), (900, 1100))
        param_range2 = DDS.cut_param_range(param_range2, left_p, right_p)
        strip_ = DDS.colorize_strip(map, x0, param, param_index, order, left_p, right_p, bif_point)
        scatter!(ax, strip_.data; marker=:circle, color=strip_.colors, colormap=:rainbow, markersize=3, colorrange=strip_.crange)
        append!(color_ranges, strip_.crange)
    end
    plotting_data = DDS.bifurcation_data(map, x0, param, param_index, param_range2, 1000, 100)
    scatter!(ax, plotting_data, marker=:circle, markersize=1.0, color=:black)
    Colorbar(figure[1, 2], colorrange=(minimum(color_ranges), maximum(color_ranges)), colormap=:rainbow, label="average laminar phase length")
    return ax
end

function colorize_bifurcation_diagram_single!(figure, func, x0, params, param_index, param_range, n_order, total_n, sampling_n, left_p, right_p, bif_point, index_x=1; xticks=CairoMakie.Makie.automatic, ax_aspect=1, markersize=1.0, title="", color=:black, param_name="parameter", kwargs...)
    x0 = bif_point
    nth_func = DDS.nth_composition(func, n_order)
    avg_lam_len = calculate_average_laminar_length(nth_func, x0)

    new_params = cut_param_range(param_range, left_p, right_p)
    plotting_data = bifurcation_data(func, x0, params, param_index, new_params, total_n, sampling_n, index_x)
    new_params2 = adaptive_range_interval(left_p, right_p)
    max_iter = Int64(floor(avg_lam_len(right_p)))
    plotting_data2 = bifurcation_data(func, x0, params, param_index, new_params2, max_iter, max_iter-1, index_x)
    ax = Axis(figure[1, 1], title=title, xticks=xticks, kwargs...)
    ax.aspect = ax_aspect

    colorrange = [avg_lam_len(left_p), avg_lam_len(right_p)]
    cmap = :rainbow

    colors = Float64[]
    for (param, _) in plotting_data2
        if left_p <= param <= right_p
            push!(colors, avg_lam_len(param))
        end
    end
    scatter!(ax, plotting_data, marker=:circle, markersize=markersize, color=color)
    scatter!(ax, plotting_data2; marker=:circle, color=colors, colormap=cmap, markersize=markersize+2, colorrange=colorrange)
    Colorbar(figure[1, 2], colorrange=colorrange, colormap=cmap, label="average laminar phase length")
    return ax
end

function find_optimal_low_bound(initial_param, desired_range, func, step=0.1, current_iter=0, max_iter=100)
    bound = initial_param
    l, r = desired_range
    x = -1.0
    current_iter += 1
    for iter in current_iter:max_iter
        bound -= step
        try
            x = func(bound)
        catch e
            if !(e isa DomainError)
                rethrow(e)
            end
        end
        if l <= x <= r
            return bound
        elseif x < l
            return find_optimal_low_bound(bound + step, desired_range, func, step / 10, iter)
        end
    end
    error("Couldn't find left boundary.")
end

function find_optimal_high_bound(initial_param, desired_range, func, step=0.1, current_iter=0, max_iter=100)
    bound = initial_param
    l, r = desired_range
    x = -1.0
    current_iter += 1
    for iter in current_iter:max_iter
        bound -= step
        try
            x = func(bound)
        catch e
            if !(e isa DomainError)
                rethrow(e)
            end
        end
        if l <= x <= r
            return bound
        elseif x < l
            return find_optimal_high_bound(bound + step, desired_range, func, step / 10, iter)
        end
    end
    error("Couldn't find right boundary.")
end

function cut_param_range(param_range, left_p, right_p)
    return filter(x -> x < left_p || x > right_p, collect(param_range))
end

function adaptive_range_interval(left, right, division=10)
    range = LinRange(left, right, division)
    new_range = Float64[]
    for i in 1:length(range)-1
        append!(new_range, collect(LinRange(range[i], range[i+1], division*i)))
    end
    return new_range
end

function find_boundary(map, x_range, left_p, right_p, n_order, low_bound_range=(50, 150), high_bound_range=(900, 1100))
    nth_map = nth_composition(map, n_order)
    sfps = DDS.stable_fixed_points(map, right_p, n_order, x_range)
    for (i, sfp) in enumerate(sfps)
        try
            avg_len = calculate_average_laminar_length(nth_map, sfp)
            low_bound = find_optimal_low_bound(left_p, low_bound_range, avg_len)
            high_bound = find_optimal_high_bound(right_p, high_bound_range, avg_len)
            return low_bound, high_bound, sfp
        catch e
            if !(e isa DomainError)
                rethrow(e)
            end
        end
    end
    error("Couldn't find boundary.")
end