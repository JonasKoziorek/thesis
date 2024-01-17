function colorize_bif_diag!(figure, func, x0, params, param_index, param_range, n_order, total_n, sampling_n, left_p, right_p, bif_point, index_x=1;xticks = CairoMakie.Makie.automatic, ax_aspect=1, markersize=1.0, title="", color=:black, param_name = "parameter", kwargs...)
    x0 = bif_point
    println(x0)
    map_ = DDS.nth_composition(DDS.logistic, n_order)
    nth_logistic = (x, p) -> map_(x+x0, p) - x0
    avg_lam_len(p) = nth_logistic(0, [p])^(-0.5)


    plotting_data = bifurcation_data(func, x0, params, param_index, param_range, total_n, sampling_n, index_x; left_p = left_p, right_p = right_p)
    division = 10
    rng = LinRange(left_p, right_p, division)
    new_rng = Float64[]
    for i = 1:length(rng)-1
        append!(new_rng, collect(LinRange(rng[i], rng[i+1], division*i)))
    end
    max_iter = Int64(floor(avg_lam_len(right_p)))
    println(max_iter)
    plotting_data2 = bifurcation_data(func, x0, params, param_index, new_rng, max_iter, max_iter-1, index_x)
    ax = Axis(figure[1, 1], 
            xlabel="$param_name", 
            ylabel="x",
            title=title,
            xticks=xticks,
            kwargs...
        )
    ax.aspect = ax_aspect

    colorrange = [avg_lam_len(left_p), avg_lam_len(right_p)];
    cmap = :rainbow

    colors = Float64[]
    for (param, _) in plotting_data2
        if param >= left_p && param <= right_p
            push!(colors, avg_lam_len(param))
        end
    end
    println(colorrange)
    scatter!(ax, plotting_data, marker = :circle, markersize = markersize, color = color)
    scatter!(ax, plotting_data2; marker=:circle, color=colors, colormap = cmap, markersize=markersize+2, colorrange = colorrange)

    colorrange = [avg_lam_len(left_p), avg_lam_len(right_p)];
    cmap = :rainbow
    Colorbar(figure[1, 2], colorrange = colorrange, colormap = cmap, label="average laminar phase length")
    return ax
end