# map from article A new type of intermittent transition to chaos by A S Pikovsky

using DDS

pikovsky = DDS.pikovsky

begin # ploting second composition
    x = -1:0.0001:1 
    p = [0.4]
    total_n = 2
    DDS.plot_nth_composition(pikovsky, x, p, total_n; ax_aspect=1)
end

begin
    x = -1:0.0001:1
    x0=0.5
    p = [0.382025+0.2]
    total_n = 20
    # DDS.plot_nth_composition(logistic, x, p, total_n; ax_aspect=1, resolution=(600,600))
    DDS.plot_cobweb(pikovsky, x0, x, p, total_n;ax_aspect=1, resolution=(600,600))
end

begin # whole bifurcation diagram
    total_n = 2000
    last_n = 100

    x0 = 0.3
    p = [0.3823]
    step = 1e-3
    p_range = -1:step:1
    DDS.bifurcation_diagram(pikovsky, x0, p, 1, p_range, total_n, last_n)
end

begin # bufurcation point 0.382025...
    bc = 0.382025 # bifurcation point
    total_n = 2000
    last_n = 100

    x0 = 0.3
    p = [0.3823]
    step = 1e-8
    p_range = 0.38202:step:0.38203
    DDS.bifurcation_diagram(pikovsky, x0, p, 1, p_range, total_n, last_n)
end

begin # showing intermittency near bifurcation point
    total_n = 2000
    bc = 0.382025 # bifurcation point
    x0 = 0.3
    p = [bc+0.05]
    N = 300
    DDS.forward_orbit(pikovsky, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=200, 
        linewidth=0.25,
        # color=DDS.RGBf(0.2, 0.7, 0.8)
    )
end

begin 
    total_n = 2000
    bc = 0.38203
    x0 = 0.3
    p = [bc+0.05]
    N = 300
    DDS.forward_orbit(pikovsky, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=200, 
        linewidth=0.25,
        # color=DDS.RGBf(0.2, 0.7, 0.8)
    )
end

# __________________ testing ________________________

begin # whole bifurcation diagram
    total_n = 2000
    last_n = 100

    x0 = 0.3
    p = [0.3823]
    p_range = LinRange(0, 1, 4000)
    x_index = 1
    p_index = 1
    DDS.bifurcation_diagram(pikovsky, x0, p, p_index, p_range, total_n, last_n, x_index)
end