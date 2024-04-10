module DDS

using CairoMakie, Luxor 
using ForwardDiff
using Distributions: Uniform
using LinearAlgebra: norm

include("selected_colors.jl")
include("general.jl")
include("models.jl")
include("nthcomposition.jl")
include("cobweb.jl")
include("bifurcation.jl")
include("trajectory.jl")
include("fixedpoints.jl")
include("localize_bifurcations.jl")
include("NLS.jl")
include("colorize_bifurcation_diag.jl")
include("NLPSO.jl")
include("intermittency.jl")

const FIGURES_DIRECTORY = "../Figures/"

end # module DDS
