function read_input16(filename::String = "Day16.txt")
    in14 = collect.(readlines(filename))
    return permutedims(hcat(in14...))
end
function propogate_beam(m, loc, dir, activated = nothing)
    if activated === nothing
        activated = Set{Tuple{CartesianIndex,Int}}()
    end
    
    loc_dirs = [(loc, dir)]
    while true
        next_loc_dirs = Vector{Tuple{CartesianIndex,Int}}()
        for (loc,dir) in loc_dirs
            if !checkbounds(Bool,m,loc)
                continue
            end
            if ((loc,dir) in activated)
                continue
            else
                push!(activated, (loc,dir))
            end

            if m[loc] == '/' || m[loc] == '\\'
                dir = 5 - dir
                if m[loc] == '/'
                    dir = (dir + 1) % 4 + 1
                end
                push!(next_loc_dirs, (loc + step(dir), dir))
            elseif m[loc] == '|' && iseven(dir)
                push!(next_loc_dirs, (loc + step(1), 1))
                push!(next_loc_dirs, (loc + step(3), 3))
            elseif m[loc] == '-' && isodd(dir)
                push!(next_loc_dirs, (loc + step(2), 2))
                push!(next_loc_dirs, (loc + step(4), 4))
            else
                push!(next_loc_dirs, (loc + step(dir), dir))
            end
        end
        if length(next_loc_dirs) == 0
            break
        end
        loc_dirs = next_loc_dirs
    end
    
    return activated

end

step(dir) = dir == 1 ? CartesianIndex(-1,0) : dir == 2 ? CartesianIndex(0,1) : dir == 3 ? CartesianIndex(1,0) : dir == 4 ? CartesianIndex(0,-1) : error("Invalid direction")

function solve12a()
    m = read_input16()
    activated = propogate_beam(m, CartesianIndex(1,1), 2)
    return length(unique(first,activated))
end



function solve12b()
    m = read_input16()

    max_activated = 0

    for rowcol = 1:size(m, 1)
        max_activated = max(max_activated, length(unique(first,propogate_beam(m, CartesianIndex(rowcol, 1), 2))))
        max_activated = max(max_activated, length(unique(first,propogate_beam(m, CartesianIndex(rowcol, size(m,2)), 4))))
        max_activated = max(max_activated, length(unique(first,propogate_beam(m, CartesianIndex(1, rowcol), 3))))
        max_activated = max(max_activated, length(unique(first,propogate_beam(m, CartesianIndex(size(m,1), rowcol), 1))))

    end
    return max_activated
end