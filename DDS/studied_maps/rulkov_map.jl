using DDS

rulkov = DDS.rulkov

begin
    u0 = [0.0, -3.0]
    p0 = [4.1, 0.001, 0.001]
    N = 1000 
end

display(DDS.forward_orbit(rulkov, u0, p0, N, 1))
# display(DDS.forward_orbit(rulkov, u0, p0, N, 2))

begin # whole bifurcation diagram
    total_n = 1000
    last_n = 50

    x0 = [0.0, -3.0]
    p0 = [4.1, 0.001, 0.001]
    p_range = LinRange(-100, 100, 4000)
    x_index = 1
    display(DDS.bifurcation_diagram(rulkov, x0, p0, 1, p_range, total_n, last_n, x_index))
end

begin # closer look
    total_n = 1000
    last_n = 50

    x0 = [0.0, -3.0]
    p0 = [4.1, 0.001, 0.001]
    p_range = LinRange(-60, -50, 4000)
    x_index = 1
    display(DDS.bifurcation_diagram(rulkov, x0, p0, 1, p_range, total_n, last_n, x_index))
end

begin # closer look
    total_n = 1000
    last_n = 50

    x0 = [0.0, -3.0]
    p0 = [4.1, 0.001, 0.001]
    step = 1e-3
    p_range = 1:step:5
    x_index = 1
    display(DDS.bifurcation_diagram(rulkov, x0, p0, 1, p_range, total_n, last_n, x_index))
end

begin # closer look
    total_n = 1000
    last_n = 50

    x0 = [0.0, -3.0]
    p0 = [4.1, 0.001, 0.001]
    p_range = LinRange(3.90, 4.1, 4000)
    x_index = 1
    display(DDS.bifurcation_diagram(rulkov, x0, p0, 1, p_range, total_n, last_n, x_index))
end

begin # intermittent forward_orbit
    total_n = 8000

    x0 = [0.0, -3.0]
    p0 = [4.0, 0.001, 0.001]
    x_index = 1
    DDS.forward_orbit(
        rulkov, u0, p0, total_n, x_index; 
        markersize=2.0,
        xtick_period=1000,
        linewidth=0.5,
        resolution=(2000, 500)
    )
end

begin # intermittent forward_orbit
    total_n = 8000

    x0 = [0.0, -3.0]
    p0 = [4.1, 0.001, 0.001]
    x_index = 1
    DDS.forward_orbit(
        rulkov, u0, p0, total_n, x_index; 
        markersize=2.0,
        xtick_period=1000,
        linewidth=0.5,
        resolution=(2000, 500)
    )
end

begin # intermittent forward_orbit
    total_n = 8000

    x0 = [0.0, -3.0]
    p0 = [3.95, 0.001, 0.001]
    x_index = 1
    DDS.forward_orbit(
        rulkov, u0, p0, total_n, x_index; 
        markersize=2.0,
        xtick_period=1000,
        linewidth=0.5,
        resolution=(2000, 500)
    )
end

begin # intermittent forward_orbit
    total_n = 2000

    x0 = [0.0, -3.0]
    p0 = [3.45, 0.001, 0.001]
    x_index = 1
    DDS.forward_orbit(
        rulkov, u0, p0, total_n, x_index; 
        markersize=2.0,
        xtick_period=1000,
        linewidth=0.5,
        resolution=(2000, 500)
    )
end


begin # intermittent forward_orbit
    total_n = 20000

    x0 = [0.0, -3.0]
    p0 = [4.005, 0.001, 0.001]
    x_index = 1
    DDS.forward_orbit(
        rulkov, u0, p0, total_n, x_index; 
        markersize=2.0,
        xtick_period=1000,
        linewidth=0.5,
        resolution=(2000, 500)
    )
end

begin # intermittent forward_orbit
    total_n = 20000

    x0 = [0.0, -3.0]
    p0 = [-54, 0.001, 0.001]
    x_index = 1
    DDS.forward_orbit(
        rulkov, u0, p0, total_n, x_index; 
        markersize=2.0,
        xtick_period=1000,
        linewidth=0.05,
        resolution=(2000, 500)
    )
end

# ______________________ testing _________________

begin # closer look
    total_n = 1000
    last_n = 50

    x0 = [0.0, -3.0]
    p0 = [4.1, 0.001, 0.001]
    p_range = LinRange(-500, 500, 4000)
    x_index = 1
    p_index = 1
    display(DDS.bifurcation_diagram(rulkov, x0, p0, p_index, p_range, total_n, last_n, x_index))
end