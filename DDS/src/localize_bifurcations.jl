function find_change(periodic_orbits, params, infty)
    ranges = Tuple{Float64, Float64, Int64}[]
    prev_o = periodic_orbits[1]
    for i in 2:length(periodic_orbits)
        new_o = periodic_orbits[i]
        # if prev_o != new_o
        if prev_o == infty && new_o != infty
            push!(ranges, (params[i-1], params[i], new_o)) 
        end
        prev_o = new_o
    end
    return ranges
end

function localize_bifurcation(map, param_index, param_range, orbit_order_limit, x_range)
    periodic_orbits = [
        find_order(map, x_range, orbit_order_limit, param_index, [param]) for param in param_range
    ]
    infty = orbit_order_limit + 1
    return find_change(periodic_orbits, param_range, infty)
end

function find_order(map, x_range, orbit_order_limit, param_index, param)
    for o in 1:orbit_order_limit
        sfps = stable_fixed_points(map, param, o, x_range)
        len = length(sfps)
        if len == o
            return len
        end
    end
    return orbit_order_limit + 1
end

# function natural_divisors(n::Integer)
#     # finds all natural divisors of n
#     divisors = [i for i in 1:div(n, 2) if n%i==0]
#     push!(divisors, n) # n is also divisor
#     return reverse(divisors)
# end

# function new_find_order(ds, x_range, orbit_order_limit, param_index, param)
#     set_parameter!(ds, param_index, param)
#     for o in orbit_order_limit:-1:1
#         sfps = stable_fixed_points(ds, o, x_range; roundtol=4)
#         l = length(sfps)
#         possible_sub_orders = natural_divisors(o)
#         for sub_o in possible_sub_orders
#             if sub_o == l
#                 return sub_o
#             end
#         end
#     end
#     return orbit_order_limit + 1
# end

# function new_localize_bifurcation(ds, param_index, param_range, orbit_order_limit, x_range)
#     periodic_orbits = [
#         new_find_order(ds, x_range, orbit_order_limit, param_index, param) for param in param_range
#     ]
#     return find_change(periodic_orbits, param_range)
# end