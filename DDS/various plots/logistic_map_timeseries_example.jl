using DDS

begin
    logistic = DDS.logistic
    LINEWIDTH = 0.5
    POINT_SIZE = 12
    LATEX_FONT_SIZE = 30
    FONTSIZE = 20

    fig = Figure(
        resolution = (1000, 500),
        fontsize=FONTSIZE,
    )

    total_n = 80
    p = [3.841]
    x0 = 0.5

    ax3 = DDS.timeseries!(fig[1,1], logistic, x0, p, total_n, 1; 
        ax_aspect=2, 
        markersize=POINT_SIZE,
        xtick_period=10,
        linewidth=LINEWIDTH, 
        dot_color=BLUE,
        # title="Evolution of logistic map for r=$(p[1]), x0=$(x0)"
    )
    ax3.xlabelsize = LATEX_FONT_SIZE
    ax3.ylabelsize = LATEX_FONT_SIZE
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_timeseries_example.png"
    save(file_path, fig)
end