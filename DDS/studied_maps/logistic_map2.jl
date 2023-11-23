using DDS
using IntervalArithmetic
using IntervalRootFinding
using CairoMakie
using ForwardDiff

logistic = DDS.logistic

begin
    total_n = 1000
    last_n = 50

    x0 = 0.5
    p = [3.8]
    p_range = LinRange(3.581, 3.5825, 2000)
    DDS.bifurcation_diagram(logistic, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of logistic map\n$total_n iterations, sampling last $last_n")
end

begin
    x = LinRange(0,1,2000)
    x0=0.5
    p=[3.700189154980375]
    total_n = 2
    n_order = 8
    DDS.plot_cobweb(logistic, x0, x, p, total_n, n_order;ax_aspect=1, resolution=(600,600))
end

function identify(f)
    # substract identity function from function f
    g(x, p) = f(x, p) - x
    return g
end

first_d(func, x, p) = ForwardDiff.derivative(x->func(x, p), x)
second_d(func, x, p) = ForwardDiff.derivative(x->first_d(func, x, p), x)

function find_saddle_node(func, x_range, p_range, n_order, tol)
    saddle_nodes = []
    nth_func = DDS.nth_composition(func, n_order)
    for p in p_range
        id = identify(nth_func)
        rts = roots(x->id(x, p), x_range)
        midpoints = mid.(interval.(rts))
        a = first_d.(midpoints,p)
        b = second_d.(midpoints,p)
        # println("param p: $p")
        # println(a)
        counter = 0
        for i in eachindex(a)
            if abs(a[i]-1) <= tol && abs(b[i]) != 0
                counter +=1
            end
        end
        if counter >= n_order
            push!(saddle_nodes, p)
        end
    end
    return saddle_nodes
end

function find_saddle_node(func, x_range, p_range, n_order, tol)
    nth_func = DDS.nth_composition(func, n_order)
    saddle_nodes = []
    for p in p_range
        rts = roots(x->first_d(nth_func, x, p)-1, x_range)
        midpoints = mid.(interval.(rts))
        midpoints = filter(x->is_saddle_node(nth_logistic, x, p, tol), midpoints)
        if length(midpoints) == n_order
            push!(saddle_nodes, p)
        end
    end
    return saddle_nodes
end

begin
    x = LinRange(0,1, 2000)
    x0 = 0.5    
    # p = [3.82845]
    p = [3.828427115]
    n_order = 3

    nth_logistic = DDS.nth_composition(logistic, n_order)
    y = nth_logistic.(x, p)

    display(DDS.plot_cobweb(logistic, x0, x, p, 1, n_order;ax_aspect=1, resolution=(600,600)))

    fig = Figure()
    ax = Axis(fig[1,1])

    first_d(x, p) = ForwardDiff.derivative(x->nth_logistic(x, p), x)
    second_d(x, p) = ForwardDiff.derivative(x->first_d(x, p), x)

    id = identify(nth_logistic)
    # lines!(ax, x, id.(x, p))
    lines!(ax, x, nth_logistic.(x, p))

    rts = DDS.roots(x->id(x,p), Interval(0,1))
    midpoints = mid.(interval.(rts))
    # scatter!(ax, midpoints, id.(midpoints, p), markersize=10)
    scatter!(ax, midpoints, nth_logistic.(midpoints, p), markersize=10)
    display(fig)
    a = first_d.(midpoints,p)
    b = second_d.(midpoints,p)
end

begin
    p_range = LinRange(3.8, 3.9, 6000)
    x_range = Interval(0,1)
    n_order = 3
    tol = 1e-4
    saddle_nodes = find_saddle_node(logistic, x_range, p_range, n_order, tol)
    println("Found saddle nodes $saddle_nodes.")

    fig=Figure()

    total_n = 1000
    last_n = 50

    x0 = 0.5
    p = [3.8]
    ax = DDS.bifurcation_diagram!(fig[1,1], logistic, x0, p, 1, p_range, total_n, last_n; title="Bifurcation diagram of logistic map\n$total_n iterations, sampling last $last_n")
    if length(saddle_nodes) > 0
        saddle_nodes = Float64.(saddle_nodes)
        scatter!(ax, saddle_nodes, zeros(length(saddle_nodes)))
    else
        println("No saddle nodes found.")
    end
    display(fig)
end

begin
    x = LinRange(0,1,2000)
    x0=0.5
    p = [3.7016407641]
    p = [3.7017]
    total_n = 1
    n_order = 7
    DDS.plot_cobweb(logistic, x0, x, p, total_n, n_order;ax_aspect=1, resolution=(600,600))
end

begin
    total_n = 10000
    x0 = 0.5
    eps = 1e-4
    p = [3.56]
    N = 500
    display(DDS.timeseries(logistic, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=2000, 
        linewidth=0.05, 
        title="Logistic map for r=$(p[1]), x0=$(x0)"
    ))
end

begin
    x = LinRange(0,1, 2000)
    x0 = 0.5    
    # p = [3.82845]
    p = [3.828427115]
    n_order = 3

    nth_logistic = DDS.nth_composition(logistic, n_order)
    y = nth_logistic.(x, p)

    display(DDS.plot_cobweb(logistic, x0, x, p, 1, n_order;ax_aspect=1, resolution=(600,600)))

    fig = Figure()
    ax = Axis(fig[1,1])

    first_d(x, p) = ForwardDiff.derivative(x->nth_logistic(x, p), x)
    second_d(x, p) = ForwardDiff.derivative(x->first_d(x, p), x)

    lines!(ax, x, nth_logistic.(x, p))

    tol = 1e-4
    rts = DDS.roots(x->first_d(nth_logistic, x, p)-1, Interval(0,1))
    midpoints = mid.(interval.(rts))
    printer.(nth_logistic, midpoints, p)    
    midpoints = filter(x->is_saddle_node(nth_logistic, x, p, tol), midpoints)
    scatter!(ax, midpoints, nth_logistic.(midpoints, p), markersize=10)
    display(fig)
    # a = first_d.(midpoints,p)
    # b = second_d.(midpoints,p)
end

function printer(func, x0, p)
    println("x0: $x0")
    println("f(x0): $(func(x0, p))")
    println("f(x0)-x0: $(abs(func(x0, p)-x0))")
    println("f''(x0): $(second_d(func, x0, p))")
    println("")
end

function is_saddle_node(func, x0, p, tol)
    difference = abs(first_d(func, x0, p)-1)
    sec_d = second_d(func, x0, p)
    # println("tol: $tol")
    # println("diff: $difference")
    # println("sec_d: $sec_d")
    # println("diff<tol: $(difference<tol)")
    if difference < tol && sec_d != 0
        return true
    end
    return false
end

begin
    p_range = LinRange(3, 4.0, 500)
    x_range = Interval(0,1)
    n_order = 1:3
    plot_points = Vector{Tuple{Float64, Float64}}(undef, 0)
    for p in p_range
        for n in n_order
            nth_logistic = DDS.nth_composition(logistic, n)
            id = identify(nth_logistic)
            rts = roots(x->id(x,p), x_range)
            midpoints = mid.(interval.(rts))
            filter!(
                x -> abs(first_d(nth_logistic, x, p))<1,
                midpoints
            )
            append!(plot_points, [(p, m) for m in midpoints])
        end
    end
    scatter(plot_points, markersize=4)
end

function fixed_points(func, p, x_range, n_order)
    nth_func = DDS.nth_composition(func, n_order)
    id = identify(nth_func)
    rts = roots(x->id(x, p), x_range)
    fixed_points = Float64[]
    for root in rts
        root = mid(interval(root))
        if abs(first_d(nth_func, root, p)) < 1
            arr = DDS.iterate(func, root, p, n_order)
            append!(fixed_points, arr)
            break
        end
    end
    return fixed_points
end

function is_stable(func, p, fps)
    return filter(
        x0->abs(first_d(func, x0, p)) < 1,
        fps
    )
end

function stable_fps(func, p, period, x_range, dim)
    λ = 0.1
    fps = DDS.periodicorbits(func, p, period, x_range, dim, λ)
    fps = [Float64(i[1]) for i in fps]
    return is_stable(func, p, fps)
end

# function approx_break_point(func, a, b, x_range, n_order, max_iter, partition, tol, current_iter = 0)
#     # @info "params" max_iter, partition, tol
#     # println("current_iteration: $current_iter")
#     # println("current iteration: $current_iter")
#     # if current_iter == max_iter
#     #     return b
#     # end
#     prev_i = b
#     for i in LinRange(b, a, partition)
#         if current_iter == max_iter
#             return prev_i
#         end
#         # println(i)
#         # println(stable_fps(func, i, x_range, tol))
#         sfps = stable_fps(func, i, x_range, tol)
#         saddle_nodes = is_saddle_node.(func, sfps, i, tol)
#         # println(saddle_nodes)
#         # println("")
#         if length(saddle_nodes) > 0 && all(saddle_nodes)
#             return i
#         end
#         if length(sfps) != n_order
#             println("recursin")
#             return approx_break_point(func, i, prev_i, x_range, n_order, max_iter, 2*partition, tol, current_iter)
#         end
#         prev_i = i
#         current_iter += 1
#         println("current_iteration: $current_iter")
#     end
# end

function intermittency_region_left(func, a, b, x_range::Tuple{Real, Real}, n_order, max_iter, partition, dim, current_iter = 0)
    prev_param = a
    for param in LinRange(a, b, partition)
        println("Region Left Iter: $current_iter")
        if current_iter == max_iter
            return prev_param
        end
        @time fps = DDS.periodicorbits(func, [param], n_order, x_range, dim)
        if length(fps) > 0 && length(fps) % n_order == 0
            a == b && return a
            return intermittency_region_left(func, prev_param, param, x_range, n_order, max_iter, partition, dim, current_iter+1)
        end
        prev_param = param
        current_iter += 1
    end
    return a
    # error("Haven't found any region with period $n_order. Check that bounds ($a,$b) are correct.")
end

function intermittency_region_right(func, a, b, x_range::Tuple{Real, Real}, n_order, max_iter, partition, dim, current_iter = 0)
    prev_param = b
    for param in LinRange(b, a, partition)
        println("Region Right Iter: $current_iter")
        if current_iter == max_iter
            return prev_param
        end
        fps = DDS.periodicorbits(func, [param], n_order, x_range, dim)
        println("p: $param, length: $(length(fps))")
        if length(fps) > 0 && length(fps) % n_order != 0
            a == b && return a
            return intermittency_region_right(func, param, prev_param, x_range, n_order, max_iter, partition, dim, current_iter+1)
        end
        prev_param = param
        current_iter += 1
    end
    return a
    # error("Haven't found any region with period other than $n_order. Check that bounds ($a,$b) are correct.")
end

function intermittency_region(func, a, b, x_range::Tuple{Real, Real}, n_order, max_iter, partition, dim)
    if n_order < 10
        # root finding algorithm
        x_range = Interval(x_range...)
        l = intermittency_region_left(func, a, b, x_range, n_order, max_iter, partition)
        @info "l" l
        r = intermittency_region_right(func, a, b, x_range, n_order, max_iter, partition)
        @info "l" r
        return (l, r)
    else
        # Schmelcher Diakonos algorithms
        l = intermittency_region_left(func, a, b, x_range, n_order, max_iter, partition, dim)
        @info "l" l
        r = intermittency_region_right(func, a, b, x_range, n_order, max_iter, partition, dim)
        @info "r" r
        return (l, r)

    end
end


function intermittency_region_left(func, a, b, x_range::Interval, n_order, max_iter, partition, current_iter = 0)
    prev_param = a
    for param in LinRange(a, b, partition)
        println("Region Left Iter: $current_iter")
        if current_iter == max_iter
            return prev_param
        end
        fps = fixed_points(func, [param], x_range, n_order)
        if length(fps) == n_order
            a == b && return a
            return intermittency_region_left(func, prev_param, param, x_range, n_order, max_iter, partition, current_iter+1)
        end
        prev_param = param
        current_iter += 1
    end
    return b
    # error("Haven't found any region with period $n_order. Check that bounds ($a,$b) are correct.")
end

function intermittency_region_right(func, a, b, x_range::Interval, n_order, max_iter, partition, current_iter = 0)
    prev_param = b
    println((b, a))
    for param in LinRange(b, a, partition)
        println("Region Right Iter: $current_iter")
        if current_iter == max_iter
            return prev_param
        end
        fps = fixed_points(func, [param], x_range, n_order)
        if length(fps) != n_order
            a == b && return a
            return intermittency_region_right(func, param, prev_param, x_range, n_order, max_iter, partition, current_iter+1)
        end
        prev_param = param
        current_iter += 1
    end
    return a
    # error("Haven't found any region with period other than $n_order. Check that bounds ($a,$b) are correct.")
end

function approx_break_point(func, a, b, x_range, n_order, max_iter, partition, tol, ax, current_iter = 0)
    prev_param = a
    @info "" a b partition
    nth_func = DDS.nth_composition(func, n_order)
    for param in LinRange(a, b, partition)
        println("\ncurrent_iteration: $current_iter")
        println("p: $param")
        scatter!(ax, (param, 0), color=:blue, markersize=10)
        if current_iter == max_iter
            return prev_param
        end
        fps = fixed_points(nth_func, param, x_range, n_order)
        println(fps)
        println("length: $(length(fps))")
        if length(fps) == n_order
            println("recursin")
            prev_param == param && error("Choose (a, b) range correctly so that chaotic behavior is to the left of break point and stable behavior to the right of break point.\nThis might mean that intermittency occurs already at $param.")
            return approx_break_point(func, prev_param, param, x_range, n_order, max_iter, 2*partition, tol, ax, current_iter+1)
        end
        prev_param = param
        current_iter += 1
    end
end

begin
    fig = Figure()
    ax = Axis(fig[1,1])
    a = 3.825
    b = 3.83
    c = 3.828427
    lines!(ax, [a, c, b], [0, 0, 0])
    lines!(ax, [c, c], [-3, 3])
    scatter!(ax, [a, c, b], [0, 0, 0])
    display(fig)
end
begin
    n_order = 3
    nth_logistic = DDS.nth_composition(logistic, n_order)
    tol = 1e-8
    saddle_node = approx_break_point(nth_logistic, a, b, Interval(0,1), n_order, 30, 10, tol, ax)
    display(fig)
end

begin
    # stop
    fig = Figure()
    ax = Axis(fig[1,1])
    a = 3.690
    b = 3.702
    c = (a+b)/2
    lines!(ax, [a, c, b], [0, 0, 0])
    lines!(ax, [c, c], [-3, 3])
    scatter!(ax, [a, c, b], [0, 0, 0])
    display(fig)
end
begin
    # a, b = 3.700, 3.702
    # n_order = 7

    # a, b = 3.550, 3.583
    # n_order = 12

    a, b = 3.825, 3.83
    n_order = 3

    max_iter = 70
    partition = 50
    x_range = (0, 1)
    dim = 1
    # (l, r) = intermittency_region(logistic, a, b, x_range, n_order, max_iter, partition, dim)
    l = intermittency_region_left(logistic, a, b, x_range, n_order, max_iter, partition, dim)
    r = intermittency_region_right(logistic, a, b, x_range, n_order, max_iter, partition, dim)
    # saddle_node = approx_break_point(logistic, a, b, Interval(0,1), n_order, max_iter, partition, tol, ax)
    display(fig)

    fig=Figure()

    total_n = 1000
    last_n = 50

    x0 = 0.5
    p = [a]
    p_range = LinRange(a,b, 2000)
    ax = DDS.bifurcation_diagram!(fig[1,1], logistic, x0, p, 1, p_range, total_n, last_n)
    lines!(ax, [l, l], [0, 1], color=:red, linewidth=3)
    lines!(ax, [r, r], [0, 1], color=:red, linewidth=3)
    display(fig)
end

begin
    fig = Figure()
    ax = Axis(fig[1,1])
    a = 3.737
    b = 3.739
    lines!(ax, [a, 3.7381723752, b], [0, 0, 0])
    lines!(ax, [3.7381723752, 3.7381723752], [-3, 3])
    scatter!(ax, [a, 3.7381723752, b], [0, 0, 0])
    display(fig)
end

begin
    n_order = 5
    nth_logistic = DDS.nth_composition(logistic, n_order)
    tol = 1e-5
    saddle_node = approx_break_point(nth_logistic, a, b, Interval(0,1), n_order, 100, 10, tol, ax)
    display(fig)
end

function f1(x, p)
    x = x[1]
    ϵ = p[1]
    return ϵ+x+x^2
end

begin
    fig = Figure()
    ax = Axis(fig[1,1])
    a = -0.5
    b = 0.5
    c = 0
    lines!(ax, [a, c, b], [0, 0, 0])
    lines!(ax, [c, c], [-3, 3])
    scatter!(ax, [a, c, b], [0, 0, 0])
    display(fig)
end

begin
    n_order = 1
    tol = 1e-5
    saddle_node = approx_break_point(f1, a, b, Interval(-0.7, 0.4), n_order, 10, 10, tol, ax)
    display(fig)
end


begin
    # stop
    fig = Figure()
    ax = Axis(fig[1,1])
    a = 3.7015
    b = 3.7017
    c = (a+b)/2
    lines!(ax, [a, c, b], [0, 0, 0])
    lines!(ax, [c, c], [-3, 3])
    scatter!(ax, [a, c, b], [0, 0, 0])


    n_order = 7
    nth_logistic = DDS.nth_composition(logistic, n_order)
    tol = 1e-16
    x = LinRange(0, 1, 1000)
    x_range = Interval(0, 1)
    # lines!(ax, x, nth_logistic.(x, p))

    p = 3.70165
    # id = identify(nth_logistic)
    # lines!(ax, x, id.(x, p))
    # lines!(ax, x, x)
    # sfps = stable_fps(nth_logistic, p, x_range, tol)
    # scatter!(ax, sfps, nth_logistic.(sfps, p))
    display(fig)
end

begin
    logistic = DDS.logistic
    p = [3.56]
    dim = 1
    x_range=(0,1)
    period = 8
    fps = DDS.periodicorbits(logistic, p, period, x_range, dim)
    fps = [Float64(i[1]) for i in fps]
    if length(fps) > 0
        nth_logistic = DDS.nth_composition(logistic, period)
        fig = Figure()
        x = LinRange(0,1,2000)
        x0=0.2
        total_n = 1
        starting_x = 0
        ax = DDS.plot_cobweb!(fig[1,1], logistic, x0, x, p, total_n, period, starting_x; dot_size=38, last_point_color=:pink)
        scatter!(ax, fps, [nth_logistic(fp, p) for fp in fps], color=:blue, markersize=13)
        sfps = is_stable(nth_logistic, p, fps)
        scatter!(ax, sfps,[nth_logistic(sfp, p) for sfp in sfps], color=:red, markersize=13)
        display(fig)
    else
        println("No fixed points.")
    end
end

begin
    fig = Figure()
    ax = Axis(fig[1,1])
    a = 3.825
    b = 3.83
    c = 3.828427
    lines!(ax, [a, c, b], [0, 0, 0])
    lines!(ax, [c, c], [-3, 3])
    scatter!(ax, [a, c, b], [0, 0, 0])
    display(fig)
end
begin
    p = [3.825]
    n_order = 3
    tol = 1e-8
    max_iter = 500
    partition = 10
    saddle_node = approx_break_point(logistic, a, b, Interval(0,1), n_order, max_iter, partition, tol, ax)
    display(fig)
end

begin
    total_n = 1000
    x0 = 0.5
    eps = 1e-4
    p=[3.555]
    N = 500
    display(DDS.timeseries(logistic, x0, p, total_n, 1; 
        ax_aspect=5, 
        markersize=7.0, 
        resolution=(2000,500), 
        xtick_period=2000, 
        linewidth=0.05, 
        title="Logistic map for r=$(p[1]), x0=$(x0)"
    ))
end

begin
    a, b = 3.825, 3.83
    n_order = 3

    # a, b = 3.690, 3.702
    # n_order = 7

    # a, b = 3.581, 3.5825
    # n_order = 10

    b = 3.56
    n_order = 8
    
    p = [b]
    x_range = Interval(0,1)
    @time fps = fixed_points(logistic, p, x_range, n_order)

    if length(fps) > 0
        nth_logistic = DDS.nth_composition(logistic, n_order)
        fig = Figure()
        x = LinRange(0,1,2000)
        x0=0.2
        total_n = 1
        starting_x = 0
        ax = DDS.plot_cobweb!(fig[1,1], logistic, x0, x, p, total_n, n_order, starting_x; dot_size=38, last_point_color=:pink)
        scatter!(ax, fps, [nth_logistic(fp, p) for fp in fps], color=:blue, markersize=13)
        display(fig)
    else
        println("No fixed points.")
    end
end

begin
    # b = 3.56
    # p = [b]
    # n_order = 8
    # @time fps = DDS.periodicorbits(logistic, p, n_order, (0,1), 1)
    # fps = sort(fps)
end