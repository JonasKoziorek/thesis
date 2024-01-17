using CairoMakie

begin
    total_n = 1000
    last_n = 200
    p_range = LinRange(3.82835, 3.8285, 2000)
    figure = Figure()
    left_p = 1+sqrt(8)-2.5*1e-5
    right_p = 1+sqrt(8)-1e-6
    bif_point = 0.15992881844625645
    n_order = 3
    ax = DDS.colorize_bif_diag!(figure[1,1], logistic, 0.5, param, 1, p_range, n_order, total_n, last_n, left_p, right_p, bif_point;param_name="")
    ax.xlabel = ""
    ax.ylabel = ""
    display(figure)
end