using DDS

cos_f = DDS.cos_f

begin
    total_n = 1000
    last_n = 50
    x0 = 0.5
    p = [0.001]
    step = 1e-10
    p_range = 1.97428:step:1.9742835
end
    
display(DDS.bifurcation_diagram(cos_f, x0, p, 1, p_range, total_n, last_n))
display(DDS.timeseries_last_n(cos_f, x0,[1.974283], 10000, 3000, 1))
display(DDS.timeseries(cos_f, x0,[1.97427], 5000, 1))
display(DDS.timeseries_last_n(cos_f, x0,[1.97427], 5100, 500, 1))