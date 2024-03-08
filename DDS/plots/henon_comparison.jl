using DDS
using Plots
using Plots.PlotMeasures
using LaTeXStrings
gr(size=(800,600))

henon = DDS.henon
include("plots_scatter_recipe.jl")

begin
    total_n = 14000
    last_ns = [5575, 3025]
    arr = []
    l = @layout [a ; b]
    for last_n in last_ns
        x0 = [0.0, 0.0]
        p = [0.0, 0.3]

        x_index = 1
        p_index = 1

        p_range = LinRange(BigFloat("1.22661730"), BigFloat("1.22661735"), 300)
        @time plotting_data = DDS.bifurcation_data(henon, x0, p, p_index, p_range, total_n, last_n, x_index)

        x = [x for (x,y) in plotting_data]
        y = [y for (x,y) in plotting_data]
        ticks = LinRange(1.22661730, 1.22661735, 4)
        p = diff_scatter(x, y, ticks, total_n, last_n, x0, L"$a$")
        push!(arr, p)
    end
    scatter(arr..., layout=l)
    file_path = DDS.FIGURES_DIRECTORY * "henon_bif_comparison_small.png"
    @time savefig(file_path)
    println("-----------")
end