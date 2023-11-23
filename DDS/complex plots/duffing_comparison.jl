using DDS
using Plots
using Plots.PlotMeasures
using LaTeXStrings
gr(size=(800,600))

duffing = DDS.duffing
include("plots_scatter_recipe.jl")

begin
    total_n = 15000
    last_ns = [6600, 4400]
    arr = []
    l = @layout [a ; b]
    for last_n in last_ns
        x0 = [-1.0, 0.0]
        p0 = [0, 0.0001]

        x_index = 1
        p_index = 1

        p_range = LinRange(BigFloat("2.45043963"), BigFloat("2.45043964"), 200)
        @time plotting_data, _ = DDS.bifurcation_data(duffing, x0, p0, p_index, p_range, total_n, last_n, x_index)

        x = [x for (x,y) in plotting_data]
        y = [y for (x,y) in plotting_data]
        ticks = LinRange(2.45043963, 2.45043964, 4)
        p = diff_scatter(x, y, ticks, total_n, last_n, x0, L"$a$")
        push!(arr, p)
    end
    scatter(arr..., layout=l)
    file_path = DDS.FIGURES_DIRECTORY * "duffing_bif_comparison_small.png" 
    @time savefig(file_path)
    println("-----------")
end