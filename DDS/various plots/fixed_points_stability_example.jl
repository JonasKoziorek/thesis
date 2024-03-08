using DDS
using CairoMakie
using CairoMakie.Makie.GeometryBasics

begin
    LINEWIDTH = 3.0
    LIMITS = (0, 1, 0, 1)
    MARKERSIZE = 23
    RESOLUTION = (630, 600)
    LATEX_FONT_SIZE = 40
    FONTSIZE = 30

    logistic = DDS.logistic
    x0 = 0.5
    param = [2.3]
    order = 1

    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0, 1)
    fig = CairoMakie.Figure(resolution=RESOLUTION, fontsize=FONTSIZE)

    fps = DDS.fixed_points(logistic, param, order, x_range; method=:DL)
    sfps = DDS.stable_fixed_points(logistic, param, order, x_range; method=:DL)
    identity_line = false
    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=1, linewidth=3.5)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    ax.limits=LIMITS
    ax.xlabel = L"$x$"
    ax.ylabel = L"$\mathcal{L}_{%$(param[1])}(x)$"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE

    xr = sfps[1]
    J_xr = DDS.jacobian(logistic)(xr, param)

    NE = 1*(1-xr)+logistic(xr, param)
    NW = -1*(0-xr)+logistic(xr, param)
    SE = -1*(1-xr)+logistic(xr, param)
    SW = 1*(0-xr)+logistic(xr, param)
    upper_limit = max(NE, NW, J_xr*(0-xr)+logistic(xr, param))
    lower_limit = min(SE, SW, J_xr*(1-xr)+logistic(xr, param))
    # stable region
    poly!(ax, [
            (1, NE), 
            (1, SE),
            (xr, logistic(xr, param)), 
        ], color=(RED, 0.3)
    )
    poly!(ax, [
            (xr, logistic(xr, param)), 
            (0, SW), 
            (0, NW)
        ], color=(RED, 0.3)
    )
    # unstable region
    poly!(ax, Point2f[
            (1, 1*(1-xr)+logistic(xr, param)), 
            (xr, logistic(xr, param)), 
            (0, -1*(0-xr)+logistic(xr, param)),
            (0, upper_limit),
            (1, upper_limit),
            (1, 1*(1-xr)+logistic(xr, param)), 
        ], color=(BLUE, 0.3)
    )
    poly!(ax, Point2f[
            (0, lower_limit),
            (1, lower_limit),
            (1, -1*(1-xr)+logistic(xr, param)),
            (xr, logistic(xr, param)), 
            (0, 1*(0-xr)+logistic(xr, param)), 
            (0, lower_limit),
        ], color=(BLUE, 0.3)
    )

    lines!(ax, [0, 1], [1*(0-xr)+logistic(xr, param), 1*(1-xr)+logistic(xr, param)], color=:black, linewidth=LINEWIDTH, linestyle=:dash)
    lines!(ax, [0, 1], [J_xr*(0-xr)+logistic(xr, param), J_xr*(1-xr)+logistic(xr, param)], color=RED, linewidth=LINEWIDTH)
    lines!(ax, [0, 1], [-1*(0-xr)+logistic(xr, param), -1*(1-xr)+logistic(xr, param)], color=:black, linewidth=LINEWIDTH, linestyle=:dash)

    scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE, markersize=MARKERSIZE)
    scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED, markersize=MARKERSIZE)

    hidedecorations!(ax, grid=true, label=false, ticklabels=false, ticks=false, minorgrid=true)
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "fixed_points_stability_example{1}.png"
    save(file_path, fig)



    param = [3.3]
    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0, 1)
    fig = CairoMakie.Figure(resolution=RESOLUTION, fontsize=FONTSIZE)

    fps = DDS.fixed_points(logistic, param, order, x_range; method=:DL)
    sfps = DDS.stable_fixed_points(logistic, param, order, x_range; method=:DL)
    identity_line = false
    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=1, linewidth=3.5)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    ax.limits=LIMITS
    ax.xlabel = L"$x$"
    ax.ylabel = L"$\mathcal{L}_{%$(param[1])}(x)$"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE

    xr = fps[2]
    J_xr = DDS.jacobian(logistic)(xr, param)

    NE = 1*(1-xr)+logistic(xr, param)
    NW = -1*(0-xr)+logistic(xr, param)
    SE = -1*(1-xr)+logistic(xr, param)
    SW = 1*(0-xr)+logistic(xr, param)
    upper_limit = max(NE, NW, J_xr*(0-xr)+logistic(xr, param))
    lower_limit = min(SE, SW, J_xr*(1-xr)+logistic(xr, param))
    # stable region
    poly!(ax, [
            (1, NE), 
            (1, SE),
            (xr, logistic(xr, param)), 
        ], color=(RED, 0.3)
    )
    poly!(ax, [
            (xr, logistic(xr, param)), 
            (0, SW), 
            (0, NW)
        ], color=(RED, 0.3)
    )
    # unstable region
    poly!(ax, Point2f[
            (1, 1*(1-xr)+logistic(xr, param)), 
            (xr, logistic(xr, param)), 
            (0, -1*(0-xr)+logistic(xr, param)),
            (0, upper_limit),
            (1, upper_limit),
            (1, 1*(1-xr)+logistic(xr, param)), 
        ], color=(BLUE, 0.3)
    )
    poly!(ax, Point2f[
            (1, lower_limit),
            (0, lower_limit),
            (xr, logistic(xr, param)), 
            (1, -1*(1-xr)+logistic(xr, param)),
            (1, lower_limit),
        ], color=(BLUE, 0.3)
    )

    lines!(ax, [0, 1], [1*(0-xr)+logistic(xr, param), 1*(1-xr)+logistic(xr, param)], color=:black, linewidth=LINEWIDTH, linestyle=:dash)
    lines!(ax, [0, 1], [J_xr*(0-xr)+logistic(xr, param), J_xr*(1-xr)+logistic(xr, param)], color=BLUE, linewidth=LINEWIDTH)
    lines!(ax, [0, 1], [-1*(0-xr)+logistic(xr, param), -1*(1-xr)+logistic(xr, param)], color=:black, linewidth=LINEWIDTH, linestyle=:dash)

    scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE, markersize=MARKERSIZE)
    scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED, markersize=MARKERSIZE)

    hidedecorations!(ax, grid=true, label=false, ticklabels=false, ticks=false, minorgrid=true)
    display(fig)


    file_path = DDS.FIGURES_DIRECTORY * "fixed_points_stability_example{2}.png"
    save(file_path, fig)
end;