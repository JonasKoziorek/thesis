using DDS
using CairoMakie

# estimation of periodic point
begin
    param = (3.235)
    n = 3

    x_range = [0.0, 1.0]
    num_particles = 30
    num_iterations = 300
    w = 0.729
    c1 = 1.494
    c2 = c1
    tol = 1e-5

    @time best_position, best_score = DDS.inner_NLPSO(n, param, x_range, num_particles, num_iterations, w, c1, c2, tol)
    println("Best position: ", best_position)
    println("Best score: ", best_score)
end

# estimation of saddle node bifurcation parameter
begin
    C_pp = 1e-5
    C_bif = 1e-5

    # param_range = [3.825, 3.83]
    # n = 3


    param_range = [3.581, 3.5825]
    n = 12

    # param_range = [3.700, 3.702]
    # n = 7


    num_particles = 30
    num_iterations = 300
    w = 0.729
    c1 = 1.494
    c2 = c1

    @time best_position, best_score = DDS.NLPSO(n, param_range, num_particles, num_iterations, w, c1, c2, C_bif)
    println("Best position: ", best_position)
    println("Best score: ", best_score)

    
    p_range = LinRange(param_range..., 2000)
    fig = Figure()
    ax = DDS.bifurcation_diagram!(
        fig[1,1], 
        DDS.logistic,
        0.5,
        [3.8],
        1, 
        p_range, 
        1000,
        100,
        1
    )
    lines!(ax, [best_position, best_position], [x_range...], color=DDS.BLUE, linewidth=3)
    display(fig)
end