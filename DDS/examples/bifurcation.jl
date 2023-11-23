using DynamicalSystems, CairoMakie

logistic_rule(x, p, n) = @inbounds SVector(p[1]*x[1]*(1-x[1]))
logistic = DeterministicIteratedMap(logistic_rule, [0.3], [4.0])

i = 1
parameter = 1
pvalues = 2.5:0.004:4
n = 2000
Ttr = 2000
output = orbitdiagram(logistic, i, parameter, pvalues; n, Ttr)

L = length(pvalues)
x = Vector{Float64}(undef, n*L)
y = copy(x)
for j in 1:L
    x[(1 + (j-1)*n):j*n] .= pvalues[j]
    y[(1 + (j-1)*n):j*n] .= output[j]
end

fig, ax = scatter(x, y; axis = (xlabel = L"r", ylabel = L"x"),
    markersize = 0.8, color = ("black", 0.05),
)
ax.title = "Logistic map orbit diagram"
xlims!(ax, pvalues[1], pvalues[end]); ylims!(ax,0,1)
fig