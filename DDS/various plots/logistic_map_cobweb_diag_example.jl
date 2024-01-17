using DDS

logistic = DDS.logistic

begin
    LATEX_FONT_SIZE = 40
    FONTSIZE = 30
    RESOLUTION = (900, 700)

    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )

    x = 0:0.0001:1
    x0=0.6
    p = [3.6]
    total_n = 50
    n_order = 2

    ax = DDS.plot_cobweb!(
        fig[1,1], logistic, x0, x, p, total_n, n_order;
        ax_aspect=1,
        identity_line_color=:black,
        function_line_color=:black,
        cobweb_line_color=BLUE,
        last_point_color=:black,
        # title = "Cobweb diagram of $total_n iterations of logistic map with r=$(p[1]) and x0=$(x0)"
    )
    ax.ylabel = L"\mathbb{L}^{%$(n_order)}_{%$(p[1])}"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_cobweb_diag_example1.png"
    save(file_path, fig)

    fig = Figure(
        resolution = RESOLUTION,
        fontsize=FONTSIZE,
    )

    x = 0:0.0001:1
    x0=0.6
    p = [3.81]
    total_n = 50
    n_order = 2

    ax = DDS.plot_cobweb!(
        fig[1,1], logistic, x0, x, p, total_n, n_order;
        ax_aspect=1,
        identity_line_color=:black,
        function_line_color=:black,
        cobweb_line_color=BLUE,
        last_point_color=:black,
        # title = "Cobweb diagram of $total_n iterations of logistic map with r=$(p[1]) and x0=$(x0)"
    )
    ax.ylabel = L"\mathbb{L}^{%$(n_order)}_{%$(p[1])}"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_cobweb_diag_example2.png"
    save(file_path, fig)
end