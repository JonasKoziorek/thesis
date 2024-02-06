using StaticArrays

function func2(f::F, x) where {F<:Function}
    return f(x)
end

function func3(f::F) where {F<:Function}
    x = [1,2]
    @time result = func2(f, x)
    return result
end

function test()
    func(x) = MVector(x[1]+x[2])
    func3(func)
end

function test2()
    x = [1,2]
    func4(x) = MVector(x[1]+x[2])
    @time result = func4(x)
    return result
end

test()
test2()