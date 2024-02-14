function trajectory(func, x0, params, total_n, index_x; starting_n=0, kwargs...)
    x = starting_n:total_n+starting_n
    x0 = iterate(func, x0, params, starting_n)[end]
    data = iterate(func, x0, params, total_n)
    y = [i[index_x] for i in data] 
    return trajectory_plot(x, y,; kwargs...)
end

function trajectory!(figure, func, x0, params, total_n, index_x; starting_n=0, kwargs...)
    x = starting_n:total_n+starting_n
    x0 = iterate(func, x0, params, starting_n)[end]
    data = iterate(func, x0, params, total_n)
    y = [i[index_x] for i in data] 
    return trajectory_axis(figure, x, y; starting_n = starting_n, kwargs...)
end

function trajectory_plot(x, y; resolution=(800, 500), kwargs...)
    fig = Figure(resolution=resolution)
    ax = trajectory_axis(fig[1,1], x, y; starting_n = starting_n, kwargs...)
    return fig
end

function trajectory_axis(figure, x, y;starting_n=0, xtick_period = 100, ax_aspect=6, markersize=1.0, title="", dot_color=:black, line_color=:black, linewidth=1)
    ax = Axis(figure, 
            xlabel=L"n", 
            ylabel=L"x_{n}",
            xticks=starting_n:xtick_period:starting_n+length(x),
            title=title
        )
    ax.aspect = ax_aspect
    lines!(x, y; color=line_color, linewidth=linewidth)
    scatter!(x, y, marker = :circle, markersize = markersize, color = dot_color)
    return ax
end