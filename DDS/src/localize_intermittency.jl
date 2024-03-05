function intermittency_region_left(
        map,
        param_range::Tuple{Float64, Float64},
        o::Integer, # searching for orbits of period o 
        x_range::Tuple{Real, Real},
        current_iter = 0; # for recursion purposes
        max_iter=15,
        partition=2, # divide param_range to partition subintervals
    )
    a, b = param_range
    prev_param = a
    for param in LinRange(a, b, partition+1)
        if current_iter == max_iter
            return prev_param
        end
        fps = stable_fixed_points(map, [param], o, x_range)
        if length(fps) == o
            a == b && return a
            return intermittency_region_left(map, (prev_param, param), o, x_range, current_iter; max_iter=max_iter, partition=partition)
        end
        prev_param = param
        current_iter += 1
    end
    return a
end

function intermittency_region_right(
        map,
        param_range::Tuple{Float64, Float64},
        o::Integer, # searching for orbits of period o 
        x_range::Tuple{Real, Real},
        current_iter = 0; # for recursion purposes
        max_iter=15, 
        partition=2, # divide param_range to partition subintervals
    )
    a, b = param_range
    prev_param = b
    for param in LinRange(b, a, partition+1)
        if current_iter == max_iter
            return prev_param
        end
        fps = stable_fixed_points(map, [param], o, x_range)
        if length(fps) != o
            a == b && return a
            return intermittency_region_right(map, (param, prev_param), o, x_range, current_iter; max_iter=max_iter, partition=partition)
        end
        prev_param = param
        current_iter += 1
    end
    return a
end

function intermittency_region(
        map,
        param_range::Tuple{Float64, Float64},
        o, # searching for periodic orbits of period o
        x_range::Tuple{Real, Real}; 
        kwargs...
    )
    thread_left = Threads.@spawn intermittency_region_left(deepcopy(map), deepcopy(param_range), deepcopy(o), deepcopy(x_range); deepcopy(kwargs)...)
    thread_right = Threads.@spawn intermittency_region_right(deepcopy(map), deepcopy(param_range), deepcopy(o), deepcopy(x_range); deepcopy(kwargs)...)
    left::Float64 = fetch(thread_left)
    right::Float64 = fetch(thread_right)
    return left, right
end

function plot_intermittency_region(
        fig, 
        map,
        x0,
        param,
        param_range::Tuple{Float64, Float64},
        o, # searching for periodic orbits of period o
        x_range::Tuple{Real, Real};
        p_index = 1,
        x_index = 1,
        total_n=1000,
        last_n=100,
        range_partition = 2000, 
        kwargs...
    )
    left_boundary, right_boundary = intermittency_region(map, param_range, o, x_range; kwargs...)

    p_range = LinRange(param_range..., range_partition)
    ax = bifurcation_diagram!(
        fig, 
        map,
        x0,
        param,
        p_index, 
        p_range, 
        total_n,
        last_n,
        x_index
    )
    lines!(ax, [left_boundary, left_boundary], [x_range...], color=DDS.BLUE, linewidth=3)
    lines!(ax, [right_boundary, right_boundary], [x_range...], color=DDS.RED, linewidth=3)
    return ax
end