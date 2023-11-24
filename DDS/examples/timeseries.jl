using DDS

begin # logistic map
    x0 = 0.5
    p = [3.85]
    N = 100
    DDS.timeseries(DDS.logistic, x0, p, N, 1)
end

begin # intermittency map, from Nonlinear Dynamics book
    x0 = 0.5
    p = [0.001]
    N = 500
    DDS.timeseries(DDS.pomeau_manneville, x0, p, N, 1)
end

begin # intermittency in rulkov map
    u0 = [0.0, -3.0]
    p0 = [4.1, 0.001, 0.001]
    N = 1000 
    display(DDS.timeseries(DDS.rulkov, u0, p0, N, 1)) # first dimension
    # display(DDS.timeseries(rulkov, u0, p0, N, 2)) # second dimension
end