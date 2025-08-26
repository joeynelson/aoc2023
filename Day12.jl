using Combinatorics

function read_input12(filename::String)
    in12 = readlines(filename)
    sm = collect.(first.(split.(in12)))
    cont = map(l -> parse.(Int,split(l,",")), last.(split.(in12)) )
    return sm,cont
end

all_combos(n) = collect.(collect(Iterators.product(ntuple(_ -> ['.','#'], n)...))[:])   

function legit_combos(sm, cont)
    corrupt_idx = findall(sm .== '?')
    known_spring_count = count(sm .== '#')
    total_spring_count = sum(cont)

    new_spring_options = combinations(corrupt_idx, total_spring_count-known_spring_count)

    return new_spring_options
end

function check_legit_combos(sm, cont)
    corrupt_idx = findall(sm .== '?')
    known_spring_count = count(sm .== '#')
    total_spring_count = sum(cont)

    new_spring_options = combinations(corrupt_idx, total_spring_count-known_spring_count)

    return count(combo -> calc_cont(make_map2(sm, combo)) == cont, new_spring_options)
end

function test_fit(spring_map, cont)
    if length(cont) == 0 
        return '#' in spring_map ? 0 : 1
    end

    sm = ".$spring_map."

    count1 = 0
    count2 = 0
    rstring = reduce((s,c) -> "$s[\\?\\#]{$c}[\\?\\.]+", cont, init = "^[\\.\\?]+")
    m = match(Regex(rstring), sm)
    if isnothing(m)
        return 0
    end
    #println("A: $spring_map: $cont $(m.offset) $count ")
    count1 = test_fit(sm[m.offset+cont[1]+2:end-1], cont[2:end])
    #println("B: $spring_map: $count")
    if !('#' in sm[1:m.offset+1])
        count2 = test_fit(sm[m.offset+2:end-1], cont)
        #println("C: $spring_map: $count")
    end
    println("X: $spring_map: $cont $(m.offset) ($count1 $count2)")
    return count1 + count2
end
        

function calc_cont(spring_map)
    return length.(split(String(spring_map),'.',keepempty=false))
end

function make_map(sm, combo)
    sm = copy(sm)
    sm[findall(sm .== '?')] .= combo
    return sm
end 

function make_map2(sm, combo)
    sm = copy(sm)
    sm[combo] .= '#'
    sm[findall(sm .== '?')] .= '.'
    return sm
end 


function solve12a()
    spring_maps,conts = read_input12("Day12.txt")
    total = 0
    for (sm,cont) in zip(spring_maps,conts)
        corrupt_idx = findall(sm .== '?')
        combos = all_combos(length(corrupt_idx))
        total += count(combo -> calc_cont(make_map(sm, combo)) == cont, combos)
    end
    return total
end

function solve12a2()
    spring_maps,conts = read_input12("Day12.txt")
    total = 0
    for (sm,cont) in zip(spring_maps,conts)
        vcombos = legit_combos(sm,cont)
        total += count(combo -> calc_cont(make_map2(sm, combo)) == cont, vcombos)
    end
    return total
end

function test12a(sm,cont)
    vcombos = legit_combos(sm,cont)
    return count(combo -> calc_cont(make_map2(sm, combo)) == cont, vcombos)
end

function solve12b()
    spring_maps,conts = read_input12("Day12.txt")
    spring_maps = repeat.(spring_maps,Ref(5))
    conts = repeat.(conts, Ref(5))
    total = 0
    for (sm,cont) in zip(spring_maps,conts)
        println(String(sm))
        total = check_legit_combos(sm,cont)
    end
    return total
end
