using DDS
using CairoMakie

# old version, new below
begin
    logistic = DDS.logistic
    LINEWIDTH = 1.2
    POINT_SIZE = 15
    LATEX_FONT_SIZE = 50
    FONTSIZE = 40
    RESOLUTION = (1000, 700)
    AX_ASPECT = 1.5
    total_n = 50
    starting_n = 50
    x0 = 0.5

    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )

    p = [3.828]
    x0 = DDS.iterate(logistic, x0, p, starting_n)[end]

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

    p = [3.829]
    x0 = DDS.iterate(logistic, x0, p, starting_n)[end]

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

begin
    logistic = DDS.logistic
    LINEWIDTH = 2.0
    POINT_SIZE = 15
    LATEX_FONT_SIZE = 50
    FONTSIZE = 40
    DOT_COLOR = BLUE
    RESOLUTION = (900, 500)
    AX_ASPECT = 1.5
    BIF_AX_ASPECT = 0.32
    YTICKS = LinRange(0.0, 1.0, 5)
    LIMITS = (nothing, nothing, 0.0, 1.0)
    starting_n = 50
    total_n = 50
    x0 = 0.5

    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )

    p = [3.828]

    width = 4
    ax3 = DDS.trajectory!(fig[1,1:width], logistic, x0, p, total_n, 1; 
        starting_n=starting_n,
        ax_aspect=AX_ASPECT, 
        markersize=POINT_SIZE,
        xtick_period=10,
        linewidth=LINEWIDTH, 
        dot_color=DOT_COLOR,
        line_color=RED,
        # title="Trajectory of logistic map for r=$(p[1]), x0=$(x0)"
    )
    ax3.xlabelsize = LATEX_FONT_SIZE
    ax3.ylabelsize = LATEX_FONT_SIZE
    ax3.yticks = YTICKS
    ax3.limits = LIMITS

    ax4 = DDS.bifurcation_diagram!(fig[1,width+1], logistic, x0, p, 1, p, total_n+starting_n, total_n, 1; markersize=POINT_SIZE, ax_aspect=BIF_AX_ASPECT, color=DOT_COLOR)
    ax4.xlabel = L"$r$"
    ax4.ylabel = L"$x_n$"
    ax4.xticks = p
    ax4.xlabelsize = LATEX_FONT_SIZE
    ax4.ylabelsize = LATEX_FONT_SIZE
    ax4.yticks = YTICKS
    ax4.limits = LIMITS

    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_trajectory_example1.png"
    save(file_path, fig)

    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )

    p = [3.829]

    width = 4
    ax3 = DDS.trajectory!(fig[1,1:width], logistic, x0, p, total_n, 1; 
        starting_n=starting_n,
        ax_aspect=AX_ASPECT, 
        markersize=POINT_SIZE,
        xtick_period=10,
        linewidth=LINEWIDTH, 
        dot_color=DOT_COLOR,
        line_color=RED,
    )
    ax3.xlabelsize = LATEX_FONT_SIZE
    ax3.ylabelsize = LATEX_FONT_SIZE
    ax3.yticks = YTICKS
    ax3.limits = LIMITS

    ax4 = DDS.bifurcation_diagram!(fig[1,width+1], logistic, x0, p, 1, p, total_n+starting_n, total_n, 1; markersize=POINT_SIZE, ax_aspect=BIF_AX_ASPECT, color=DOT_COLOR)
    ax4.xlabel = L"$r$"
    ax4.ylabel = L"$x_n$"
    ax4.xticks = p
    ax4.xlabelsize = LATEX_FONT_SIZE
    ax4.ylabelsize = LATEX_FONT_SIZE
    ax4.yticks = YTICKS
    ax4.limits = LIMITS

    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_trajectory_example2.png"
    save(file_path, fig)
end