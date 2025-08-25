function read_input12(filename::String)
    in12 = readlines(filename)
    sm = collect.(first.(split.(in12)))
    cont = map(l -> parse.(Int,split(l,",")), last.(split.(in12)) )
    return sm,cont
end

all_combos(n) = collect.(collect(Iterators.product(ntuple(_ -> ['.','#'], n)...))[:])   

function calc_cont(sprint_map)
    return length.(split(String(t),'.',keepempty=false))
end

function make_map(sm, combo)
    sm = copy(sm)
    sm[findall(sm .== '?')] .= combo
    return sm
end 

function solve12a()
    spring_maps,conts = read_input12("Day12.txt")
    total = 0
    for (sm,conts) in zip(spring_maps,conts)
        corrupt_idx = findall(sm .== '?')
        combos = all_combos(length(corrupt_idx))
        total += count(combo -> calc_cont(make_map(sm, combo)) == cont, combos)
    end
    return total
end
