function NLS(map::T, param_range::Tuple{Float64, Float64}, o, x_range::Tuple{Float64, Float64}; max_iter=15) where {T<:Function}
    a, b = param_range
    for _ in 1:max_iter
        c = (a+b)/2
        sfps = stable_fixed_points(map, [c], o, x_range)
        if length(sfps) == o
            b = c
        else
            a = c
        end
    end
    return a, b
end

function plot_NLS(
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
        color1=DDS.BLUE,
        color2=DDS.RED,
        kwargs...
    )
    left_boundary, right_boundary = NLS(map, param_range, o, x_range; kwargs...)


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
    lines!(ax, [left_boundary, left_boundary], [x_range...], color=color1, linewidth=3)
    lines!(ax, [right_boundary, right_boundary], [x_range...], color=color2, linewidth=3)
    return ax
end