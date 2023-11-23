using DDS

# map from intermittent transition to turbulance in dissipative dynamical systems from pomeau and manneville
function f1(x, p, n)
    x = x[1]
    ϵ = p[1]
    return ϵ+x+x^2
end

begin # it diverges
    x0 = -0.5
    p = [0.02]
    N = 2000
    DDS.timeseries(f1, x0, p, N, 1; markersize=5.0)
end

begin # showing laminar phase and turbulent phase
    x = -0.8:0.0001:1
    x0 = -0.5
    p = [0.02]
    total_n = 20
    DDS.plot_cobweb(f1, x0, x, p, total_n;ax_aspect=1, resolution=(600,600))
end

begin # it diverges
    total_n = 200
    last_n =  20

    x0 = -0.5
    p = [0.02]
    p_range = LinRange(0.01, 0.02, 2000)
    param_index = 1
    index_x = 1
    DDS.bifurcation_diagram(f1, x0, p, 1, p_range, total_n, last_n, index_x)
end