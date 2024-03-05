using DDS
using LsqFit
using CairoMakie: scatter!, Figure, display, scatter, lines!, Axis
using Plots: scatterhist, plot!, scatterhist!, plot
using ForwardDiff
using Distributions: Uniform

function rand_range(min_val, max_val)
    return min_val + rand() * (max_val - min_val)
end

function mean(x)
    return sum(x)/length(x)
end

begin
    x01 = 0.15992881844625645
    x02 = 0.5143552770619905
    x03 = 0.9563178419736238
    x0 = x01
    param = [3.8275]

    c = 0.01
    Ns = 1000
    N = 10000

    logistic = DDS.logistic
    order = 3
    nth_logistic = DDS.nth_composition(logistic, order)
    x_range = (0,1)
    fps = DDS.fixed_points(logistic, param, order, (0,1); method=:DL)
    sfps = DDS.stable_fixed_points(logistic, param, order, (0,1); method=:DL)

    preinjections = Float64[]
    reinjections = Float64[]
    while length(preinjections) < 100*Ns
        x1 = rand() # rand from 0 to 1
        x2 = nth_logistic(x1, param)
        if abs(x0-x2) <= c && abs(x0-x1) > c
            # if (x1 > 0.1 && x1 < 0.9)
            push!(preinjections, x1)
            push!(reinjections, x2)
            # end
        end
    end

    fig = Figure(resolution=(1000,600))
    ax_aspect = 2
    identity_line = true

    ax = DDS.plot_nth_composition!(fig[1,1], logistic, LinRange(x_range..., 2000), param, order, identity_line;ax_aspect=ax_aspect)
    ax.ylabelsize = 25
    ax.xlabelsize = 25
    scatter!(ax, fps, Float64[nth_logistic(x, param) for x in fps], color=DDS.BLUE)
    scatter!(ax, sfps, Float64[nth_logistic(x, param) for x in sfps], color=DDS.RED)
    lines!(ax, [x0-c, x0+c], [0, 0], color=:LIGHTBLUE, linewidth=5.0)
    scatter!(ax, [x0], [0], color=:black, markersize=5.0)
    scatter!(ax, preinjections, Float64[nth_logistic(x, param) for x in preinjections], color=:red, markersize=7)
    scatter!(ax, reinjections, Float64[nth_logistic(x, param) for x in reinjections], color=:green, markersize=7)
    display(fig)
    reinjections = reinjections .- x0
end;

begin
    lbound = minimum(reinjections)
    rbound = maximum(reinjections)
    fig2 = Figure()
    ax = Axis(fig2[1,1])
    sort!(reinjections)
    points = Tuple{Float64, Float64}[]
    for r = 1:N
        x = rand_range(lbound, rbound)
        index = findfirst(y -> y >= x, reinjections)
        m = mean(reinjections[1:index])
        push!(points, (x, m))
    end
    scatter!(ax, points, markersize=5.0)
end

begin
    xdata = [point[1] for point in points]
    ydata = [point[2] for point in points]

    M(x, p) = p[1]*(x.-p[2]) .+ p[2]

    p0 = [0.0, 0.0]

    fit = curve_fit(M, xdata, ydata, p0)

    m = fit.param[1]
    xhat = fit.param[2]
    alpha = (2*m-1)/(1-m)
    x1, x2 = lbound, rbound
    lines!(ax, [x1, x2], [M(x1, fit.param), M(x2, fit.param)], color=:green)
    # scatter!(ax, points, color=:red)
    @info "m: $m, xhat: $xhat, alpha: $alpha"
    display(fig2)
end

begin
    lbound = xhat
    scatterhist(reinjections, bins=range(lbound, rbound, Ns), markersize=1, normalize=:true)
    a, b = lbound, rbound
    c = 1 / (((b-xhat)^(alpha+1)/(alpha+1) - (a-xhat)^(alpha+1)/(alpha+1)))
    func(x) = c*(x-xhat)^alpha
    plot!(range(lbound, rbound, Ns), func.(range(lbound, rbound, Ns)), color=:red)
end

begin
    x01 = 0.15992881844625645
    x02 = 0.5143552770619905
    x03 = 0.9563178419736238
    x0 = x03
    param = [3.8275]


    c = 0.005
    Ns = 1000
    N = 10000

    logistic = DDS.logistic
    order = 3
    nth_logistic = DDS.nth_composition(logistic, order)
    shift(x, param) = nth_logistic(x+x0, param) - x0
    

    e = shift(0, param)
    q = ForwardDiff.derivative(x -> shift(x, param), 0)
    a = ForwardDiff.derivative(y -> ForwardDiff.derivative(x -> shift(x, param), y), 0)/2



    fig = Figure(resolution=(1000,600))
    ax_aspect = 2
    identity_line = true

    ax = Axis(fig[1,1])
    s = 0.05
    range_ = LinRange(0-s, 0+s, 2000)
    # range_ = LinRange(0-x0, 1-x0, 2000)
    lines!(ax, range_, shift.(range_, param), color=:black)
    lines!(ax, range_, range_)
    lines!(ax, [0-c, 0+c], [-s, -s], color=:LIGHTBLUE, linewidth=5.0)
    scatter!(ax, [0], [-s], color=:black, markersize=5.0)


    preinjections, reinjections = DDS.injections(shift, 0, param, 100*Ns, 0-x0, 1-x0, c)
    l_mean = mean(DDS.laminar_length.(reinjections, c, e, a))
    println(l_mean)
    println(1/sqrt(abs(e)))
    println("")
    # scatter!(ax, preinjections, Float64[shift(x, param) for x in preinjections], color=:red, markersize=7)
    scatter!(ax, reinjections, Float64[shift(x, param) for x in reinjections], color=:green, markersize=7)
    lines!(ax, range_, e .+ q*range_ .+ a.*range_.^2, color=:red)
    display(fig)
end

begin
    Ns = 100
    p0 = 1+sqrt(8)
    es = Float64[]
    ls = Float64[]
    ps = [p0-1e-3, p0-1e-4, p0-1e-5, p0-1e-6, p0-1e-7, p0-1e-8]
    ps = p0 .- [rand(Uniform(1e-13, 1e-5)) for i = 1:50]
    for p in ps
        e = abs(shift(0, p))
        q = abs(ForwardDiff.derivative(x -> shift(x, p), 0))
        a = abs(ForwardDiff.derivative(y -> ForwardDiff.derivative(x -> shift(x, p), y), 0)/2)
        preinjections, reinjections = DDS.injections(shift, 0, p, 100*Ns, 0-x0, 1-x0, c)
        l_mean = mean(DDS.laminar_length.(reinjections, c, e, a))

        push!(es, e)
        push!(ls, l_mean)
    end

    fig2 = Figure()
    ax2 = Axis(fig2[1,1], xscale=log10, yscale=log10)
    # ax2 = Axis(fig2[1,1])

    model(x, p) = p[1]*x .+ p[2]
    fit = curve_fit(model, log.(es), log.(ls), [0.0, 0.0])
    a,b = fit.param
    lines!(ax2, es, es.^a * exp(b), color=:green)

    scatter!(ax2, es, ls, markersize = 20, color=:red)
    println(a)
    display(fig2)
end