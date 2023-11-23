using DDS

logistic = DDS.logistic

begin # logistic map
    x = 0:0.0001:1
    x0=0.5
    p = [3.737]
    total_n = 5
    DDS.plot_cobweb(logistic, x0, x, p, total_n;ax_aspect=1, resolution=(600,600))
end

begin # 3 period in logistic eq
    x = 0:0.0001:1
    x0=0.5
    p = [3.82845]
    total_n = 2000
    DDS.plot_cobweb(logistic, x0, x, p, total_n;ax_aspect=1, resolution=(600,600))
end

pomeau_manneville = DDS.pomeau_manneville

begin
    x = 0:0.0001:1.2
    x0=0.5
    p = [4.47458]
    total_n = 5
    DDS.plot_cobweb(pomeau_manneville, x0, x, p, total_n;ax_aspect=1, resolution=(600,600))
end

begin # showing cobweb for 3 periodic timeseries (just one dot since it's a fixed point)
    x = 0:0.0001:1
    x0=0.5
    p = [3.82845]
    total_n = 52
    n_order = 3
    starting_x = 1
    DDS.plot_cobweb(logistic, x0, x, p, total_n, n_order, starting_x;ax_aspect=1, resolution=(600,600))
end