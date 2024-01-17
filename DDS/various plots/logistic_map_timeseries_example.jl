using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    LINEWIDTH = 1.2
    POINT_SIZE = 15
    LATEX_FONT_SIZE = 50
    FONTSIZE = 40
    RESOLUTION = (1000, 700)
    AX_ASPECT = 1.5

    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )

    total_n = 80
    p = [3.85]
    x0 = 0.5

    ax3 = DDS.trajectory!(fig[1,1], logistic, x0, p, total_n, 1; 
        ax_aspect=AX_ASPECT, 
        markersize=POINT_SIZE,
        xtick_period=10,
        linewidth=LINEWIDTH, 
        dot_color=BLUE,
        # title="Trajectory of logistic map for r=$(p[1]), x0=$(x0)"
    )
    ax3.xlabelsize = LATEX_FONT_SIZE
    ax3.ylabelsize = LATEX_FONT_SIZE
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_trajectory_example1.png"
    save(file_path, fig)

    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )

    total_n = 80
    p = [3.86]
    x0 = 0.5

    ax3 = DDS.trajectory!(fig[1,1], logistic, x0, p, total_n, 1; 
        ax_aspect=AX_ASPECT, 
        markersize=POINT_SIZE,
        xtick_period=10,
        linewidth=LINEWIDTH, 
        dot_color=BLUE,
        # title="Trajectory of logistic map for r=$(p[1]), x0=$(x0)"
    )
    ax3.xlabelsize = LATEX_FONT_SIZE
    ax3.ylabelsize = LATEX_FONT_SIZE
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_trajectory_example2.png"
    save(file_path, fig)
end