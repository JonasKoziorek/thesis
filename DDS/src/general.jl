# this is how func param should look like
# function f(x, p, n)
#   x ... vector of variables
#   p ... vector of parameters
#   n ... current time 
#   return new iteration based of x based on evolution rule 
# end

function iterate(func, x0, params, total_n::Int64)
    if total_n == 0
        return x0
    else
        results = []
        step!(results, func, x0, params)
        for t=2:total_n
            step!(results, func, last(results), params)
        end
        return results
    end
end

function iterate!(map, x0, p, n, container)
    container[1] = x0
    x = x0
    for i = 2:n+1
        x = map(x, p)
        container[i] = x
    end
end

function step(func, previous_x, params)
    new_x = func(previous_x, params)
    return new_x
end

function step!(container, func, previous_x, params)
    push!(container, step(func, previous_x, params))
end