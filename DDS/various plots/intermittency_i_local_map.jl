using DDS
using CairoMakie
using Luxor
using Luxor: Point, text
using MathTeXEngine
using LaTeXStrings

file_path = DDS.FIGURES_DIRECTORY * "intermittency_i_local_map.png"

function local_map(x, p)
    x = x[1]
    ϵ = p[1]
    return ϵ+x+x^2
end

begin
    x = -0.5:0.0001:0.5
    x2 = -0.6:0.0001:0.6
    x0 = -0.5
    p1 = [0.15]
    p2 = [0.0]
    p3 = [-0.15]
    fig = Figure()
    ax = Axis(
        fig[1,1],
        xlabel=L"x_{n}",
        ylabel=L"x_{n+1}",
        xlabelsize = 35,
        ylabelsize = 35,
        )
    hidedecorations!(ax, grid=true, label=false)
    lines!(ax, x, local_map.(x, p1), color=:black) # above line
    lines!(ax, x, local_map.(x, p2), color=:black) # touching line
    lines!(ax, x, local_map.(x, p3), color=:black) # below line
    lines!(ax, x2, x2, color=:black, linestyle=:dash)

    bif1 = (0, 0)
    scatter!(ax, [bif1], color=DDS.RED) # above line

    bif2 = (sqrt(-p3[1]), sqrt(-p3[1]))
    bif3 = (-sqrt(-p3[1]), -sqrt(-p3[1]))
    scatter!(ax, [bif2, bif3], color=DDS.BLUE) # above line
    display(fig)


    save(file_path, fig)
end

@png begin
# @draw begin
  origin()
    img = readpng("Figures/intermittency_i_local_map.png")
    w = img.width
    h = img.height
    # scale(0.4, 0.4)
    placeimage(img, Point(-w/2, -h/2), 1.0)
    sethue("black")
    setline(4)
    fontsize(26)
    x = -300
    y = 110
    text(L"p < p_{B}", Point(x, y+50), halign=:center, valign=:baseline)
    text(L"p = p_{B}", Point(x, y), halign=:center, valign=:baseline)
    text(L"p > p_{B}", Point(x, y-50), halign=:center, valign=:baseline)
# end 800 600
end 800 600 file_path