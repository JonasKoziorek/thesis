using DDS

begin # logistic map
    function logistic(x, p, n)
        x = x[1]
        r = p[1]
        return r*x*(1-x)
    end

    x0 = 0.5
    p = [3.85]
    p_range = -2:0.001:4
    DDS.bifurcation_diagram(logistic, x0, p, 1, p_range, 1000, 50)
end

begin
    function sin_f(x, p, n)
        x = x[1]
        r = p[1]
        return r*sin(x)
    end

    x0 = 0.5
    p = [0.001]
    p_range = 0:0.001:4
    DDS.bifurcation_diagram(sin_f, x0, p, 1, p_range, 1000, 50)
end

begin
    function cos_f(x, p, n)
        x = x[1]
        r = p[1]
        return (r)*cos(pi*x)
    end

    total_n = 1000
    last_n = 50
    x0 = 0.5
    p = [0.001]
    step = 0.001
    p_range = 0:step:4
    
    display(DDS.bifurcation_diagram(cos_f, x0, p, 1, p_range, total_n, last_n))
end