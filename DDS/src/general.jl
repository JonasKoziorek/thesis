# this is how func param should look like
# function f(x, p, n)
#   x ... vector of variables
#   p ... vector of parameters
#   n ... current time 
#   return new iteration based of x based on evolution rule 
# end

function iterate(func, x0, p, n::Int64)
    container = Vector{typeof(x0)}(undef, n+1)
    iterate!(func, x0, p, n, container)
    return container
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

function jacobian(map)
    return (x, p) -> ForwardDiff.derivative(x0->map(x0, p), x)
end

function is_stable(map, x0, p)
    J = jacobian(map)
    return abs(J(x0, p)) < 1
end