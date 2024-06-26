using DDS
using CairoMakie

begin
    a, b = 3.825, 3.83
    n_order = 3
    x0 = 0.5
    param = [3.8]

    max_iter = 10
    x_range = (0.0, 1.0)
    fig=Figure()
    @time ax = DDS.plot_NLS(
        fig[1,1],
        DDS.logistic,
        x0,
        param,
        (a, b),
        n_order,
        x_range;
        max_iter = max_iter
    )
    display(fig)
end

begin
    a, b = 3.581, 3.5825
    n_order = 12
    x0 = 0.5
    param = [3.8]

    x_range = (0.0, 1.0)
    fig=Figure()
    ax = DDS.plot_NLS(
        fig[1,1],
        DDS.logistic,
        x0,
        param,
        (a, b),
        n_order,
        x_range;
    )
    display(fig)
end

begin
    a, b = 3.700, 3.702
    n_order = 7
    x0 = 0.5
    param = [3.8]

    x_range = (0.0, 1.0)
    fig=Figure()
    ax = DDS.plot_NLS(
        fig[1,1],
        DDS.logistic,
        x0,
        param,
        (a, b),
        n_order,
        x_range;
    )
    display(fig)
end

begin
    a, b = 2.95, 3.0
    n_order = 1
    x0 = 0.5
    param = [3.8]

    x_range = (-3.0, 3.0)
    fig=Figure()
    DDS.plot_NLS(
        fig[1,1],
        DDS.cos_f,
        x0,
        param,
        (a,b),
        n_order,
        x_range;
        range_partition=3000
    )
    display(fig)
end

begin
    a, b = 1.965, 1.98
    n_order = 1
    x0 = 0.5
    param = [3.8]

    x_range = (-2.0, 2.0)
    fig=Figure()
    DDS.plot_NLS(
        fig[1,1],
        DDS.cos_f,
        x0,
        param,
        (a,b),
        n_order,
        x_range;
        range_partition=3000
    )
    display(fig)
end