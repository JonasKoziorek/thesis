function logistic(x, p)
    x = x[1]
    r = p[1]
    return r*x*(1-x)
end

function henon(x, p)
    x, y = x
    a, b = p
    xn = 1 - a*x^2 + y
    yn = b*x
    return [xn, yn]
end

function pikovsky(z, p)
    z = z[1]
    b = p[1]
    f(z) = z^(0.1) + b*z -1
    return  z > 0 ? f(z) : -f(-z) 
end

function pomeau_manneville(x, p)
    x = x[1]
    ϵ = p[1]
    return ((1+ϵ)*x + (1-ϵ)*x^2) % 1
end

function cos_f(x, p)
    x = x[1]
    r = p[1]
    return (r)*cos(pi*x)
end

function rulkov(u, p)
    x, y = u
    α, β, σ = p
    xn = α/(1.0+x^2) + y
    yn = y - σ*x - β
    return [xn, yn]
end

function standard(x, p)
    x, y = x
    k = p[1]
    xn = x + y + k*sin(x)
    yn = y + k*sin(x)
    return [xn, yn]
end

# source:
# Natiq, H., Roy, A., Banerjee, S. et al. Enhancing chaos in multistability regions of Duffing map for an image encryption algorithm
# equation 1
# cannot find original source of this equation

function duffing(x, p)
    x, y = x
    a, b = p
    xn = y
    yn = -b*x + a*y - y^3
    return [xn, yn]
end