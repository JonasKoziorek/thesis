using DDS

pomeau_manneville = DDS.pomeau_manneville

begin # showing intermittency
    x0 = 0.5
    p = [0.001]
    N = 500
    DDS.timeseries(pomeau_manneville, x0, p, N, 1; markersize=5.0)
end

begin # showing break point in the bifurcation diagram
    total_n = 1000
    last_n = 50

    x0 = 0.5
    p = [0.001]
    p_range = -1:0.001:6
    DDS.bifurcation_diagram(pomeau_manneville, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of Pomeau-manneville map\n$total_n iterations, sampling last $last_n")
end

begin # showing another break point
    total_n = 1000
    last_n = 50

    x0 = 0.5
    p = [4.5]
    p_range = 4.3:0.00005:4.7
    DDS.bifurcation_diagram(pomeau_manneville, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of Pomeau-manneville map\n$total_n iterations, sampling last $last_n")
end

begin # this is for closer look at the break point
    total_n = 1000
    last_n = 50

    x0 = 0.5
    p = [4.5]
    step = 1e-8
    p_range = 4.4744:step:4.4747
    DDS.bifurcation_diagram(pomeau_manneville, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of Pomeau-manneville map\n$total_n iterations, sampling last $last_n", markersize=0.5)
end

begin # showing intermittency at the break point which spans circa 1000 iters psedo stable behavior repeatedly
    total_n = 8500

    x0 = 0.5
    p = [4.47458]
    DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=500, 
        linewidth=0.05, 
        title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
    )
end

begin # showing intermittency at the break point which spans circa 2000 iters psedo stable behavior repeatedly
    total_n = 13000

    x0 = 0.5
    p = [4.4745824]
    DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=1000, 
        linewidth=0.05, 
        title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
    )
end

begin # showing intermittency at the break point which spans circa 4000 iters psedo stable behavior repeatedly
    total_n = 16000

    x0 = 0.5
    p = [4.4745828]
    DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=1000, 
        linewidth=0.05, 
        title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
    )
end

begin # showing intermittency at the break point which spans circa 6000 iters psedo stable behavior repeatedly
    total_n = 18000

    x0 = 0.5
    p = [4.47458285]
    DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=1000, 
        linewidth=0.05, 
        title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
    )
end

begin # showing intermittency at the break point which spans circa 10000 iters psedo stable behavior repeatedly
    total_n = 20000

    x0 = 0.5
    p = [4.4745829]
    DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=1000, 
        linewidth=0.05, 
        title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
    )
end

begin # showing intermittency at the break point which spans circa 15000 iters psedo stable behavior repeatedly
    total_n = 30000

    x0 = 0.5
    p = [4.474582915]
    DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=5000, 
        linewidth=0.05,
        title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
    )
end

begin # produce two plots and shows difference between sampling last 10000 and 12000
    total_n = 25000
    last_n = 10000

    x0 = 0.5
    p = [4.474582915]
    step = 1e-9
    display(DDS.bifurcation_diagram(pomeau_manneville, x0, p, 1, p, total_n, last_n; title="Bifurcation diagram trace for parameter $(p[1])\n$total_n iterations, sampling last $last_n", markersize=7))

    last_n = 12000
    display(DDS.bifurcation_diagram(pomeau_manneville, x0, p, 1, p, total_n, last_n; title="Bifurcation diagram trace for parameter $(p[1])\n$total_n iterations, sampling last $last_n", markersize=7))
end


begin # other type different type of intermittency at the break point near zero
    total_n = 100000

    x0 = 0.5
    p = [-0.00001]
    # p = [4.6196]
    DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=10000,
        linewidth=0.5,
        title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
    )
end

begin # interesting evolution around 3
    total_n = 1000

    x0 = 0.5
    p = [3.000219]
    DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=1000,
        linewidth=0.5,
        title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
    )
end


# _______________________________ testing _____________________________________________
begin
    total_n = 1000
    last_n = 50

    x0 = 0.5
    p = [0.001]
    step = 1e-9
    p_range = 2.999995:step:3.000005
    DDS.bifurcation_diagram(pomeau_manneville, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of Pomeau-manneville map\n$total_n iterations, sampling last $last_n")
end

begin # 12 plots that show how "chaos" or some dynamics is born after leaving last stable point 3, eg. looks at the neighborhood of 3 from the right
    total_n = 10000

    x0 = 0.5
    for i = 12:-1:1
        p = [3.0 + 10.0^(-i)]
        plot = DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
            ax_aspect=5, 
            markersize=7.0,
            resolution=(2000,500), 
            xtick_period=1000,
            linewidth=0.5,
            title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
        )
        display(plot)
    end
