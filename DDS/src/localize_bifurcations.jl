function find_change(map, x_range, periodic_orbits, params, infty)
    ranges = Tuple{Float64, Float64, Int64}[]
    prev_o = periodic_orbits[1]
    for i in 2:length(periodic_orbits)
        new_o = periodic_orbits[i]
        # if prev_o != new_o
        if prev_o == infty && new_o != infty
            # push!(ranges, (params[i-1], params[i], new_o)) 
            prev_p = [params[i-1]]
            if confirm_order(map, x_range, infty-1, 1, prev_p) == prev_o
                push!(ranges, (params[i-1], params[i], new_o)) 
            end
        end
        prev_o = new_o
    end
    return ranges
end

function localize_bifurcation(map_, x0, param_index, param_range, orbit_order_limit, x_range)
    periodic_orbits = Vector{Int64}(undef, length(param_range))
    results = parallel_order_finding(param_range, map_, x0, x_range, orbit_order_limit, param_index)
    # results = order_finding(param_range, map_, x0, x_range, orbit_order_limit, param_index)
    collect_results!(periodic_orbits, results)
    infty = orbit_order_limit + 1
    return find_change(map_, x_range, periodic_orbits, param_range, infty)
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

function parallel_order_finding(param_range, map_, x0, x_range, orbit_order_limit, param_index)
    chunks = Iterators.partition(param_range, length(param_range) ÷ Threads.nthreads())
    tasks = map(chunks) do chunk
        Threads.@spawn [guess_order(deepcopy(map_), deepcopy(x0), param, deepcopy(orbit_order_limit)) for param in chunk]
    end
    results = fetch.(tasks)
    return results
end

function order_finding(param_range, map_, x0, x_range, orbit_order_limit, param_index)
    return [[guess_order(deepcopy(map_), deepcopy(x0), param, deepcopy(orbit_order_limit))] for param in param_range]
end

function guess_order(map, x0, params, max_order, tol=1e-8)
    for o = 1:max_order
        nth_map = nth_composition(map, o)
        x = iterate(map, x0, params, 1000)[end]
        if abs(nth_map(x, params) - x) < tol
            return o
        end
    end
    return max_order+1
end

function confirm_order(map, x_range, orbit_order_limit, param_index, param)
    for o in 1:orbit_order_limit
        sfps = stable_fixed_points(map, param, o, x_range)
        len = length(sfps)
        if 0 < len <= o # if number of stable fixed points is positive but lesser than current order we take it since there might have been a mistake before
            return len
        end
    end
    return orbit_order_limit + 1
end
