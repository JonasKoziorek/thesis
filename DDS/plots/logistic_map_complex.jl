using DDS
using CairoMakie

logistic = DDS.logistic

begin
    LINEWIDTH = 0.05
    CLINEWIDTH = 5
    POINT_SIZE = 12
    LATEX_FONT_SIZE = 50

    x0 = 0.5

    fig = Figure(
        resolution = (3000, 3800),
        fontsize=40,
    )

    grid = GridLayout()
    upper_grid = GridLayout()
    mid_grid = GridLayout()
    lower_grid1 = GridLayout()
    lower_grid2 = GridLayout()

    grid[1,1] = upper_grid
    grid[2:3,1] = mid_grid
    grid[4,1] = lower_grid1
    grid[5,1] = lower_grid2

    fig.layout[1, 1] = grid

    # upper left trajectory
    total_n = 500
    p = [3.82]
    upper1_1_color = BLUE
    ax3 = DDS.trajectory!(upper_grid[1,1], logistic, x0, p, total_n, 1; 
        ax_aspect=2, 
        markersize=POINT_SIZE,
        xtick_period=100,
        linewidth=LINEWIDTH+0.3, 
        dot_color=upper1_1_color,
        title="Trajectory for r=$(p[1]), x0=$(x0)"
    )
    ax3.xlabelsize = LATEX_FONT_SIZE
    ax3.ylabelsize = LATEX_FONT_SIZE
    upper1_1_param = p[1]


    # upper right trajectory
    total_n = 500
    p = [3.8366]
    upper1_3_color = ORANGE
    ax4 = DDS.trajectory!(upper_grid[1,3], logistic, x0, p, total_n, 1; 
        ax_aspect=2, 
        markersize=POINT_SIZE, 
        xtick_period=100,
        linewidth=LINEWIDTH+0.3, 
        dot_color = upper1_3_color,
        title="Trajectory for r=$(p[1]), x0=$(x0)"
    )
    ax4.xlabelsize = LATEX_FONT_SIZE
    ax4.ylabelsize = LATEX_FONT_SIZE
    upper1_3_param = p[1]


    # main bif diagram
    total_n = 5000
    last_n = 500
    p = [4.5]
    p_range = LinRange(3.81, 3.87, 2000)
    ax1 = DDS.bifurcation_diagram!(
        mid_grid[1,1], logistic, x0, p, 1, p_range, total_n, last_n;
        title="Bifurcation diagram for $total_n total iterations, plotting last $last_n interations, x0=$x0",
        ax_aspect=2,
        xticks = LinRange(3.81, 3.87, 10),
    )
    ax1.xlabel = L"r"
    ax1.ylabel = L"{$ x_{n}: n \in [%$(total_n - last_n), %$total_n]$}"
    ax1.xlabelsize = LATEX_FONT_SIZE
    ax1.ylabelsize = LATEX_FONT_SIZE
    left_boundary = 3.827
    right_boundary = 3.830
    lines!(ax1, [upper1_1_param, upper1_1_param], [0, 1], color=upper1_1_color, linewidth = CLINEWIDTH)
    lines!(ax1, [upper1_3_param, upper1_3_param], [0, 1], color=upper1_3_color, linewidth = CLINEWIDTH)
    lines!(ax1, [left_boundary, right_boundary, right_boundary, left_boundary, left_boundary], [0, 0, 1, 1, 0], color=RED, linewidth = CLINEWIDTH+2)


    # intermitten trajectory
    total_n = 8500
    p = [3.82842]
    lower1_1_color = GREEN
    ax5 = DDS.trajectory!(lower_grid2[1,1], logistic, x0, p, total_n, 1; 
        ax_aspect=4,
        markersize=POINT_SIZE, 
        xtick_period=500, 
        linewidth=LINEWIDTH,
        dot_color = lower1_1_color,
        title="Trajectory for r=$(p[1]), x0=$(x0)"
    )
    ax5.xlabelsize = LATEX_FONT_SIZE
    ax5.ylabelsize = LATEX_FONT_SIZE
    lower1_1_param = p[1]


    # lower bif diagram
    total_n = 5000
    last_n = 500
    p = [4.5]
    p_range = LinRange(left_boundary, right_boundary, 2000)
    ax2 = DDS.bifurcation_diagram!(
        lower_grid1[1,1], logistic, x0, p, 1, p_range, total_n, last_n;
        title="Bifurcation diagram for $total_n total iterations, plotting last $last_n interations, x0=$x0",
        ax_aspect=4,
        xticks = LinRange(left_boundary, right_boundary, 8),
    )
    ax2.xlabel = L"r"
    ax2.ylabel = L"x"
    ax2.xlabelsize = LATEX_FONT_SIZE
    ax2.ylabelsize = LATEX_FONT_SIZE
    lines!(ax2, [lower1_1_param, lower1_1_param], [0, 1], color=lower1_1_color, linewidth = CLINEWIDTH)
    lines!(ax2, [left_boundary, right_boundary, right_boundary, left_boundary, left_boundary], [0, 0, 1, 1, 0], color=RED, linewidth=CLINEWIDTH+2)

    for (label, layout) in zip(["(a)", "(b)", "(c)", "(d)", "(e)"], [upper_grid[1,1], upper_grid[1,3], grid[2:3, 1], lower_grid1, lower_grid2])
        Label(layout[1, 1, Bottom()], label,
            padding = (0, 0, 0, 120),
            halign = :center)
    end

    rowgap!(grid, 100)
    colgap!(upper_grid, -600)

    display(fig)
    file_path = DDS.FIGURES_DIRECTORY * "logistic_complex.png"
    save(file_path, fig)
end

begin
    CLINEWIDTH = 5
    LATEX_FONT_SIZE = 30

    x0 = 0.5

    fig = Figure(
        resolution = (900, 500),
        fontsize=20,
    )

    total_n = 2000
    last_n = 200
    x0 = 0.5
    p = [4.5]
    p_range = LinRange(3.81, 3.87, 2000)
    ax = DDS.bifurcation_diagram!(
        fig[1,1], logistic, x0, p, 1, p_range, total_n, last_n;
        ax_aspect=2,
        xticks = LinRange(3.81, 3.87, 6),
    )
    ax.xlabel = L"r"
    ax.ylabel = L"\mathcal{T}_{%$(total_n-last_n)}^{%$(total_n)}(\mathcal{L}_{r}, %$(x0))"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    left_boundary = 3.827
    right_boundary = 3.830
    lines!(ax, [left_boundary, right_boundary, right_boundary, left_boundary, left_boundary], [0.1, 0.1, 1, 1, 0.1], color="#FF0000", linewidth = 3)

    display(fig)

    file_path = "/mnt/c/Users/pepaz/Documents/SSZ/Prezentace/images/breakpoint.png"
    save(file_path, fig)
end