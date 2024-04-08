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
        resolution = (1000, 330),
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
        # title="Trajectory of Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)",
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
    LATEX_FONT_SIZE = 35
    FONTSIZE = 25

    fig = Figure(
        resolution = (1000, 1000),
        fontsize=FONTSIZE,
    )

    x_range = (low, high)
    x = LinRange(x_range..., 2000)
    x0=0.5
    p = [4.47458]
    total_n = 461
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
    ax.xticks = round.(LinRange(x_range..., 4), digits=3)


    ax.xlabel = L"x"
    ax.ylabel = L"\mathcal{P}_{%$(p[1])}^{%$(n_order)}(x)"

    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    lines!(ax, [left_, right_, right_, left_, left_], [low, low, high, high, low], color=RED, linewidth=3)


    x = LinRange(0.13, 0.17, 2000)
    x0=0.5
    p = [4.47458]
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

    ax.xlabel = L"x"
    ax.ylabel = L"\mathcal{P}_{%$(p[1])}^{%$(n_order)}(x)"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    lines!(ax, [left_, right_, right_, left_, left_], [low, low, high, high, low], color=RED, linewidth=3)


    total_n = 520
    starting_n = 0
    index_x = 1
    nth_map = DDS.nth_composition(pomeau_manneville, 2)
    ax = DDS.trajectory!(fig[2,1:2], nth_map, x0, p, total_n, index_x;
        starting_n=starting_n,
        ax_aspect=2,
        markersize=POINT_SIZE, 
        xtick_period=50, 
        linewidth=LINEWIDTH, 
        line_color = :black,
        dot_color = BLUE,
    )
    ax.aspect = 2.5

    ax.xlabel = L"n"
    ax.ylabel = L"\mathcal{T}_{%$(starting_n)}^{%$(starting_n+total_n)}(\mathcal{P}_{%$(p[1])}^{%$(n_order)}, %$(x0))"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE
    lines!(ax, [(40, 0), (461, 0), (461, 1), (40, 1), (40, 0) ],color=RED, linewidth=3)


    for (label, layout) in zip(["(a)", "(b)", "(c)"], [fig[1,1], fig[1,2], fig[2,1:2]])
        Label(layout[1, 1, Bottom()], label,
            padding = (0, 0, 0, 80),
            halign = :center)
    end


    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * NAME2
    save(file_path, fig)

Luxor.@png begin
  Luxor.origin()
    img = readpng(file_path)
    w = img.width
    h = img.height
    scalar = 0.5
    scale(scalar, scalar)
    placeimage(img, Point(-w/2, -h/2), 1.0)
    sethue(RED)
    setline(3)
    # first connection
    rect1_ne = Point(-300,-800)
    rect1_se = Point(-314,-770)

    rect2_nw = Point(290, -930)
    rect2_sw = Point(285, -315)
    line(rect1_se, rect2_sw, :stroke)
    line(rect1_ne, rect2_nw, :stroke)

    # second connection
    rect2_se = Point(900, -320)

    rect3_nw = Point(-540, 80)
    rect3_ne = Point(710, 80)
    # line(rect3_nw, rect2_sw, :stroke)
    # line(rect3_ne, rect2_se, :stroke)
end 1000 1000 file_path
end

# begin
#     NAME2 = "type_one_intermittency_example2.png"

#     # red window
#     low = 0.151
#     high = 0.1545
#     left_ = 0.151
#     right_ = 0.1543

#     LINEWIDTH = 0.5
#     POINT_SIZE = 6
#     LATEX_FONT_SIZE = 30
#     FONTSIZE = 20

#     fig = Figure(
#         resolution = (1200, 600),
#         fontsize=FONTSIZE,
#     )

#     x_range = (low, high)
#     x = LinRange(x_range..., 2000)
#     x0=0.5
#     p = [4.47458]
#     total_n = 461
#     n_order = 2
#     starting_x = 40
#     ax = DDS.plot_cobweb!(
#         fig[1,2],
#         pomeau_manneville, x0, x, p, total_n, n_order, starting_x;
#         ax_aspect=1,
#         cobweb_line_color=BLUE,
#         last_point_color=BLUE, 
#         cobweb_line_size=2.0,
#         function_line_size=2.5,
#         identity_line_size=2.5,
#     )
#     ax.xticks = LinRange(x_range..., 6)


#     ax.xlabel = L"x"
#     ax.ylabel = L"\mathcal{P}_{%$(p[1])}^{%$(n_order)}(x)"

#     ax.xlabelsize = LATEX_FONT_SIZE
#     ax.ylabelsize = LATEX_FONT_SIZE
#     lines!(ax, [left_, right_, right_, left_, left_], [low, low, high, high, low], color=RED, linewidth=3)


#     x = LinRange(0.13, 0.17, 2000)
#     x0=0.5
#     p = [4.47458]
#     total_n = 472
#     n_order = 2
#     starting_x = 38
#     ax = DDS.plot_cobweb!(
#         fig[1,1],
#         pomeau_manneville, x0, x, p, total_n, n_order, starting_x;
#         ax_aspect=1, 
#         cobweb_line_color=BLUE, 
#         last_point_color=BLUE,
#         cobweb_line_size=2.5
#     )

#     ax.xlabel = L"x"
#     ax.ylabel = L"\mathcal{P}_{%$(p[1])}^{%$(n_order)}(x)"
#     ax.xlabelsize = LATEX_FONT_SIZE
#     ax.ylabelsize = LATEX_FONT_SIZE
#     lines!(ax, [left_, right_, right_, left_, left_], [low, low, high, high, low], color=RED, linewidth=3)


#     for (label, layout) in zip(["(a)", "(b)"], [fig[1,1], fig[1,2]])
#         Label(layout[1, 1, Bottom()], label,
#             padding = (0, 0, 0, 80),
#             halign = :center)
#     end


#     display(fig)

#     file_path = DDS.FIGURES_DIRECTORY * NAME2
#     save(file_path, fig)

# # @draw begin
# Luxor.@png begin
#   Luxor.origin()
#     img = readpng(file_path)
#     w = img.width
#     h = img.height
#     scalar = 0.5
#     scale(scalar, scalar)
#     placeimage(img, Point(-w/2, -h/2), 1.0)
#     sethue(RED)
#     setline(3)
#     lower_right = Point(280, 275)
#     upper_right = Point(280, -525)
#     upper_left = Point(-400,-355)
#     lower_left = Point(-404,-318)
#     line(lower_left, lower_right, :stroke)
#     line(upper_left, upper_right, :stroke)
# # end 1200 600
# end 1200 600 file_path
# end