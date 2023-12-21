# using BifurcationKit, Setfield, Plots

# # Define the logistic map as a continuous system
# function logistic_map!(du, u, p, t=0)
#     r = p.r
#     x = u[1]
#     du[1] = r * x * (1 - x) - x
#     du
# end

# begin
#     # Initial condition and parameter value
#     u0 = [0.5]
#     par = 2.2
#     pars = (r = par, )

#     # Define the bifurcation problem
#     lens = @lens _.r
#     optnewton = NewtonPar(tol = 1e-9, max_iterations = 15)
#     optcont = ContinuationPar(max_steps = 1000, p_min = par, p_max = 4.0, newton_options = optnewton)
#     prob = BifurcationProblem(logistic_map!, u0, pars, lens)

#     # Compute the bifurcation diagram
#     br = continuation(prob, PALC(), optcont)
#     plot(br)

#     # # Extract the solutions and parameter values
#     # solutions = [point.x[1] for point in br.sol]
#     # r_values = [point.p for point in br.sol]

#     # # Plot the bifurcation diagram
#     # scatter(r_values, solutions, markersize = 2.0, legend = false, xlabel="r", ylabel="x", title="Bifurcation Diagram")
# end

# using BifurcationKit
# using Plots
# using Parameters

# function pp2!(dz, z, p, t = 0)
# 	@unpack r = p
#     x = z[1]
#     dz[1] = r * x * (1-x) - x
# 	dz
# end

# begin
#     u0 = [0.4]
#     pars = (r=3.1,)
#     lens = (@lens _.r)
#     optnewton = NewtonPar(tol = 1e-9, max_iterations = 20)
#     optcont = ContinuationPar(max_steps = 150, p_min = 0.5, p_max = 4.0,newton_options =optnewton)
#     prob = BifurcationProblem(pp2!, u0, pars, lens)
#     br = continuation(prob, Natural(), optcont; plot = true)
#     plot(br)
# end

# begin
#     # continuation options
#     opts_br = ContinuationPar(p_min = 0.1, p_max = 1.0, dsmax = 0.01,
#         # options to detect bifurcations
#         detect_bifurcation = 3, n_inversion = 8, max_bisection_steps = 25,
#         # number of eigenvalues
#         nev = 2,
#         # maximum number of continuation steps
#         max_steps = 1000,)

#     diagram = bifurcationdiagram(prob, PALC(),
#         # very important parameter. It specifies the maximum amount of recursion
#         # when computing the bifurcation diagram. It means we allow computing branches of branches of branches
#         # at most in the present case.
#         3,
#         (args...) -> setproperties(opts_br; ds = -0.001, dsmax = 0.01, n_inversion = 8, detect_bifurcation = 3);
#         # δp = -0.01,
#         verbosity = 0, plot = false)
#     scene = plot(diagram; code = (), title="$(size(diagram)) branches", legend = false)
# end

# PALC(), Multiple()

using ForwardDiff
using LinearAlgebra
using Plots

function predictor_corrector(f, df, x0, p0, dp, n_steps)
    x = x0
    p = p0

    # Store solutions
    solutions = [(x, p)]

    for i in 1:n_steps
        # Predictor Step
        x_pred = x + dp * df(x, p)
        p += dp

        # Corrector Step (Newton's method)
        for j in 1:10
            dx = -(f(x_pred, p) - x_pred) / (df(x_pred, p) - 1)
            x_pred += dx

            if norm(dx) < 1e-6
                break
            end
        end

        x = x_pred
        push!(solutions, (x, p))
    end

    return solutions
end

# Define your map and its derivative
f(x, p) = p*x*(1-x)-x
df = (x, p) ->ForwardDiff.derivative(u->f(u, p), x)

begin
    x_values = Float64[]
    p_values = Float64[]

    # Initial condition and parameter value
    x0 = 0.2
    p0 = 3.31
    # Parameter step size
    dp = 0.01
    # Number of steps
    n_steps = 400

    solutions = predictor_corrector(f, df, x0, p0, dp, n_steps)
    append!(x_values, [x for (x, p) in solutions])
    append!(p_values, [p for (x, p) in solutions])

    # Create a scatter plot
    scatter(p_values, x_values, xlabel="p", ylabel="x", title="Bifurcation Diagram")
end