using DDS
using CairoMakie

logistic = DDS.logistic

begin
    LATEX_FONT_SIZE = 40
    FONTSIZE = 30
    RESOLUTION = (700, 450)
    DOT_COLOR = BLUE
    YTICKS = LinRange(0.0, 1.0, 5)
    LIMITS = (nothing, nothing, 0.0, 1.0)
    BIF_AX_ASPECT = 0.210
    POINT_SIZE = 15
    width = 4

    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )
    x = 0:0.0001:1
    x0=0.5
    starting_n = 50
    total_n = 50
    n_order = 1

    p = [3.828]

    ax = DDS.plot_cobweb!(
        fig[1,1:width], logistic, x0, x, p, total_n, n_order, starting_n;
        ax_aspect=1,
        identity_line_color=:black,
        function_line_color=:black,
        cobweb_line_color=RED,
        last_point_color=BLUE,
        dot_size=POINT_SIZE,
        # title = "Cobweb diagram of $total_n iterations of logistic map with r=$(p[1]) and x0=$(x0)"
    )
    ax.ylabel = L"\mathbb{L}^{%$(n_order)}_{%$(p[1])}(x)"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    ax.yticks = YTICKS
    ax.limits = LIMITS



    ax4 = DDS.bifurcation_diagram!(fig[1,width+1], logistic, x0, p, 1, p, total_n+starting_n, total_n, 1; markersize=POINT_SIZE, ax_aspect=BIF_AX_ASPECT, color=DOT_COLOR)
    ax4.xlabel = L"$r$"
    ax4.ylabel = L"$x_n$"
    ax4.xticks = p
    ax4.xlabelsize = LATEX_FONT_SIZE
    ax4.ylabelsize = LATEX_FONT_SIZE
    ax4.yticks = YTICKS
    ax4.limits = LIMITS
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_cobweb_diag_example1.png"
    save(file_path, fig)






    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )

    p = [3.829]

    ax = DDS.plot_cobweb!(
        fig[1,1:width], logistic, x0, x, p, total_n, n_order, starting_n;
        ax_aspect=1,
        identity_line_color=:black,
        function_line_color=:black,
        cobweb_line_color=RED,
        last_point_color=BLUE,
        dot_size=POINT_SIZE,
        # title = "Cobweb diagram of $total_n iterations of logistic map with r=$(p[1]) and x0=$(x0)"
    )
    ax.ylabel = L"\mathbb{L}^{%$(n_order)}_{%$(p[1])}(x)"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    ax.yticks = YTICKS
    ax.limits = LIMITS


    ax4 = DDS.bifurcation_diagram!(fig[1,width+1], logistic, x0, p, 1, p, total_n+starting_n, total_n, 1; markersize=POINT_SIZE, ax_aspect=BIF_AX_ASPECT, color=DOT_COLOR)
    ax4.xlabel = L"$r$"
    ax4.ylabel = L"$x_n$"
    ax4.xticks = p
    ax4.xlabelsize = LATEX_FONT_SIZE
    ax4.ylabelsize = LATEX_FONT_SIZE
    ax4.yticks = YTICKS
    ax4.limits = LIMITS


    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_cobweb_diag_example2.png"
    save(file_path, fig)
end

begin
    logistic = DDS.logistic
    LINEWIDTH = 1.2
    POINT_SIZE = 15
    LATEX_FONT_SIZE = 50
    FONTSIZE = 40
    DOT_COLOR = BLUE
    RESOLUTION = (1000, 550)
    AX_ASPECT = 1.5
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
        # title="Trajectory of logistic map for r=$(p[1]), x0=$(x0)"
    )
    ax3.xlabelsize = LATEX_FONT_SIZE
    ax3.ylabelsize = LATEX_FONT_SIZE
    ax3.yticks = YTICKS
    ax3.limits = LIMITS

    ax4 = DDS.bifurcation_diagram!(fig[1,width+1], logistic, x0, p, 1, p, total_n+starting_n, total_n, 1; markersize=POINT_SIZE, ax_aspect=0.32, color=DOT_COLOR)
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
        # title="Trajectory of logistic map for r=$(p[1]), x0=$(x0)"
    )
    ax3.xlabelsize = LATEX_FONT_SIZE
    ax3.ylabelsize = LATEX_FONT_SIZE
    ax3.yticks = YTICKS
    ax3.limits = LIMITS

    ax4 = DDS.bifurcation_diagram!(fig[1,width+1], logistic, x0, p, 1, p, total_n+starting_n, total_n, 1; markersize=POINT_SIZE, ax_aspect=0.32, color=DOT_COLOR)
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