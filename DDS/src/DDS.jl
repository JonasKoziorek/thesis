module DDS

using CairoMakie, Luxor 
using ForwardDiff, IntervalRootFinding, IntervalArithmetic

include("selected_colors.jl")
include("general.jl")
include("models.jl")
include("nthcomposition.jl")
include("cobweb.jl")
include("bifurcation.jl")
include("timeseries.jl")
include("fixedpoints.jl")

const FIGURES_DIRECTORY = "./Figures/"

end # module DDS
