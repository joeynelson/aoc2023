using Polynomials

function read_input6(filename::String)
    in6 = split.(readlines(filename))
    times = parse.(Int, in6[1][2:end])
    dists = parse.(Int, in6[2][2:end])
    return (times,dists)
end    

function count_wins(time,dist)
    eq = Polynomial([-dist, time, -1])
    eq_roots = roots(eq)

    return ceil(eq_roots[2]) - floor(eq_roots[1])  -1
end

function solve6a()
    times,dists = read_input6("Day6.txt")
    return prod(t -> count_wins(t...), zip(times,dists))
end