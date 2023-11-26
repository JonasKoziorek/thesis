function timeseries(func, x0, params, total_n, index_x; kwargs...)
    x = 1:total_n
    data = iterate(func, x0, params, total_n)
    y = [i[index_x] for i in data] 
    return timeseries_plot(x, y,; kwargs...)
end

function timeseries!(figure, func, x0, params, total_n, index_x; kwargs...)
    x = 1:total_n
    data = iterate(func, x0, params, total_n)
    y = [i[index_x] for i in data] 
    return timeseries_axis(figure, x, y; kwargs...)
end

function timeseries_plot(x, y; resolution=(800, 500), kwargs...)
    fig = Figure(resolution=resolution)
    ax = timeseries_axis(fig[1,1], x, y; kwargs...)
    return fig
end

function timeseries_axis(figure, x, y;xtick_period = 100, ax_aspect=6, markersize=1.0, title="", dot_color=:black, line_color=:black, linewidth=1)
    ax = Axis(figure, 
            xlabel=L"n", 
            ylabel=L"x_{n}",
            xticks=0:xtick_period:length(x),
            title=title
        )
    ax.aspect = ax_aspect
    lines!(x, y; color=line_color, linewidth=linewidth)
    scatter!(x, y, marker = :circle, markersize = markersize, color = dot_color)
    return ax
end