using DDS

standard = DDS.standard

# ____________ exploring bifurcation diagram of first variable _________________

begin # whole bifurcation diagram
    total_n = 1000
    last_n = 50

    x0 = [0.5, 0.5]
    p = [0.001]
    p_range = LinRange(-7,7, 4000)
    x_index = 1
    display(DDS.bifurcation_diagram(standard, x0, p, 1, p_range, total_n, last_n, x_index))
end

begin # closer look
    total_n = 1000
    last_n = 50

    x0 = [0.5, 0.5]
    p = [0.001]
    step = 1e-4
    p_range = 0.7:step:1.1
    x_index = 1
    display(DDS.bifurcation_diagram(standard, x0, p, 1, p_range, total_n, last_n, x_index))
end

begin # closer look
    total_n = 2000
    last_n = 300

    x0 = [0.5, 0.5]
    p = [0.001]
    step = 1e-7
    p_range = 0.92055:step:0.9207
    x_index = 1
    display(DDS.bifurcation_diagram(standard, x0, p, 1, p_range, total_n, last_n, x_index))
end

begin
    total_n = 10000

    x0 = [0.5, 0.5]
    for i = 1:100
        p = [0.92066 + i*1e-4]
        x_index = 1
        display(DDS.timeseries(standard, x0, p, total_n, x_index; xtick_period=1000))
    end
end

# ____________ exploring bifurcation diagram of second variable _________________

begin # whole bifurcation diagram
    total_n = 1000
    last_n = 50

    x0 = [0.5, 0.5]
    p = [0.001]
    step = 1e-3
    p_range = -5:step:7
    x_index = 2
    display(DDS.bifurcation_diagram(standard, x0, p, 1, p_range, total_n, last_n, x_index))
end

begin # closer look
    total_n = 1000
    last_n = 50

    x0 = [0.5, 0.5]
    p = [0.001]
    step = 1e-3
    p_range = 0:step:1.1
    x_index = 2
    display(DDS.bifurcation_diagram(standard, x0, p, 1, p_range, total_n, last_n, x_index))
end

begin # even closer look
    total_n = 1000
    last_n = 50

    x0 = [0.5, 0.5]
    p = [0.001]
    step = 1e-4
    p_range = 0:step:0.9
    x_index = 2
    display(DDS.bifurcation_diagram(standard, x0, p, 1, p_range, total_n, last_n, x_index))
end

begin # even closer look
    total_n = 1000
    last_n = 50

    x0 = [0.5, 0.5]
    p = [0.001]
    step = 1e-5
    p_range = 0.6:step:0.62
    x_index = 2
    display(DDS.bifurcation_diagram(standard, x0, p, 1, p_range, total_n, last_n, x_index))
end

begin # even closer look
    total_n = 1000
    last_n = 50

    x0 = [0.5, 0.5]
    p = [0.001]
    step = 1e-6
    p_range = 0.61:step:0.62
    x_index = 2
    display(DDS.bifurcation_diagram(standard, x0, p, 1, p_range, total_n, last_n, x_index))
end

begin # even closer look
    total_n = 1000
    last_n = 50

    x0 = [0.5, 0.5]
    p = [0.001]
    step = 1e-7
    p_range = 0.6104:step:0.611
    x_index = 2
    display(DDS.bifurcation_diagram(standard, x0, p, 1, p_range, total_n, last_n, x_index))
end

begin
    total_n = 1000

    x0 = [0.5, 0.5]
    p = [0.6108]
    x_index = 2
    DDS.timeseries(standard, x0, p, total_n, x_index)
end

begin
    total_n = 1000
    last_n = 50

    x0 = [0.5, 0.5]
    p = [0.001]
    step = 1e-5
    p_range = 0.27:step:0.28
    x_index = 2
    display(DDS.bifurcation_diagram(standard, x0, p, 1, p_range, total_n, last_n, x_index))
end

begin
    total_n = 1000

    x0 = [0.5, 0.5]
    p = [0.275]
    x_index = 2
    DDS.timeseries(standard, x0, p, total_n, x_index)
end

# ______________ testing _____________________

begin
    total_n = 1000
    last_n = 50

    x0 = [0.5, 0.5]
    p = [0.001]
    p_range = LinRange(-10000,10000, 5000)
    x_index = 1
    display(DDS.bifurcation_diagram(standard, x0, p, 1, p_range, total_n, last_n, x_index))
end