using CairoMakie
begin
    # num = 3
    # data = [(0, 0), (0, 1), (1, 0)]
    # scatter(data, color = 1:num, colormap=:heat, markersize = 50)

    n = 100;
    x = LinRange(0, 2*pi, n);
    y = zeros(length(x));
    z = x

    # set color axis limits which by default is automatically equal to the extrema of the color values
    colorrange = [0, 2*pi];
    cmap = :rainbow
    
    # make colored scatter plot
    fig = Figure()
    scatter(fig[1, 1], y, x; color=z, colormap = cmap, markersize=60, strokewidth=0, colorrange = colorrange)

    # add colorbar 
    Colorbar(fig[1, 2], colorrange = colorrange, colormap = cmap, label = "colored data")
    fig
end