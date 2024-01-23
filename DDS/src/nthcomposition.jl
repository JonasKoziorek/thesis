function nth_composite(func::F, x0, params, n_order) where {F<:Function}
    x = x0
    for i = 1:n_order
        x = func(x, params)
    end
    return x
end

function nth_composition(func::F, n_order) where {F<:Function}
    f(x, params) = nth_composite(func, x, params, n_order)
    return f
end

function plot_nth_composition_data(func, x_range, params, n_order)
    nth_func = nth_composition(func, n_order)
    x = x_range
    y = [nth_func(i, params) for i in x]
    return x,y
end

function plot_nth_composition!(fig, func, x_range, params, n_order, identity_line=false; ax_aspect=1, title="", kwargs...)
    x, y = plot_nth_composition_data(func, x_range, params, n_order)
    ax = Axis(fig, 
            xlabel=L"x", 
            ylabel=L"f^{%$(n_order)}(x)",
            title=title
        )
    ax.aspect = ax_aspect
    lines!(x, y; color=:black, kwargs...)
    if identity_line
        lines!(x, x; linestyle=:dash, color=:black, linewidth=1.5)
    end
    return ax
end

function plot_nth_composition(func::F, x_range, params, n_order, identity_line=false; ax_aspect=1, title="", kwargs...) where {F<:Function}
    x, y = plot_nth_composition_data(func, x_range, params, n_order)
    fig = Figure()
    ax = Axis(fig[1,1], 
            xlabel=L"x", 
            ylabel=L"f^%$(n_order)(x)",
            title=title
        )
    ax.aspect = ax_aspect
    lines!(x, y; color=:black, kwargs...)
    if identity_line
        lines!(x, x; color=:black, linewidth=1.5, linestyle=:dash)
    end
    return fig
end