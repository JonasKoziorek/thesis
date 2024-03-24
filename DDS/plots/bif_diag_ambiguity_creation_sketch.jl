using DDS
using CairoMakie
using Luxor
using Luxor: Point, text
using MathTeXEngine
using LaTeXStrings

function custom_trajectory!(ax, func, x0, params, total_n; linewidth=0.05, markersize=7, dot_color=:black, line_color=:black)
    data = DDS.iterate(func, x0, params, total_n)
    x = 0:total_n
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
        resolution = (1000, 250),
        fontsize=FONTSIZE,
    )

    total_n = 17000
    ax = Axis(fig[1,1], 
            # xlabel=L"n", 
            # ylabel=L"x_{n}",
            xticks=LinRange(0,total_n, 6),
            # title="title"
        )
    ax.aspect = 5
    ax.xlabel = L"n"
    ax.ylabel = L"x_{n}"
    ax.ylabelsize = ax.xlabelsize = 30

    x0 = 0.5
    p = [4.47458285]
    custom_trajectory!(
        ax, pomeau_manneville, x0, p, total_n;
        markersize=5.0, 
        linewidth=0.00,
        dot_color=RED,
        line_color=:black,
    )

    x0 = 0.5
    p = [4.47458285+4*eps]
    custom_trajectory!(
        ax, pomeau_manneville, x0, p, total_n;
        markersize=5.0, 
        linewidth=0.00,
        dot_color=BLUE,
        line_color=:black,
    )

    display(fig)


    file_path = DDS.FIGURES_DIRECTORY * "bif_diag_ambiguity_creation_sketch.png"
    save(file_path, fig)

# @draw begin
@png begin
  origin()
    img = readpng(DDS.FIGURES_DIRECTORY * "bif_diag_ambiguity_creation_sketch.png")
    w = img.width
    h = img.height
    scalar = 0.5
    scale(scalar, scalar)
    placeimage(img, Point(-w/2, -h/2), 1.0)
    sethue("black")
    setline(4)
    height_ = 15
    mid = 50
    p1 = Point(-200+mid, height_)
    p2 = Point(mid, height_)
    Luxor.arrow(p1, p2,arrowheadlength=20)
    Luxor.arrow(p2, p1,arrowheadlength=20)

    p1 = Point(mid, height_)
    p2 = Point(mid+280, height_)
    Luxor.arrow(p1, p2,arrowheadlength=20)
    Luxor.arrow(p2, p1,arrowheadlength=20)

    height_ = 5
    fontsize(46)
    x = -120
    y = height_
    text(L"a", Point(x, y), halign=:center, valign=:baseline)

    x = 35
    y = height_
    text(L"b", Point(x, y), halign=:center, valign=:baseline)

    x = 300
    y = height_
    text(L"c", Point(x, y), halign=:center, valign=:baseline)
# end 1000 250
end 900 250 file_path

end