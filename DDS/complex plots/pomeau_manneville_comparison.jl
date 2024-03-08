using DDS
using Plots
using Plots.PlotMeasures: px
using LaTeXStrings
gr(size=(800,600))

pomeau_manneville = DDS.pomeau_manneville
include("plots_scatter_recipe.jl")

begin # shows difference between scatter plots in bifurcation diagrams for specifically chosen values # 19 seconds to render
    total_n = 25000
    last_ns = [11800, 11100]
    arr = []
    l = @layout [a ; b]
    for last_n in last_ns
        x0=0.5
        p = [4.47458]
        p_range = LinRange(BigFloat("4.4745829135"), BigFloat("4.474582916501"), 135)
        # p_range = LinRange(BigFloat("4.4745829135"), BigFloat("4.474582916501"), 165)
        @time plotting_data = DDS.bifurcation_data(pomeau_manneville, x0, p, 1, p_range, total_n, last_n, 1)
        x = [x for (x,y) in plotting_data]
        y = [y for (x,y) in plotting_data]
        index = findfirst(x->x==last_n, last_ns)
        ticks = [4.4745829135, 4.4745829145, 4.4745829155, 4.4745829165]
        p = diff_scatter(x, y, ticks, total_n, last_n, x0, L"$\varepsilon$")
        push!(arr, p)
    end
    Plots.scatter(arr..., layout=l)
    file_path = DDS.FIGURES_DIRECTORY * "pomeau_manneville_bif_comparison_small.png"
    @time savefig(file_path)
    println("-----------")
end

begin # more precise comparison of two Bifurcation diagrams that differ # 86 seconds to render
    total_n = 25000
    last_ns = [11800, 11100]
    arr = []
    l = @layout [a ; b]
    for last_n in last_ns
        x0=0.5
        p = [4.47458]
        p_range = LinRange(BigFloat("4.4745829135"), BigFloat("4.474582916501"), 900)
        @time plotting_data = DDS.bifurcation_data(pomeau_manneville, x0, p, 1, p_range, total_n, last_n, 1)
        x = [x for (x,y) in plotting_data]
        y = [y for (x,y) in plotting_data]
        index = findfirst(x->x==last_n, last_ns)
        ticks = [4.4745829135, 4.4745829145, 4.4745829155, 4.4745829165]
        p = diff_scatter(x, y, ticks, total_n, last_n, x0, L"$\varepsilon$")
        push!(arr, p)
    end
    Plots.scatter(arr..., layout=l)
    file_path = DDS.FIGURES_DIRECTORY * "pomeau_manneville_bif_comparison_small.png"
    @time savefig(file_path)
    println("-----------")
end


# comparing many bif diagrams
gr(size=(1800,1600))

begin # takes about 260 seconds to finish
    total_n = 25000
    last_ns = [1000, 5000, 9000, 11100, 11800, 24999]
    arr = []
    l = @layout [a ; b; c; d; e; f]
    eps_ = BigFloat("0.000000005")
    for last_n in last_ns
        x0=0.5
        p = [4.47458]
        p_range = LinRange(BigFloat("4.4745829135")-eps_, BigFloat("4.474582916501")+eps_, 1000)
        @time plotting_data = DDS.bifurcation_data(pomeau_manneville, x0, p, 1, p_range, total_n, last_n, 1)
        x = [x for (x,y) in plotting_data]
        y = [y for (x,y) in plotting_data]
        index = findfirst(x->x==last_n, last_ns)
        ticks = LinRange(4.4745829135-Float64(eps_), 4.4745829165+Float64(eps_), 4)
        p = diff_scatter(x, y, ticks, total_n, last_n, x0, L"$\varepsilon$")
        push!(arr, p)
    end
    Plots.scatter(arr..., layout=l)
    file_path = DDS.FIGURES_DIRECTORY * "pomeau_manneville_bif_comparison_big.png"
    @time savefig(file_path)
    println("-----------")
end

begin
    total_n = 25000
    last_ns = [1000, 5000, 9000, 11100, 11800, 24999]
    arr = []
    l = @layout [a ; b; c; d; e; f]
    eps_ = BigFloat("0.000000005")
    for last_n in last_ns
        x0=0.5
        p = [4.47458]
        p_range = LinRange(BigFloat("4.4745829135")-eps_, BigFloat("4.474582916501")+eps_, 200)
        @time plotting_data = DDS.bifurcation_data(pomeau_manneville, x0, p, 1, p_range, total_n, last_n, 1)
        x = [x for (x,y) in plotting_data]
        y = [y for (x,y) in plotting_data]
        index = findfirst(x->x==last_n, last_ns)
        ticks = LinRange(4.4745829135-Float64(eps_), 4.4745829165+Float64(eps_), 4)
        p = diff_scatter(x, y, ticks, total_n, last_n, x0, L"$\varepsilon$", title="Total iterations: $total_n, plotting last $last_n iterations")
        push!(arr, p)
    end
    Plots.scatter(arr..., layout=l, size=(500, 1000))
    file_path = DDS.FIGURES_DIRECTORY * "pomeau_manneville_bif_comparison_big.png"
    @time savefig(file_path)
    println("-----------")
end


# trying to create 4 separate plots and use them in subfigure in latex later
begin
    size_ = (800, 238)
    total_n = 25000
    last_ns = [13000, 11100, 5000, 1000]
    eps_ = BigFloat("0.000000005")
    i = 1
    for last_n in last_ns
        x0=0.5
        p = [4.47458]
        p_range = LinRange(BigFloat("4.4745829135")-eps_, BigFloat("4.474582916501")+eps_, 400)
        println(round(p_range[1], digits=10))
        println(round(p_range[end], digits=10))
        @time plotting_data = DDS.bifurcation_data(pomeau_manneville, x0, p, 1, p_range, total_n, last_n, 1)
        x = [x for (x,y) in plotting_data]
        y = [y for (x,y) in plotting_data]
        index = findfirst(x->x==last_n, last_ns)
        ticks = LinRange(4.4745829135-Float64(eps_), 4.4745829165+Float64(eps_), 4)
        x_label = L"\varepsilon"
        y_label = L"T_{%$(total_n-last_n)}^{%$(total_n)}(\mathcal{PM}_{\varepsilon}, %$(x0))"
        p = diff_scatter2(x, y, ticks, x_label, y_label, size_)

        file_path = DDS.FIGURES_DIRECTORY * "pomeau_manneville_bif_comparison_big{$i}.png"
        savefig(file_path)
        i+=1
    end
    println("-----------")
end