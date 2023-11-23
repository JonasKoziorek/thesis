function plot_cobweb_data(func, x0, params, total_n, n_order=1, starting_x=0)
    x0 = last(iterate(func, x0, params, starting_x))
    next_x(x0_) = last(iterate(func, x0_, params, n_order))
    data_len = 1
    x_n = next_x(x0)
    x_data = [x0, x0]
    y_data = [x0, x_n]
    while data_len < total_n
        p = x_n # placeholder
        x_n = next_x(x_n)
        append!(x_data, [p, p])
        append!(y_data, [p, x_n])
        data_len += 1
    end
    return x_data, y_data
end

function plot_cobweb_axis!(figure, x1, x2, y1, y2, n_order; identity_line_color=:black, function_line_color=:black, cobweb_line_color=RED, last_point_color=RED, ax_aspect=1, title="", function_line_size = 1.5, identity_line_size = 1.5, dot_size = 9, cobweb_line_size = 1.5)
    ax = Axis(figure, 
            xlabel=L"$x$", 
            ylabel=L"$f^{%$(n_order)}(x)$",
            title=title
        )
    ax.aspect = ax_aspect
    lines!(x1, y1; color=function_line_color, linewidth=function_line_size)
    lines!(x1, x1; linestyle=:dash, color=identity_line_color, linewidth=identity_line_size)
    lines!(x2, y2; color=cobweb_line_color, linewidth=cobweb_line_size)
    scatter!(x2[end], y2[end]; marker=:circle, color=last_point_color, markersize=dot_size)
    return ax
end

function plot_cobweb(func, x0, x_range, params, n_iters, n_order=1, starting_x=0;resolution = (800, 500), kwargs...)
    x1, y1 = plot_nth_composition_data(func, x_range, params, n_order)
    x2, y2 = plot_cobweb_data(func, x0, params, n_iters, n_order, starting_x)
    fig = Figure(resolution=resolution)
    plot_cobweb_axis!(fig[1,1], x1, x2, y1, y2, n_order; kwargs...)
    return fig
end

function plot_cobweb!(figure, func, x0, x_range, params, n_iters, n_order=1, starting_x=0; kwargs...)
    x1, y1 = plot_nth_composition_data(func, x_range, params, n_order)
    x2, y2 = plot_cobweb_data(func, x0, params, n_iters, n_order, starting_x)
    return plot_cobweb_axis!(figure, x1, x2, y1, y2, n_order; kwargs...)
end