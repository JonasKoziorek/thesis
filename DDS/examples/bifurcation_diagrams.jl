using DDS

begin # logistic map
    x0 = 0.5
    p = [3.85]
    p_range = LinRange(3.5,3.572, 4000)
    DDS.bifurcation_diagram(DDS.logistic, x0, p, 1, p_range, 1000, 100; ax_aspect=2)
end

begin # logistic map in the negative range
    x0 = 0.5
    p = [3.85]
    p_range = LinRange(-1.75,-1.730, 8000)
    DDS.bifurcation_diagram(DDS.logistic, x0, p, 1, p_range, 1000, 100)
end

begin
    function sin_f(x, p)
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
    total_n = 1000
    last_n = 50
    x0 = 0.5
    p = [0.001]
    step = 0.001
    p_range = 0:step:4
    
    display(DDS.bifurcation_diagram(DDS.cos_f, x0, p, 1, p_range, total_n, last_n))
end