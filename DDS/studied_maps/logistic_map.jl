using DDS

logistic = DDS.logistic

begin
    x0 = 0.5
    p = [3.8]
    N = 500
    DDS.trajectory(logistic, x0, p, N, 1; markersize=5.0)
end

begin
    total_n = 1000
    last_n = 50

    x0 = 0.5
    p = [3.8]
    p_range = LinRange(0, 3.8, 3000)
    DDS.bifurcation_diagram(logistic, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of logistic map\n$total_n iterations, sampling last $last_n")
end

begin
    total_n = 1000
    last_n = 50

    x0 = 0.5
    p = [3.8]
    p_range = LinRange(3.8, 3.9, 3000)
    DDS.bifurcation_diagram(logistic, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of logistic map\n$total_n iterations, sampling last $last_n")
end

begin
    total_n = 1000
    last_n = 50

    x0 = 0.5
    p = [3.8]
    p_range = LinRange(3.8284, 3.8285, 3000)
    DDS.bifurcation_diagram(logistic, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of logistic map\n$total_n iterations, sampling last $last_n")
end

begin # intermittent trajectory
    total_n = 10000
    x0 = 0.5
    p = [3.82842]
    N = 500
    display(DDS.trajectory(logistic, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=2000, 
        linewidth=0.05, 
        title="Logistic map for r=$(p[1]), x0=$(x0)"
    ))
end

begin # long laminar phases
    total_n = 30000
    x0 = 0.5
    p = [3.828427110]
    for p in LinRange(3.828427110, 3.828427115, 10)
        p = [p]
        n = 500
        display(DDS.trajectory(logistic, x0, p, total_n, 1; 
            ax_aspect=5, 
            markersize=7.0, 
            resolution=(1500,500), 
            xtick_period=2000, 
            linewidth=0.05, 
            title="logistic map for r=$(p[1]), x0=$(x0)"
        ))
    end
end

begin # showing cobweb narrow passage for parameter near intermittency threshold
    x = LinRange(0.49, 0.54, 2000)
    x0=0.5
    p = [3.828427110]
    total_n = round(9310/3)
    n_order = 3
    starting_x = 0
    DDS.plot_cobweb(logistic, x0, x, p, total_n, n_order, starting_x;ax_aspect=1, resolution=(600,600))
end

begin # tangent bifurcation near the intermittency threshold, two fixed points
    x = LinRange(0.49, 0.54, 2000)
    x0=0.5
    p = [3.830]
    total_n = 1
    n_order = 3
    starting_x = 0
    DDS.plot_cobweb(logistic, x0, x, p, total_n, n_order, starting_x;ax_aspect=1, resolution=(600,600))
end
