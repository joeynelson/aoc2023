using Intervals

function read_input5b(filename::String)
    open(filename) do file
        input = read(file, String)
        sinput = split.(split(input, "\n\n"), ":")
        seed_list = parse.(Int, split(sinput[1][2], " ", keepempty=false))
        seed_intervals = map(sr -> Interval{Closed,Open}(sr[1], sr[1]+sr[2]), eachcol(reshape(seed_list, (2,10))))

        smaps = map(m -> (split(m[1], "-to-"), parse_map_b.(split(m[2], "\n", keepempty=false))), sinput[2:end])
        return seed_intervals, smaps
    end
end

function read_input5(filename::String)
    open(filename) do file
        input = read(file, String)
        sinput = split.(split(input, "\n\n"), ":")
        seed_list = parse.(Int, split(sinput[1][2], " ", keepempty=false))

        smaps = map(m -> (split(m[1], "-to-"), parse_map.(split(m[2], "\n", keepempty=false))), sinput[2:end])
        return seed_list, smaps
    end
end

function parse_map(line)
    vals = parse.(Int, split(line, " "))
    return (range(vals[2], step=1, length=vals[3]), vals[1]-vals[2])
end

function parse_map_b(line)
    vals = parse.(Int, split(line, " "))
    return (Interval{Closed,Open}(vals[2], vals[2]+vals[3]), vals[1]-vals[2])
end


function map_lookup(input, smap)
    idx = findfirst(m -> input in m[1], smap)
    if isnothing(idx) 
        return input
    else
        return smap[idx][2] + input
    end 
end

function map_lookup_b(inputs, smap)
    return filter(!isempty,vcat([intersect(sm[1], input) + sm[2] for sm in smap, input in inputs]...))
end


function find_location(seed, smaps)
    return reduce((s,m) -> map_lookup(s,m), last.(smaps), init=seed)
end

function find_locations(seeds, smaps)
    return reduce((s,m) -> map_lookup_b(s,m), last.(smaps), init=seeds)
end


function solve5a()
    seed_list, smaps = read_input5("Day5.txt")
    return minimum(find_location.(seed_list, Ref(smaps)))
end



