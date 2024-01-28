using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    x0 = 0.5
    param = [3.6265532663316584]
    order = 6

    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0, 1)
    @time fps = DDS.fixed_points(logistic, param, order, x_range;method=:BWJ)
    sfps = DDS.stable_fixed_points(logistic, param, order, x_range; method=:BWJ)

    fig = CairoMakie.Figure(resolution=(1000,600))

    total_n = 1
    starting_x = 0
    ax_aspect = 4
    identity_line = true

    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE)
    scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED)
    println((length(fps), length(sfps)))




    @time fps = DDS.fixed_points(logistic, param, order, x_range; method=:DL)
    sfps = DDS.stable_fixed_points(logistic, param, order, x_range; method=:DL)

    total_n = 1
    starting_x = 0
    identity_line = true

    ax = DDS.plot_nth_composition!(fig[2,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE)
    scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED)

    println((length(fps), length(sfps)))
    display(fig)
end;

begin
    logistic = DDS.logistic
    x0 = 0.5
    param = [3.83]
    order = 3

    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0, 1)
    @time fps = DDS.fixed_points(logistic, param, order, x_range)
    @time sfps = DDS.stable_fixed_points(logistic, param, order, x_range)

    fig = Figure(resolution=(1000,600))

    total_n = 1
    starting_x = 0
    ax_aspect = 2
    identity_line = true

    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE)
    scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED)
    display(fig)
end;




begin
    logistic = DDS.logistic
    x0 = 0.5
    param = [3.235]
    order = 1

    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0, 1)
    fig = CairoMakie.Figure(resolution=(1000,600))

    @time fps = DDS.fixed_points(logistic, param, order, x_range; method=:DL)
    sfps = DDS.stable_fixed_points(logistic, param, order, x_range; method=:DL)

    total_n = 1
    starting_x = 0
    identity_line = true

    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE)
    scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED)

    println((length(fps), length(sfps)))
    display(fig)
    println(fps)
end;