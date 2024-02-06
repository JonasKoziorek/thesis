function average_laminar_length(map, x0, p)
    return 1.0 / sqrt(map(x0, p) - x0)
end

function colorize_strip(func::F, x0, param, param_index, n_order, left_p, right_p, bif_point, index_x=1) where {F<:Function}
    nth_func = nth_composition(func, n_order)
    new_params = adaptive_range_interval(left_p, right_p)
    max_iter = Int64(floor(average_laminar_length(nth_func, bif_point, right_p)))
    plotting_data = bifurcation_data(func, x0, param, param_index, new_params, 2*max_iter, max_iter, index_x)
    colorrange = (average_laminar_length(nth_func, bif_point, left_p), average_laminar_length(nth_func, bif_point, (right_p)))
    colors = find_colors(plotting_data, nth_func, bif_point)
    return (
        data = plotting_data,
        color_range = colorrange,
        colors = colors,
    )
end

function find_colors(plotting_data::Vector{Tuple{Float64, Float64}}, nth_func::F, bif_point) where {F<:Function}
    colors = Vector{Float64}(undef, length(plotting_data))
    for j in eachindex(plotting_data)
        param = plotting_data[j][1]
        colors[j] = average_laminar_length(nth_func, bif_point, param)
    end
    return colors
end

function colorize_bifurcation_diagram!(figure, map::F, x0, param, x_range, param_range, param_index, orbit_limit) where {F<:Function}
    bifurcation_intervals = localize_bifurcation(
        map, x0, param_index, param_range, orbit_limit, x_range
    )
    boundaries = Vector{Tuple{Float64, Float64, Int64}}(undef, length(bifurcation_intervals))
    for i in eachindex(bifurcation_intervals)
        a, b, n_order = bifurcation_intervals[i]
        boundaries[i] = find_intermittency_boundary!(map, x_range, a, b, n_order)
    end
    ax, color_ranges = plot_colorized_bif_diag(figure[1,1], map, x0, param, param_index, param_range, x_range, boundaries)
    if !isempty(color_ranges)
        plot_colorbar(figure[1,2], color_ranges)
    end
    return ax
end

function find_optimal_low_bound(initial_param, desired_range, nth_func::F, sfp, step=0.1, current_iter=0, max_iter=100) where {F<:Function}
    bound = initial_param
    l, r = desired_range
    x = -1.0
    current_iter += 1
    for iter in current_iter:max_iter
        bound -= step
        try
            x = average_laminar_length(nth_func, sfp, [bound])
        catch e
            if !(e isa DomainError)
                rethrow(e)
            end
        end
        if l <= x <= r
            return bound
        elseif x < l
            return find_optimal_low_bound(bound + step, desired_range, nth_func, sfp, step / 10, iter)
        end
    end
    error("Couldn't find left boundary.")
end

function find_optimal_high_bound(initial_param, desired_range, nth_func::F, sfp, step=0.1, current_iter=0, max_iter=100) where {F<:Function}
    bound = initial_param
    l, r = desired_range
    x = -1.0
    current_iter += 1
    for iter in current_iter:max_iter
        bound -= step
        try
            x = average_laminar_length(nth_func, sfp, [bound])
        catch e
            if !(e isa DomainError)
                rethrow(e)
            end
        end
        if l <= x <= r
            return bound
        elseif x < l
            return find_optimal_high_bound(bound + step, desired_range, nth_func, sfp, step / 10, iter)
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

function find_intermittency_boundary!(map::F, x_range, a, b, n_order) where {F<:Function}
    partition = 2
    max_iter = 10 * partition
    left_boundary, right_boundary = intermittency_region(map, (a, b), n_order, x_range; roundtol=5, max_iter=max_iter, partition=partition)
    return (left_boundary, right_boundary, n_order)
end

function specify_intermittency_bounds(map::F, x_range, left_p, right_p, n_order, low_bound_range=(50, 150), high_bound_range=(900, 1100)) where {F<:Function}
    nth_map = nth_composition(map, n_order)
    sfps = stable_fixed_points(map, right_p, n_order, x_range)
    for (_, sfp) in enumerate(sfps)
        try
            low_bound = find_optimal_low_bound(left_p, low_bound_range, nth_map, sfp)
            high_bound = find_optimal_high_bound(right_p, high_bound_range, nth_map, sfp)
            return low_bound, high_bound, sfp
        catch
            return (-1, -1, -1)
        end
    end
    error("Couldn't find boundary.")
end

function plot_colorized_strip(ax, map::F, x0, param, param_index, left_p, right_p, order, x_range, param_range2) where {F<:Function}
    left_p, right_p, bif_point = specify_intermittency_bounds(map, x_range, left_p, right_p, order, (50, 150), (900, 1100))
    if !(bif_point == left_p == right_p == -1)
        param_range2 = cut_param_range(param_range2, left_p, right_p)
        strip_ = colorize_strip(map, x0, param, param_index, order, left_p, right_p, bif_point)
        scatter!(ax, strip_.data; marker=:circle, color=strip_.colors, colormap=:rainbow, markersize=3, colorrange=strip_.color_range)
        return strip_.color_range, param_range2
    end
end

function plot_colorized_bif_diag(figure, map::F, x0, param, param_index, param_range, x_range, boundaries; total_n=1000, sampling_n=100) where {F<:Function}
    ax = Axis(figure)
    param_range2 = LinRange(param_range[1], param_range[end], 1500)
    color_ranges = Tuple{Float64, Float64}[]
    for (_, (left_p, right_p, order)) in enumerate(boundaries)
        result = plot_colorized_strip(ax, map, x0, param, param_index, left_p, right_p, order, x_range, param_range2)
        if !isnothing(result)
            color_range, param_range2 = result
            push!(color_ranges, color_range)
        end
    end
    plotting_data = bifurcation_data(map, x0, param, param_index, param_range2, total_n, sampling_n)
    scatter!(ax, plotting_data, marker=:circle, markersize=1.0, color=:black)
    return ax, color_ranges
end

function plot_colorbar(figure, color_ranges)
    max_ = maximum([b for (a, b) in color_ranges])
    min_ = maximum([a for (a, b) in color_ranges])
    if length(color_ranges) > 0
        Colorbar(figure, colorrange=(min_, max_), colormap=:rainbow, label="average laminar phase length")
    end
end