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
    if !isnothing(left_p) && !isnothing(right_p)
        param_range = filter(x -> x < left_p || x > right_p, collect(param_range))
    end
    seqsize = sampling_n + 1
    plotting_data = Vector{Tuple{Float64,Float64}}(undef, length(param_range)*seqsize)
    for (i, param_value) in enumerate(param_range)
        j = (i-1)*seqsize+1
        params[param_index] = param_value
        raw_data = iterate(func, x0, params, total_n)
        data = sample(raw_data, sampling_n)
        data = pick_index(data, index_x)
        plotting_data[j:j+seqsize-1] = bifurcation_plot_point(param_value, data)
    end
    return plotting_data
end


function bifurcation_diagram(func, x0, params, param_index, param_range, total_n, sampling_n, index_x=1;  resolution = (800, 500), param_name = "parameter", kwargs...)
    println("-----------")
    @time plotting_data = bifurcation_data(func, x0, params, param_index, param_range, total_n, sampling_n, index_x)
    fig = Figure(resolution=resolution)
    @time bifurcation_diagram_axis(fig[1,1], plotting_data, param_name; kwargs...)
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