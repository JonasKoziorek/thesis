using DDS

logistic = DDS.logistic

begin
    LATEX_FONT_SIZE = 30
    FONTSIZE = 20

    fig = Figure(
        resolution = (900, 700),
        fontsize=FONTSIZE,
    )

    x = 0:0.0001:1
    x0=0.6
    p = [3.81]
    total_n = 5
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
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "logistic_map_cobweb_diag_example.png"
    save(file_path, fig)
end