using DDS
using CairoMakie
using Luxor

function custom_timeseries!(ax, func, x0, params, total_n; linewidth=0.05, markersize=7, dot_color=:black, line_color=:black)
    data = DDS.iterate(func, x0, params, total_n)
    x = 1:total_n
    y = [i[1] for i in data] 
    CairoMakie.lines!(ax, x, y; color=line_color, linewidth=linewidth)
    CairoMakie.scatter!(ax, x, y, marker = :circle, markersize = markersize, color = dot_color)
end

begin
    pomeau_manneville = DDS.pomeau_manneville
    LATEX_FONT_SIZE = 30
    FONTSIZE = 20

    eps = 1e-8

    fig = Figure(
        resolution = (2000, 500),
        fontsize=FONTSIZE,
    )

    total_n = 17000
    ax = Axis(fig[1,1], 
            # xlabel=L"n", 
            # ylabel=L"x_{n}",
            xticks=LinRange(0,total_n, 11),
            title="title"
        )
    ax.aspect = 5

    x0 = 0.5
    p = [4.47458285]
    custom_timeseries!(
        ax, pomeau_manneville, x0, p, total_n;
        markersize=7.0, 
        linewidth=0.04,
        dot_color=RED,
        line_color=:black,
    )

    x0 = 0.5
    p = [4.47458285+4*eps]
    custom_timeseries!(
        ax, pomeau_manneville, x0, p, total_n;
        markersize=7.0, 
        linewidth=0.04,
        dot_color=BLUE,
        line_color=:black,
    )

    display(fig)


    file_path = DDS.FIGURES_DIRECTORY * "bif_diag_ambiguity_creation_sketch.png"
    save(file_path, fig)
end


@draw begin
  origin()
    img = readpng("Figures/bif_diag_ambiguity_creation_sketch.png")
    w = img.width
    h = img.height
    # scale(0.4, 0.4)
    placeimage(img, Point(-w/2, -h/2), 1.0)
    sethue("black")
    setline(4)
    p1 = Point(-250, 90)
    p2 = Point(0, 90)
    Luxor.arrow(p1, p2,arrowheadlength=20)
    Luxor.arrow(p2, p1,arrowheadlength=20)

    p1 = Point(0, 90)
    p2 = Point(350, 90)
    Luxor.arrow(p1, p2,arrowheadlength=20)
    Luxor.arrow(p2, p1,arrowheadlength=20)
    sethue(ORANGE)
    # circle(Point(-250, 90), 10, :fill)
    # circle(Point(0, 90), 10, :fill)
end 2000 500