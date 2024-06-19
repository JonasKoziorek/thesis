using DDS

duffing = DDS.duffing

begin # whole bifurcation diagram
    total_n = 1000
    last_n = 50

    x0 = [-1.5, 0.1]
    p0 = [2.75, 0.2]
    p_range = LinRange(0, 2.7, 4000)
    x_index = 1
    p_index = 1
    display(DDS.bifurcation_diagram(duffing, x0, p0, p_index, p_range, total_n, last_n, x_index))
end

begin # closer look
    total_n = 1000
    last_n = 50

    x0 = [-1.5, 0.1]
    p0 = [2.75, 0.2]
    p_range = LinRange(2.4, 2.7, 4000)
    x_index = 1
    p_index = 1
    display(DDS.bifurcation_diagram(duffing, x0, p0, p_index, p_range, total_n, last_n, x_index))
end

begin # closer look
    total_n = 1000
    last_n = 50

    x0 = [-1.5, 0.1]
    p0 = [2.75, 0.2]
    p_range = LinRange(2.66765, 2.6677, 8000)
    x_index = 1
    p_index = 1
    display(DDS.bifurcation_diagram(duffing, x0, p0, p_index, p_range, total_n, last_n, x_index))
end

begin # closer look
    total_n = 1000
    last_n = 50

    x0 = [-1.5, 0.5]
    p0 = [2.75, 0.2]
    p_range = LinRange(2.5258, 2.526, 6000)
    x_index = 1
    p_index = 1
    display(DDS.bifurcation_diagram(duffing, x0, p0, p_index, p_range, total_n, last_n, x_index))
end

begin
    total_n = 2000

    x0 = [-1.5, 0.5]
    p0 = [2.5302, 0.2]
    x_index = 1
    p_index = 1
    DDS.trajectory(
        duffing, x0, p0, total_n, x_index; 
        markersize=5.0,
        xtick_period=1000,
        linewidth=0.05,
        resolution=(2000, 500)
    )
end

begin # whole bif diagram
    total_n = 1000
    last_n = 50

    x0 = [-1.0, 0.0]
    p0 = [2.75, 0.0001]
    p_range = LinRange(-1, 2.7, 4000)
    x_index = 1
    p_index = 1
    display(DDS.bifurcation_diagram(duffing, x0, p0, p_index, p_range, total_n, last_n, x_index))
end

begin # closer look
    total_n = 1000
    last_n = 50

    x0 = [-1.0, 0.0]
    p0 = [2.75, 0.0001]
    p_range = LinRange(2.4503, 2.4505, 7000)
    x_index = 1
    p_index = 1
    display(DDS.bifurcation_diagram(duffing, x0, p0, p_index, p_range, total_n, last_n, x_index))
end

begin # intermittent trajectory
    total_n = 30000

    for p in LinRange(BigFloat("2.45043963"), BigFloat("2.45043964"), 10)
        x0 = [-1.0, 0.0]
        p0 = [p, 0.0001]
        x_index = 1
        p_index = 1
        display(DDS.trajectory(
            duffing, x0, p0, total_n, x_index; 
            markersize=5.0,
            xtick_period=2000,
            linewidth=0.05,
            resolution=(2000, 500)
        ))
    end
end

# __________________ testing _____________________

begin
    total_n = 1000
    last_n = 50

    x0 = [-1.0, 0.0]
    p0 = [2.75, 0.0001]
    p_range = LinRange(2.3, 2.5, 2000)
    x_index = 1
    p_index = 1
    display(DDS.bifurcation_diagram(duffing, x0, p0, p_index, p_range, total_n, last_n, x_index))
end
