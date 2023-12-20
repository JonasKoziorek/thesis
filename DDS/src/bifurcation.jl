function sample!(sampled_data::Vector, data::Vector, sampling_n::Int)
    j = 1
    for i in length(data)-sampling_n:length(data)
        sampled_data[j] = data[i]
        j+=1
    end
end

function bifurcation_plot_point!(plot_points::Vector{Tuple{Float64, Float64}}, param_value::Float64, data::Vector)
    for i in 1:length(data)
        plot_points[i] = (param_value, data[i])
    end
end

function pick_index!(data::Vector, index::Int)
    for i in 1:length(data)
        data[i] = data[i][index]
    end
end

function prepare_data(total_n, sampling_n, param_range, x0)
    seqlen = sampling_n + 1
    plotting_data = Vector{Tuple{Float64, Float64}}(undef, seqlen*length(param_range))
    raw_data = Vector{typeof(x0)}(undef, total_n+1)
    sampled_data = Vector{typeof(x0)}(undef, sampling_n+1)
    plot_points = Vector{Tuple{Float64, Float64}}(undef, sampling_n+1)
    return plotting_data, raw_data, sampled_data, plot_points, seqlen
end

function process_param_value!(func, x0, params, param_index, param_value, total_n, sampling_n, index_x, raw_data, sampled_data, plot_points)
    params[param_index] = param_value
    iterate!(func, x0, params, total_n, raw_data)
    pick_index!(raw_data, index_x)
    sample!(sampled_data, raw_data, sampling_n)
    bifurcation_plot_point!(plot_points, param_value, sampled_data)
end

function bifurcation_data(func, x0, params, param_index, param_range, total_n, sampling_n, index_x=1; left_p=nothing, right_p=nothing)
    if !isnothing(left_p) && !isnothing(right_p)
        param_range = filter(x->x<left_p || x>right_p, collect(param_range))
    end
    plotting_data, raw_data, sampled_data, plot_points, seqlen = prepare_data(total_n, sampling_n, param_range, x0)
    i = 0
    for param_value in param_range
        j = i*seqlen + 1
        process_param_value!(func, x0, params, param_index, param_value, total_n, sampling_n, index_x, raw_data, sampled_data, plot_points)
        @views plotting_data[j:j+seqlen-1] = plot_points
        i += 1
    end
    return plotting_data
end

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