using PolygonOps
using LinearAlgebra


function read_input18(file_path::String)
    lines = split.(readlines(file_path))
    return map(x -> (x[1], parse(Int, x[2]), x[3]), lines)
end

function dig_trench(instructions)
    trench = Vector{CartesianIndex{2}}()
    loc = CartesianIndex(0, 0)
    push!(trench, loc)
    for (dir, dist, turn) in instructions
        loc += dist * (dir == "U" ? CartesianIndex(1, 0) : dir == "R" ? CartesianIndex(0, 1) : dir == "D" ? CartesianIndex(-1, 0) : CartesianIndex(0, -1))
        push!(trench, loc)
    end
    offset = CartesianIndex(-minimum(first.((Tuple.(trench)))) + 2, -minimum(last.(Tuple.(trench)))+2)

    
    return trench .+ offset

end

function dig_trench2(instructions)
    trench = Vector{CartesianIndex{2}}()
    loc = CartesianIndex(0, 0)
    push!(trench, loc)
    for (dir, dist, inst2) in instructions
        dist = parse(Int, inst2[3:end-2], base=16)
        dir = inst2[end-1]
        loc += dist * (dir == '3' ? CartesianIndex(1, 0) : dir == '0' ? CartesianIndex(0, 1) : dir == '1' ? CartesianIndex(-1, 0) : CartesianIndex(0, -1))
        push!(trench, loc)
    end
    offset = CartesianIndex(-minimum(first.((Tuple.(trench)))) + 2, -minimum(last.(Tuple.(trench)))+2)

    
    return trench .+ offset

end

function measure_perimiter(trench)
    perimiter = 0
    for i in 1:length(trench)-1
        perimiter += norm(Tuple(trench[i+1] - trench[i]), Inf)
    end
    return perimiter
end



function dig_trench3(instructions)
    trench = Vector{CartesianIndex{2}}()
    loc = CartesianIndex(0, 0)
    push!(trench, loc)
    for (dir, dist, inst2) in instructions
        dist = parse(Int, inst2[3:end-2], base=16)
        dir = inst2[end-1]
        if dir == '1' || dir == '3' 
            for _ in 1:dist
                loc += dist * (dir == '3' ? CartesianIndex(1, 0) : dir == '0' ? CartesianIndex(0, 1) : dir == '1' ? CartesianIndex(-1, 0) : CartesianIndex(0, -1))
                push!(trench, loc)
            end
        else
            loc += dist * (dir == '3' ? CartesianIndex(1, 0) : dir == '0' ? CartesianIndex(0, 1) : dir == '1' ? CartesianIndex(-1, 0) : CartesianIndex(0, -1))
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

    return inpolygon.(allpts, Ref(boundary), on = 1)
end

function solve18a()
    instructions = read_input18("input18.txt")
    trench = dig_trench(instructions)
    pit = fill_pit(trench)
    return sum(pit)
end