end

begin
    total_n = 1000
    last_n = 50

    x0 = 0.5
    p = [0.001]
    step = 1e-7
    p_range = 46.978:step:46.9785
    DDS.bifurcation_diagram(pomeau_manneville, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of Pomeau-manneville map\n$total_n iterations, sampling last $last_n")
end

begin
    total_n = 1000

    x0 = 0.5
    p = [46.9782]
    DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=500, 
        linewidth=0.05, 
        title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
    )
end

begin
    total_n = 2000
    last_n = 500

    x0 = 0.5
    p = [4.474582915]
    step = 1e-9
    p_range = 4.474582911:step:4.474582919

    DDS.bifurcation_diagram(pomeau_manneville, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of Pomeau-manneville map\n$total_n iterations, sampling last $last_n", markersize=0.5)
end

begin
    total_n = 3000
    last_n = 150

    x0 = 0.5
    p = [4.474]
    step = 1e-9
    # p_range = 4.474582911:step:4.474582999
    p_range = 4.474578:step:4.474582
    display(DDS.bifurcation_diagram(pomeau_manneville, x0, p, 1, p_range, total_n, last_n))
end

begin
    total_n = 8000
    last_n = 4000

    x0 = 0.5
    p = [4.5]
    step = 1e-5
    p_range = 4.47458:2*step:4.4747
    DDS.bifurcation_diagram(pomeau_manneville, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of Pomeau-manneville map\n$total_n iterations, sampling last $last_n", markersize=1.8)
end

begin
    total_n = 9400

    x0 = 0.5
    p = [4.47458265]
    # p_range = 4.474582911:step:4.474582999
    DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=500, 
        linewidth=0.05, 
        title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
    )
end

begin
    # https://github.com/MakieOrg/Makie.jl/issues/931
    total_n = 8000
    last_ns = [6000, 3000, 1000, 500, 100, 50]

    for last_n in last_ns
        fig = DDS.Figure()
        x0 = 0.5
        p = [4.47458265]
        step = 1e-9
        # p_range = 4.47458:step:4.4746
        p_range = 4.47458264:step:4.47458266
        ax = DDS.bifurcation_diagram!(fig[1,1], pomeau_manneville, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of Pomeau-manneville map\n$total_n iterations, sampling last $last_n", markersize=1.8)
        # ax.limits = (scale*4.47458264, scale*4.47458266, nothing, nothing)
        display(fig)
    end
end

begin
    total_n = 8000
    last_ns = [6000, 3000, 1000, 500, 100, 50]

    for last_n in last_ns
        fig = DDS.Figure()
        x0 = 0.5
        p = [4.47458]
        step = 1e-9
        # p_range = 4.47458:step:4.4746
        # p_range = BigFloat("4.47457"):step:4.4746
        p_range = BigFloat("4.474582914"):step:BigFloat("4.474582916")
        ax = DDS.bifurcation_diagram!(fig[1,1], pomeau_manneville, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of Pomeau-manneville map\n$total_n iterations, sampling last $last_n", markersize=1.8)
        # ax.limits = (BigFloat("4.47458264"), BigFloat("4.47458266"), nothing, nothing)
        # ax.limits = (BigFloat("4.4745825"), BigFloat("4.4745827"), nothing, nothing)
        display(fig)
    end
end


begin
    total_n = 30000

    x0 = 0.5
    # p = [4.47458291]
    step_ =1/5* 1e-8
    for p in BigFloat("4.4745829135"):step_:BigFloat("4.4745829165")
        # p_range = 4.474582911:step:4.474582999
        display(DDS.timeseries(pomeau_manneville, x0, p, total_n, 1; 
            ax_aspect=5, 
            markersize=7.0, 
            resolution=(2000,500), 
            xtick_period=2000, 
            linewidth=0.05, 
            title="Pomeau-Manneville map for ϵ=$(p[1]), x0=$(x0)"
        ))
    end
end

begin
    total_n = 8000
    last_n = 1000

    x0 = 0.5
    p = [4.47458]
    step = 1e-6
    p_range = 4.47458:step:4.4746
    DDS.bifurcation_diagram(pomeau_manneville, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of Pomeau-manneville map\n$total_n iterations, sampling last $last_n", markersize=1.8)
end