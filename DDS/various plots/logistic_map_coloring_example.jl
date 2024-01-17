using CairoMakie

begin
    # num = 3
    # data = [(0, 0), (0, 1), (1, 0)]
    # scatter(data, color = 1:num, colormap=:heat, markersize = 50)

    n = 100;
    x = LinRange(0, 2*pi, n);
    y = sin.(x);
    z = x

    # set color axis limits which by default is automatically equal to the extrema of the color values
    colorrange = [0, 2*pi];
    cmap = :heat
    
    # make colored scatter plot
    fig = Figure()
    scatter(fig[1, 1], x, y; color=z, colormap = cmap, markersize=10, strokewidth=0, colorrange = colorrange)
    scatter!(fig[1, 1], [(5.5, 0),(5.5, 0.5),(5.5, 0.6)]; color=[5.5, 5.5, 5.5], colormap = cmap, markersize=10, strokewidth=0, colorrange = colorrange)

    # add colorbar 
    Colorbar(fig[1, 2], colorrange = colorrange, colormap = cmap, label = "colored data")
    fig
end

begin
    logistic = DDS.logistic
    x01 = 0.15992881844625645
    param = [1+sqrt(8)-0.0000001]
    order = 3


    total_n = 1000
    last_n = 50
    p_range = LinRange(3.82835, 3.8285, 10000)
    figure = Figure()
    left_p = 1+sqrt(8)-2.5*1e-5
    right_p = 1+sqrt(8)-1e-7
    bif_point = 0.15992881844625645
    n_order = 3
    ax = DDS.colorize_bif_diag!(figure[1,1], logistic, 0.5, param, 1, p_range, n_order, total_n, last_n, left_p, right_p, bif_point;param_name="")
    ax.xlabel = ""
    ax.ylabel = ""

    x0 = 0.15992881844625645
    map_ = DDS.nth_composition(DDS.logistic, 3)
    nth_logistic = (x, p) -> map_(x+x0, p) - x0
    f(p) = nth_logistic(0, [p])^(-0.5)
    colorrange = [f(left_p), f(right_p)];
    cmap = :rainbow
    Colorbar(figure[1, 2], colorrange = colorrange, colormap = cmap, label="average laminar phase length")
    display(figure)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_coloring_example.png"
    save(file_path, figure)
end