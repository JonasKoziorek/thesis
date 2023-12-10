function colorize_bif_diag!(figure, func, x0, params, param_index, param_range, total_n, sampling_n, left_p, right_p, index_x=1; param_name = "parameter", kwargs...)
    plotting_data = bifurcation_data(func, x0, params, param_index, param_range, total_n, sampling_n, index_x; left_p = left_p, right_p = right_p)
    division = 20
    rng = LinRange(left_p, right_p, division)
    new_rng = Float64[]
    for i = 1:length(rng)-1
        append!(new_rng, collect(LinRange(rng[i], rng[i+1], division*i)))
    end
    plotting_data2 = bifurcation_data(func, x0, params, param_index, new_rng, 7000, 5000, index_x)
    ax = color_bif_diag_axis(figure, plotting_data, plotting_data2, param_name, left_p, right_p; kwargs...)
    return ax
end

function color_bif_diag_axis(figure, plotting_data, plotting_data2, param_name, left_p, right_p;xticks = CairoMakie.Makie.automatic, ax_aspect=1, markersize=1.0, title="", color=:black, kwargs...)
    ax = Axis(figure, 
            xlabel="$param_name", 
            ylabel="x",
            title=title,
            xticks=xticks,
            kwargs...
        )
    ax.aspect = ax_aspect

    x0 = 0.15992881844625645
    map_ = DDS.nth_composition(DDS.logistic, 3)
    nth_logistic = (x, p) -> map_(x+x0, p) - x0
    L(p) = nth_logistic(0, [p])^(-0.5)
    colorrange = [L(left_p), L(right_p)];
    cmap = :rainbow

    colors = Float64[]
    for (p, y) in plotting_data2
        if p >= left_p && p <= right_p
            push!(colors, L(p))
        end
    end
    # println(new_plotting_data)
    # println(colors)
    println(colorrange)
    scatter!(ax, plotting_data, marker = :circle, markersize = markersize, color = color)
    scatter!(ax, plotting_data2; marker=:circle, color=colors, colormap = cmap, markersize=markersize+2, colorrange = colorrange)
    return ax
end