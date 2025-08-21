function read_input6(filename::String)
    in6 = split.(readlines(filename))
    times = parse.(Int, in6[1][2:end])
    dists = parse.(Int, in6[2][2:end])
    return (times,dists)
end    