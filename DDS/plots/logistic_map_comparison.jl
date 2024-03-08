using DDS
using Plots
using Plots.PlotMeasures
using LaTeXStrings
gr(size=(800,600))

logistic = DDS.logistic
include("plots_scatter_recipe.jl")

begin
    total_n = 18000
    last_ns = [8200, 7000]
    arr = []
    l = @layout [a ; b]
    for last_n in last_ns
        x0=0.5
        p = [3.82842710]
        p_range = LinRange(BigFloat("3.828427110"), BigFloat("3.828427115"), 100)
        @time plotting_data = DDS.bifurcation_data(logistic, x0, p, 1, p_range, total_n, last_n, 1)
        x = [x for (x,y) in plotting_data]
        y = [y for (x,y) in plotting_data]
        ticks = LinRange(3.828427110, 3.828427115, 4)
        p = diff_scatter(x, y, ticks, total_n, last_n, x0, L"$r$")
        push!(arr, p)
    end
    scatter(arr..., layout=l)
    file_path = DDS.FIGURES_DIRECTORY * "logistic_bif_comparison_small.png"
    @time savefig(file_path)
    println("-----------")
end