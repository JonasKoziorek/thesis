# this is how func param should look like
# function f(x, p, n)
#   x ... vector of variables
#   p ... vector of parameters
#   n ... current time 
#   return new iteration based of x based on evolution rule 
# end

function iterate(func::F, x0, p, n::Int64) where {F<:Function}
    container = Vector{typeof(x0)}(undef, n+1)
    iterate!(func, x0, p, n, container)
    return container
end

function iterate!(map::F, x0, p, n, container) where {F<:Function}
    container[1] = x0
    for i = 2:n+1
        container[i] = map(container[i-1], p)
    end
end

function jacobian(map)
    return (x, p) -> ForwardDiff.derivative(x0->map(x0, p), x)
end

function is_stable(map, x0, p)
    J = jacobian(map)
    return abs(J(x0, p)) < 1
end