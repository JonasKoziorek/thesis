using DDS
using CairoMakie
using Luxor
using Luxor: Point

pomeau_manneville = DDS.pomeau_manneville

begin
    LINEWIDTH = 0.5
    POINT_SIZE = 6
    LATEX_FONT_SIZE = 30
    FONTSIZE = 20

    fig = Figure(
        resolution = (1000, 400),
        fontsize=FONTSIZE,
    )

    total_n = 5500

    x0 = 0.5
    p = [4.47458]
    index_x = 1
    ax = DDS.trajectory!(fig[1,1], pomeau_manneville, x0, p, total_n, index_x;
        ax_aspect=4,
        markersize=POINT_SIZE, 
        xtick_period=500, 
        linewidth=0.04, 
        line_color = :black,
        dot_color = BLUE,
        title="Trajectory of Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)",
    )
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "type_one_intermittency_example1.png"
    save(file_path, fig)
end

begin
    NAME2 = "type_one_intermittency_example2.png"

    # red window
    low = 0.151
    high = 0.1545
    left_ = 0.151
    right_ = 0.1543

    LINEWIDTH = 0.5
    POINT_SIZE = 6
    LATEX_FONT_SIZE = 30
    FONTSIZE = 20

    fig = Figure(
        resolution = (1200, 600),
        fontsize=FONTSIZE,
    )

    x = LinRange(0.151, 0.1545, 2000)
    x0=0.5
    p = [4.47458]
    total_n = 460
    n_order = 2
    starting_x = 40
    ax = DDS.plot_cobweb!(
        fig[1,2],
        pomeau_manneville, x0, x, p, total_n, n_order, starting_x;
        ax_aspect=1,
        cobweb_line_color=BLUE,
        last_point_color=BLUE, 
        cobweb_line_size=2.0,
        function_line_size=2.5,
        identity_line_size=2.5,
    )
    ax.xticks = LinRange(0.151, 0.1545, 6)
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    lines!(ax, [left_, right_, right_, left_, left_], [low, low, high, high, low], color=RED, linewidth=3)


    x = LinRange(0.13, 0.17, 2000)
    x0=0.5
    p = [4.474580]
    total_n = 472
    n_order = 2
    starting_x = 38
    ax = DDS.plot_cobweb!(
        fig[1,1],
        pomeau_manneville, x0, x, p, total_n, n_order, starting_x;
        ax_aspect=1, 
        cobweb_line_color=BLUE, 
        last_point_color=BLUE,
        cobweb_line_size=2.5
    )
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    lines!(ax, [left_, right_, right_, left_, left_], [low, low, high, high, low], color=RED, linewidth=3)


    for (label, layout) in zip(["(a)", "(b)"], [fig[1,1], fig[1,2]])
        Label(layout[1, 1, Bottom()], label,
            padding = (0, 0, 0, 80),
            halign = :center)
    end


    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * NAME2
    save(file_path, fig)

# @draw begin
@png begin
  origin()
    img = readpng(file_path)
    w = img.width
    h = img.height
    placeimage(img, Point(-w/2, -h/2), 1.0)
    sethue(RED)
    setline(3)
    lower_right = Point(137, 137)
    upper_right = Point(135, -263)
    upper_left = Point(-200,-175)
    lower_left = Point(-204,-158)
    line(lower_left, lower_right, :stroke)
    line(upper_left, upper_right, :stroke)
# end 1200 600
end 1200 600 file_path
end