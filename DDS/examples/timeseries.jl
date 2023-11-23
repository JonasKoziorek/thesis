using DDS

begin # logistic map
    function logistic(x, p, n)
        x = x[1]
        r = p[1]
        return r*x*(1-x)
    end

    x0 = 0.5
    p = [3.85]
    N = 100
    DDS.timeseries(logistic, x0, p, N, 1)
end

begin # intermittency map, from Nonlinear Dynamics book
    function f(x, p, n)
        x = x[1]
        ϵ = p[1]
        return ((1+ϵ)*x + (1-ϵ)*x^2) % 1
    end

    x0 = 0.5
    p = [0.001]
    N = 500
    DDS.timeseries(f, x0, p, N, 1)
end

begin # intermittency in rulkov map
    function rulkov(u, p, n)
        x, y = u
        α, β, σ = p
        xn = α/(1.0+x^2) + y
        yn = y - σ*x - β
        return (xn, yn)
    end
    u0 = [0.0, -3.0]
    p0 = [4.1, 0.001, 0.001]
    N = 1000 
    display(DDS.timeseries(rulkov, u0, p0, N, 1)) # first dimension
    # display(DDS.timeseries(rulkov, u0, p0, N, 2)) # second dimension
end