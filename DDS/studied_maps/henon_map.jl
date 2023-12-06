using DDS

henon = DDS.henon

begin # whole bifurcation diagram
    total_n = 1000
    last_n = 50

    x0 = [0.0, 0.0]
    p = [0.0, 0.3]

    step = 1e-3
    p_range = -1:step:1.4

    x_index = 1
    p_index = 1
    display(DDS.bifurcation_diagram(henon, x0, p, p_index, p_range, total_n, last_n, x_index))
end

begin # bifurcation diagram
    total_n = 1000
    last_n = 50

    x0 = [0.0, 0.0]
    p = [0.0, 0.3]

    step = 1e-4
    p_range = 1:step:1.4

    x_index = 1
    p_index = 1
    display(DDS.bifurcation_diagram(henon, x0, p, p_index, p_range, total_n, last_n, x_index))
end

begin # break point
    total_n = 1000
    last_n = 50

    x0 = [0.0, 0.0]
    p = [0.0, 0.3]

    step = 1e-6
    p_range = 1.225:step:1.23

    x_index = 1
    p_index = 1
    display(DDS.bifurcation_diagram(henon, x0, p, p_index, p_range, total_n, last_n, x_index))
end

begin # showing intermittency at the break point of henon map
    total_n = 2000

    x0 = [0.0, 0.0]
    p = [1.2264, 0.3]
    x_index = 1
    DDS.trajectory(
        henon, x0, p, total_n, x_index;
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=500, 
        linewidth=0.5, 
        title="Henon map for [a,b]=$p, x0=$(x0)",
    )
end

begin # intermittency again
    total_n = 20000

    x0 = [0.0, 0.0]
    p = [1.226617, 0.3]
    x_index = 1
    DDS.trajectory(
        henon, x0, p, total_n, x_index;
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=500, 
        linewidth=0.05, 
        title="Henon map for [a,b]=$p, x0=$(x0)",
    )
end

begin # showing intermittency at the break point of henon map
    total_n = 26000

    x0 = [0.0, 0.0]
    p = [1.22661735, 0.3]
    for i in LinRange(1.22661730, 1.22661735, 10)
        p = [i, 0.3]
        x_index = 1
        display(DDS.trajectory(
            henon, x0, p, total_n, x_index;
            ax_aspect=5, 
            markersize=7.0, 
            resolution=(2000,500), 
            xtick_period=2000, 
            linewidth=0.05, 
            title="Henon map for [a,b]=$p, x0=$(x0)",
            # color=:blue
        ))
    end
end