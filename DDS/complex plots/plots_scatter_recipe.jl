function diff_scatter(x, y, ticks, total_n , last_n, x0, x_axis_name)
    return scatter(
        x, 
        y, 
        markercolor=:black, 
        markersize=1.5, 
        legend=false, 
        xticks = (ticks, string.(ticks)),
        # xlabel = L"$a$",
        xlabel = x_axis_name,
        ylabel = L"$x_{n}$",
        title="\n\nBifurcation diagram for $total_n total iterations, plotting last $last_n interations, x0=$x0",
        titlefontsize=11,
        top_margin = 10px,
        bottom_margin = 10px,
        left_margin = 40px,
        right_margin = 40px,
        xlabelfontsize = 17,
        ylabelfontsize = 17,
    )
end