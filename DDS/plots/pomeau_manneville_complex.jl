using DDS
using CairoMakie

pomeau_manneville = DDS.pomeau_manneville

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
    p = [4.45]
    upper1_1_color = BLUE
    ax3 = DDS.trajectory!(upper_grid[1,1], pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=2, 
        markersize=POINT_SIZE,
        xtick_period=100,
        linewidth=LINEWIDTH+0.3, 
        dot_color=upper1_1_color,
        title="Trajectory for ϵ=$(p[1]), x0=$(x0)"
    )
    ax3.xlabelsize = LATEX_FONT_SIZE
    ax3.ylabelsize = LATEX_FONT_SIZE
    upper1_1_param = p[1]


    # upper right trajectory
    total_n = 500
    p = [4.56]
    upper1_3_color = ORANGE
    ax4 = DDS.trajectory!(upper_grid[1,3], pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=2, 
        markersize=POINT_SIZE, 
        xtick_period=100,
        linewidth=LINEWIDTH+0.3, 
        dot_color = upper1_3_color,
        title="Trajectory for ϵ=$(p[1]), x0=$(x0)"
    )
    ax4.xlabelsize = LATEX_FONT_SIZE
    ax4.ylabelsize = LATEX_FONT_SIZE
    upper1_3_param = p[1]


    # main bif diagram
    total_n = 3000
    last_n = 300
    p = [4.5]
    p_range = LinRange(4.3, 4.7, 2000)
    # p_range = 4.3:0.00001:4.7
    ax1 = DDS.bifurcation_diagram!(
        mid_grid[1,1], pomeau_manneville, x0, p, 1, p_range, total_n, last_n;
        title="Bifurcation diagram for $total_n total iterations, plotting last $last_n interations, x0=$x0",
        ax_aspect=2,
        xticks = LinRange(4.3, 4.7, 10)
    )
    ax1.xlabel = L"\varepsilon"
    ax1.ylabel = L"{$ x_{n}: n \in [%$(total_n - last_n), %$total_n]$}"
    ax1.xlabelsize = LATEX_FONT_SIZE
    ax1.ylabelsize = LATEX_FONT_SIZE
    left_boundary = 4.470
    right_boundary = 4.4782
    lines!(ax1, [upper1_1_param, upper1_1_param], [0, 1], color=upper1_1_color, linewidth = CLINEWIDTH)
    lines!(ax1, [upper1_3_param, upper1_3_param], [0, 1], color=upper1_3_color, linewidth = CLINEWIDTH)
    lines!(ax1, [left_boundary, right_boundary, right_boundary, left_boundary, left_boundary], [0, 0, 1, 1, 0], color=RED, linewidth = CLINEWIDTH+2)


    # intermitten trajectory
    total_n = 8500
    p = [4.47458]
    lower1_1_color = GREEN
    ax5 = DDS.trajectory!(lower_grid2[1,1], pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=4,
        markersize=POINT_SIZE, 
        xtick_period=500, 
        linewidth=LINEWIDTH, 
        dot_color = lower1_1_color,
        title="Trajectory for ϵ=$(p[1]), x0=$(x0)"
    )
    ax5.xlabelsize = LATEX_FONT_SIZE
    ax5.ylabelsize = LATEX_FONT_SIZE
    lower1_1_param = p[1]


    # lower bif diagram
    total_n = 3000
    last_n = 300
    p = [4.5]
    p_range = LinRange(left_boundary, right_boundary, 2000)
    ax2 = DDS.bifurcation_diagram!(
        lower_grid1[1,1], pomeau_manneville, x0, p, 1, p_range, total_n, last_n;
        title="Bifurcation diagram for $total_n total iterations, plotting last $last_n interations, x0=$x0",
        ax_aspect=4,
        xticks = LinRange(left_boundary, right_boundary, 10)
    )
    ax2.xlabel = L"\varepsilon"
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
    file_path = DDS.FIGURES_DIRECTORY * "pomeau_manneville_complex.png"
    save(file_path, fig)
end