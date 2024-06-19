using DDS

function find_change(periodic_orbits, params, infty)
    ranges = Tuple{Float64, Float64, Int64}[]
    prev_o = periodic_orbits[1]
    for i in 2:length(periodic_orbits)
        new_o = periodic_orbits[i]
        if prev_o == infty && new_o != infty
            push!(ranges, (params[i-1], params[i], new_o)) 
        end
        prev_o = new_o
    end
    return ranges
end

function localize_bifurcation(map_, param, x0, param_index, param_range, orbit_order_limit)
    periodic_orbits = Vector{Int64}(undef, length(param_range))
    results = order_finding(param, param_range, map_, x0, orbit_order_limit, param_index)
    collect_results!(periodic_orbits, results)
    infty = orbit_order_limit + 1
    return find_change(periodic_orbits, param_range, infty)
end

function collect_results!(periodic_orbits::Vector{Int64}, results::Vector{Vector{Int64}})
    i = 1
    for result in results
        for o in result
            periodic_orbits[i] = o
            i += 1
        end
    end
end

function order_finding(param, param_range, map_, x0, orbit_order_limit, param_index)
    arr = Vector{Int64}[]
    for i in eachindex(param_range)
        param[param_index] = param_range[i]
        push!(arr, [guess_order(map_, x0, param, orbit_order_limit)])
    end
    return arr
end

function guess_order(map, x0, params, max_order, tol=1e-8)
    for o = 1:max_order
        nth_map = DDS.nth_composition(map, o)
        x = DDS.iterate(map, x0, params, 1500)[end]
        if DDS.norm(nth_map(x, params) - x) < tol
            return o
        end
    end
    return max_order+1
end


begin # bifurcation diagram
    henon = DDS.henon
    total_n = 1000
    last_n = 50

    x0 = [0.0, 0.0]
    p = [0.0, 0.3]

    step = 1e-4
    p_range = LinRange(1.0, 1.4, 800)

    x_index = 1
    p_index = 1
    # display(DDS.bifurcation_diagram(henon, x0, p, p_index, p_range, total_n, last_n, x_index))

    bifurcation_intervals = localize_bifurcation(henon, p, x0, p_index, p_range, 20)

    fig = Figure()
    param_range2 = LinRange(p_range[1], p_range[end], 1000)
    total_n = 1000
    last_n = 100
    ax = DDS.bifurcation_diagram!(fig[1,1], henon, x0, p, p_index, param_range2, total_n, last_n, x_index;ax_aspect=2)
    colors = [:red, :red]
    i = 0
    x_range = [-0.5, 0.5]
    for (l, r, _) in bifurcation_intervals
        color = colors[i%2+1]
        lines!(ax, [l, l], [x_range...], color=color)
        lines!(ax, [r, r], [x_range...], color=color)
        i+=1
    end
    display(fig)
end

begin
    duffing = DDS.duffing
    total_n = 1000
    last_n = 50

    x0 = [-1.0, 0.0]
    p0 = [2.75, 0.0001]
    p_range = LinRange(2.3, 2.5, 500)
    x_index = 2
    p_index = 1

    bifurcation_intervals = localize_bifurcation(duffing, p0, x0, p_index, p_range, 20)

    fig = Figure()
    param_range2 = LinRange(p_range[1], p_range[end], 1000)
    total_n = 1000
    last_n = 100
    ax = DDS.bifurcation_diagram!(fig[1,1], duffing, x0, p0, p_index, param_range2, total_n, last_n, x_index;ax_aspect=2)
    colors = [:red, :red]
    i = 0
    x_range = [-0.0, 1.5]
    for (l, r, _) in bifurcation_intervals
        color = colors[i%2+1]
        lines!(ax, [l, l], [x_range...], color=color)
        lines!(ax, [r, r], [x_range...], color=color)
        i+=1
    end
    display(fig)
end