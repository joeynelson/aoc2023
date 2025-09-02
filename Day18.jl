using PolygonOps

function read_input18(file_path::String)
    lines = split.(readlines(file_path))
    return map(x -> (x[1], parse(Int, x[2]), x[3]), lines)
end

function dig_trench(instructions)
    trench = Vector{CartesianIndex{2}}()
    loc = CartesianIndex(0, 0)
    push!(trench, loc)
    for (dir, dist, turn) in instructions
        for _ in 1:dist
            loc += (dir == "U" ? CartesianIndex(1, 0) : dir == "R" ? CartesianIndex(0, 1) : dir == "D" ? CartesianIndex(-1, 0) : CartesianIndex(0, -1))
            push!(trench, loc)
        end
    end
    offset = CartesianIndex(-minimum(first.((Tuple.(trench)))) + 2, -minimum(last.(Tuple.(trench)))+2)

    
    return trench .+ offset

end

function fill_pit(trench)
    m = zeros(maximum(first.((Tuple.(t2)))) + 1, maximum(last.(Tuple.(t2)))+1)
    allpts = Tuple.(findall(p->true,m))

    boundary = Tuple.(push!(trench,trench[1]))

    return inpolygon(allpts, boundary, on = 1)
end




