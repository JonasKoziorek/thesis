function injections(map, xbif, param, N, l, r, c)
    preinjections = Vector{Float64}(undef, N)
    reinjections = Vector{Float64}(undef, N)
    i=1
    while i <= N
        x1 = rand(Uniform(l, r))
        x2 = map(x1, param)
        if abs(xbif-x2) <= c && abs(xbif-x1) > c
            preinjections[i]= x1
            reinjections[i]= x2
            i+=1
        end
    end
    return preinjections, reinjections
end

function laminar_length(x, c, e, a)
   return 1 / (sqrt(a*e)) * (atan(sqrt(a/e)*c) - atan(sqrt(a/e)*x))    
end