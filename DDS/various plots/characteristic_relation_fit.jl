using DDS
using CairoMakie
using Distributions: Uniform
using ForwardDiff
using LsqFit: curve_fit

function mean(x)
    return sum(x)/length(x)
end

begin
    x01 = 0.15992881844625645
    x02 = 0.5143552770619905
    x03 = 0.9563178419736238
    x0s = [x01, x02, x03]
    names = ["characteristic_relation_fit{$i}.png" for i = 1:3]
    for (x0, name) in zip(x0s, names)
        generate_plot(x0, name)
    end
end

function generate_plot(x0, name)
    LATEX_FONT_SIZE = 33
    FONTSIZE = 25
    RESOLUTION = (720, 700)
    POINT_SIZE = 18
    LINEWIDTH = 6

    logistic = DDS.logistic
    order = 3
    nth_logistic = DDS.nth_composition(logistic, order)
    shift(x, param) = nth_logistic(x+x0, param) - x0
    
    p0 = 1+sqrt(8)

    fig = Figure(fontsize=FONTSIZE, resolution=RESOLUTION)
    ax = Axis(fig[2,1], xscale=log10, yscale=log10)

    N = 4000
    num_points = 30
    cs = [0.01, 0.03, 0.05, 0.07]
    colors = [BLUE, GREEN, ORANGE, PURPLE]
    ps = p0 .- [rand(Uniform(1e-13, 1e-5)) for i = 1:num_points]
    labels = []
    for (c, color) in zip(cs,colors)
        label = plot_line(ax, shift, POINT_SIZE, LINEWIDTH, c, color, ps, N, x0)
        push!(labels, label)
    end

    group_color = [PolyElement(color = color, strokecolor = :transparent) for color in colors]
    Legend(fig[1, 1], group_color, labels, framevisible = true, orientation=:horizontal, nbanks=1)


    ax.xlabel = L"$log_{10}(\varepsilon)$"
    ax.ylabel = L"$log_{10}(l_{avg})$"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE

    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * name
    save(file_path, fig)

end

function plot_line(ax, shift, POINT_SIZE, LINEWIDTH, c, color, ps, N, x0)
    es = Float64[]
    ls = Float64[]
    for p in ps
        e = abs(shift(0, p))
        a = abs(ForwardDiff.derivative(y -> ForwardDiff.derivative(x -> shift(x, p), y), 0)/2)
        preinjections, reinjections = DDS.injections(shift, 0, p, N, 0-x0, 1-x0, c)
        l_mean = mean(DDS.laminar_length.(reinjections, c, e, a))

        push!(es, e)
        push!(ls, l_mean)
    end

    model(x, p) = p[1]*x .+ p[2]
    fit = curve_fit(model, log.(es), log.(ls), [0.0, 0.0])
    a,b = fit.param
    a_rounded = round(a, digits=3)
    b_rounded = round(b, digits=3)
    label = "s = $(a_rounded)\nc = $(c)"
    lines!(ax, es, es.^a * exp(b), color=color, linewidth=LINEWIDTH)
    scatter!(ax, es, ls, color=RED, markersize=POINT_SIZE)
    return label
end