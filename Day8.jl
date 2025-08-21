function read_input8(filename::String)
    inlines = readlines(filename)
    directions = inlines[1]
    mdict = Dict{String, Tuple{String, String}}()
    for l in inlines[3:end]
        m = match(r"(?<src>\w+) = \((?<left>\w+), (?<right>\w+)\)", l)
        mdict[m["src"]] = (m["left"], m["right"])
    end
    return directions,mdict
end

function solve8()
    directions,mdict = read_input8("Day8.txt")
    loc = "AAA"
    for (c,dir) in enumerate(Iterators.cycle(directions))
        loc = dir == 'L' ? mdict[loc][1] : mdict[loc][2]
        if loc == "ZZZ"
            return c
        end
    end
end

function solve8b()
    directions,mdict = read_input8("Day8.txt")

    all_loc = filter(n -> n[3] == 'A', keys(mdict))
    lastz = map(l -> 0, all_loc)
    for (c,dir) in enumerate(Iterators.cycle(directions))
        all_loc = dir == 'L' ? map(first, get.(Ref(mdict), all_loc,"")) : map(last, get.(Ref(mdict), all_loc, ""))
        if all(n -> n[3] == 'Z', all_loc)
            return c 
        end
        if any(n -> n[3] == 'Z', all_loc)
            print("$c ")
            println(findall(n -> n[3] == 'Z', all_loc))
        end
    end
end