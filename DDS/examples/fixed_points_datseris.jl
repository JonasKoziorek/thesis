using ChaosTools
using DDS

inds, signs = lambdaperms(2)
for ind in inds, sign in signs
    display(lambdamatrix(0.99, ind, sign))
end

function diff(x, r)
    return r-2*r*x
end

function logistic(x, k, n)
    x = x[1]
    r = k[1]
    return SVector(r*x*(1.0-x))
end
p = 3.816
logisticmap = DeterministicIteratedMap(logistic, 0.5, p)
lambda = 0.001
inds, signs = lambdaperms(1)
order = 7
fps = periodicorbits(logisticmap, order, [SVector(i) for i in LinRange(0, 1, 80)], lambda, inds, signs).data
fps = [i[1][1] for i in fps]


DDS.plot_cobweb(DDS.logistic, 0.5, LinRange(0,1,1000), p, 1, order;ax_aspect=1, resolution=(600,600))



function standardmap_rule(x, k, n)
    theta = x[1]; p = x[2]
    p += k[1]*sin(theta)
    theta += p
    return SVector(mod2pi(theta), mod2pi(p))
end

standardmap = DeterministicIteratedMap(standardmap_rule, rand(2), [1.5])
xs = range(0, stop = 2π, length = 11); ys = copy(xs)
ics = [SVector{2}(x,y) for x in xs for y in ys]

# All permutations of [±1, ±1]:
singss = lambdaperms(2)[2] # second entry are the signs

# I know from personal research I only need this `inds`:
indss = [[1,2]] # <- must be container of vectors!

λs = 0.005 # <- only this allowed to not be vector (could also be vector)

orders = [2, 3, 4, 5, 6, 8]
ALLFP = Dataset{2, Float64}[]

standardmap

for o in orders
    FP = periodicorbits(standardmap, o, ics, λs, indss, singss)
    push!(ALLFP, FP)
end

using CairoMakie
iters = 1000
dataset = trajectory(standardmap, iters)[1]
for x in xs
    for y in ys
        append!(dataset, trajectory(standardmap, iters, [x, y])[1])
    end
end

fig = Figure()
ax = Axis(fig[1,1]; xlabel = L"\theta", ylabel = L"p",
    limits = ((xs[1],xs[end]), (xs[1],xs[end]))
)
scatter!(ax, dataset[:, 1], dataset[:, 2]; markersize = 1, color = "black")
fig

markers = [:diamond, :utriangle, :rect, :pentagon, :hexagon, :circle]

for i in 1:6
    FP = ALLFP[i]
    o = orders[i]
    scatter!(ax, columns(FP)...; marker=markers[i], color = Cycled(i),
        markersize = 30 - 2i, strokecolor = "grey", strokewidth = 1, label = "order $o"
    )
end
axislegend(ax)
fig