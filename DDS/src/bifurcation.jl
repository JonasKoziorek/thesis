function sample(data, sampling_n::Int)
    return data[end-sampling_n:end]
end

function bifurcation_plot_point(param_value, data)
    collect(zip([param_value for j=1:length(data)], data))
end

function pick_index(data, index)
    return [i[index] for i in data]
end

function bifurcation_data(func, x0, params, param_index, param_range, total_n, sampling_n, index_x=1; left_p=nothing, right_p=nothing)
    plotting_data = Vector{Tuple{Float64, Float64}}(undef, 0)
    if !isnothing(left_p) && !isnothing(right_p)
        param_range = filter(x->x<left_p || x>right_p, collect(param_range))
    end
    for  param_value in param_range
        params[param_index] = param_value
        raw_data = iterate(func, x0, params, total_n)
        data = sample(raw_data, sampling_n)
        data = pick_index(data, index_x)
        append!(plotting_data, bifurcation_plot_point(param_value, data))
    end
    return plotting_data
end

# function bifurcation_data(func, x0, params, param_index, param_range, total_n, sampling_n, index_x=1; left_p=nothing, right_p=nothing)
#     if !isnothing(left_p) && !isnothing(right_p)
#         param_range = filter(x -> x < left_p || x > right_p, collect(param_range))
#     end
#     plotting_data = Vector{Tuple{Float64,Float64}}(undef, 0)
#     chunks = Iterators.partition(param_range, length(param_range) ÷ Threads.nthreads())
#     tasks = map(chunks) do chunk
#         Threads.@spawn trajectory_sample(func, copy(x0), copy(params), copy(param_index), chunk, copy(total_n), copy(sampling_n), copy(index_x))
#     end
#     thread_results = fetch.(tasks)
#     for i in thread_results
#         append!(plotting_data, i)
#     end
#     return plotting_data
# end
# function trajectory_sample(func, x0, params, param_index, param_range, total_n, sampling_n, index_x=1)
#     thread_container = []
#     for param_value in param_range
#         params[param_index] = param_value
#         raw_data = iterate(func, x0, params, total_n)
#         data = sample(raw_data, sampling_n)
#         data = pick_index(data, index_x)
#         append!(thread_container, bifurcation_plot_point(param_value, data))
#     end
#     return thread_container
# end

function bifurcation_diagram(func, x0, params, param_index, param_range, total_n, sampling_n, index_x=1;  resolution = (800, 500), param_name = "parameter", kwargs...)
    println("\n-----------\n")
    plotting_data = bifurcation_data(func, x0, params, param_index, param_range, total_n, sampling_n, index_x)
    fig = Figure(resolution=resolution)
    bifurcation_diagram_axis(fig[1,1], plotting_data, param_name; kwargs...)
    return fig
end

function bifurcation_diagram!(figure, func, x0, params, param_index, param_range, total_n, sampling_n, index_x=1;  resolution = (800, 500), param_name = "parameter", kwargs...)
    plotting_data = bifurcation_data(func, x0, params, param_index, param_range, total_n, sampling_n, index_x)
    ax = bifurcation_diagram_axis(figure, plotting_data, param_name; kwargs...)
    return ax
end

function bifurcation_diagram_axis(figure, plotting_data, param_name;xticks = CairoMakie.Makie.automatic, ax_aspect=1, markersize=1.0, title="", color=:black, kwargs...)
    ax = Axis(figure, 
            xlabel="$param_name", 
            ylabel="x",
            title=title,
            xticks=xticks,
            kwargs...
        )
    ax.aspect = ax_aspect
    scatter!(plotting_data, marker = :circle, markersize = markersize, color = color)
    return ax
end