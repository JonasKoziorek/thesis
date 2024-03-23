using DDS
using CairoMakie

begin
    logistic = DDS.logistic
    LATEX_FONT_SIZE = 27
    FONTSIZE = 18

    fig = Figure(
        resolution = (800, 500),
        fontsize=FONTSIZE,
    )
    ax = Axis(fig[1,1])

    logistic = DDS.logistic

    order = 40
    points = Vector{Tuple{Float64, Float64}}[Tuple{Float64, Float64}[] for i in 1:order]
    points2 = Tuple{Float64, Float64}[]

    total_n = 2000
    last_n = 200

    x0 = 0.5
    param = [3.0]
    param_range = LinRange(3.55, 3.75, 5000)

    for p in param_range 
        x1 = DDS.iterate(logistic, x0, p, total_n-last_n)[end]
        for o in 1:order
            traj = DDS.iterate(logistic, x1, p, o)
            x2 = traj[end]
            if x1 == x2
                for x in traj
                    push!(points[o], (p, x))
                end
                break
            end
        end
        traj = DDS.iterate(logistic, x0, p, total_n)[end-last_n:end]
        for x in traj
            push!(points2, (p, x))
        end
    end

    ax.aspect = 1.6
    ax.xlabel = L"r"
    ax.ylabel = L"\mathcal{T}_{%$(total_n-last_n)}^{%$(total_n)}(\mathcal{L}_{r}, %$(x0))"
    ax.xlabelsize = LATEX_FONT_SIZE
    ax.ylabelsize = LATEX_FONT_SIZE

    scatter!(ax, points2, color=:grey, markersize=0.4)
    for o in 1:order
        if !isempty(points[o])
            scatter!(ax, points[o], color=:blue, markersize=3.5)
        end
    end
    display(fig)

    file_path = DDS.FIGURES_DIRECTORY * "naive_global_search.png"
    save(file_path, fig)
end