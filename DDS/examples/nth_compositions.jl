using DDS

logistic = DDS.logistic

begin # logistic map
    x = 0:0.0001:1
    p = [3.737]
    total_n = 5
    identity_line = true
    DDS.plot_nth_composition(logistic, x, p, total_n, identity_line; ax_aspect=1)
end

begin
    x = LinRange(0, 1, 1000)
    p = [3.6]
    total_n = 8
    DDS.plot_nth_composition(logistic, x, p, total_n; ax_aspect=1)
end