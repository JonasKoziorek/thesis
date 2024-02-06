using DDS
using Metaheuristics
using LinearAlgebra
using ForwardDiff

function F_pp(p, n)
    func = DDS.nth_composition(DDS.logistic, n)
    res = let p = p, func = func
        x -> norm(func(x[1], p) - x[1])
    end
    return res
end

function F_bif(n)
    res = let n=n
        function func(p)
            f_pp = F_pp(p, n)
            bounds = BoxConstrainedSpace(lb = [0.0], ub = [1.0])
            # x = optimize(f_pp, bounds, PSO(N = 10, C1=1.494, C2=1.494, ω = 0.729, options=Options(iterations=100, f_tol=1e-5), information=Information(f_optimum=0.0))).best_sol.x
            x = optimize(f_pp, bounds, PSO(N = 10, C1=1.494, C2=1.494, ω = 0.729, options=Options(iterations=100))).best_sol.x
            cost :: Float64 = Inf
            func = (x,p) -> [DDS.nth_composition(DDS.logistic, n)(x, p)]
            if f_pp(x) <= 1e-5
                cost = abs(det(ForwardDiff.jacobian(x0->func(x0, p), x)-1*I))
            end
            return cost
        end
    end
    return res
end

f = F_pp(3.235, 3)
bounds = BoxConstrainedSpace(lb = [0.0], ub = [1.0])
@time result = optimize(f, bounds, PSO(N = 10, C1=1.494, C2=1.494, ω = 0.729, options=Options(iterations=100, f_tol=1e-5)))
x = result.best_sol.x


begin
    # n = 12
    # bounds = BoxConstrainedSpace(lb=[3.581], ub=[3.5825])

    n = 3
    bounds = BoxConstrainedSpace(lb=[3.825], ub=[3.83])
    f = F_bif(n)
    @time result = optimize(f, bounds, PSO(N = 30, C1=1.494, C2=1.494, ω = 0.729, options=Options(iterations=300, f_tol=1e-5), information=Information(f_optimum=0.0)))
end


# -------------- henon -----------------------
function F_pp(p, n)
    func = DDS.nth_composition(DDS.henon, n)
    res = let p = p, func=func
        x -> norm(func(x, p) - x)
    end
    return res
end

function F_bif(n)
    res = let n=n
        function func(p)
            f_pp = F_pp(p, n)
            bounds = BoxConstrainedSpace(lb = [-2.0; -2.0], ub = [2.0; 2.0])
            x = optimize(f_pp, bounds, PSO(N = 10, C1=1.494, C2=1.494, ω = 0.729, options=Options(iterations=100, f_tol=1e-5))).best_sol.x
            cost :: Float64 = Inf
            func = (x,p) -> DDS.nth_composition(DDS.henon, n)(x, p)
            if f_pp(x) <= 1e-5
                cost = abs(det(ForwardDiff.jacobian(x0->func(x0, p), x)-1*I))
            end
            return cost
        end
    end
    return res
end

n = 4
param = [1.3, 0.3]
f = F_pp(param, n)
@time f(param)
nth_func = DDS.nth_composition(DDS.henon, n)

# n = 12
# bounds = BoxConstrainedSpace(lb=[3.581], ub=[3.5825])

n = 7
f = F_bif(n)
bounds = BoxConstrainedSpace(lb = [1.44; 0.08], ub = [1.55; 0.28])
@time result = optimize(f, bounds, PSO(N = 10, C1=1.5, C2=1.5, ω = 0.7, options=Options(iterations=100, f_tol=1e-5), information=Information(f_optimum=0.0)))
p = result.best_sol.x









function F_bif(n, method)
    res = let n=n
        function func(p)
            f_pp = F_pp(p, n)
            bounds = BoxConstrainedSpace(lb = [-2.0; -2.0], ub = [2.0; 2.0])
            x = optimize(f_pp, bounds, method).best_sol.x
            cost :: Float64 = Inf
            func = (x,p) -> DDS.nth_composition(DDS.henon, n)(x, p)
            if f_pp(x) <= 1e-5
                cost = abs(det(ForwardDiff.jacobian(x0->func(x0, p), x)-1*I))
            end
            return cost
        end
    end
    return res
end

function F_pp(p, n)
    func = DDS.nth_composition(DDS.logistic, n)
    res = let p = p, func = func
        x -> norm(func(x[1], p) - x[1])
    end
    return res
end

function F_bif(n)
    res = let n=n
        function func(p)
            f_pp = F_pp(p, n)
            bounds = BoxConstrainedSpace(lb = [0.0], ub = [1.0])
            x = optimize(f_pp, bounds, PSO(N = 10, C1=1.494, C2=1.494, ω = 0.729, options=Options(iterations=100, f_tol=1e-5), informations=Information(f_optimum=0.0))).best_sol.x
            cost :: Float64 = Inf
            func = (x,p) -> [DDS.nth_composition(DDS.logistic, n)(x, p)]
            if f_pp(x) <= 1e-5
                cost = abs(det(ForwardDiff.jacobian(x0->func(x0, p), x)-1*I))
            end
            return cost
        end
    end
    return res
end


f = F_pp(3.235, 3)
@time f(0.7)
bounds = BoxConstrainedSpace(lb = [0.0], ub = [1.0])
@time result = optimize(f, bounds, PSO(N = 10, C1=1.494, C2=1.494, ω = 0.729, options=Options(iterations=100, f_tol=1e-5), information=Information(f_optimum=0.0)))
x = result.best_sol.x


begin
    # n = 12
    # bounds = BoxConstrainedSpace(lb=[3.581], ub=[3.5825])

    n = 3
    bounds = BoxConstrainedSpace(lb=[3.825], ub=[3.83])
    f = F_bif(n)
    @time result = optimize(f, bounds, PSO(N = 30, C1=1.494, C2=1.494, ω = 0.729, options=Options(iterations=300, f_tol=1e-5), information=Information(f_optimum=0.0)))
end