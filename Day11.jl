function read_input11(filename::String)
    open(filename) do file
        input = read(file, String)
        return Char.(UInt8.(hcat(collect.(split(input,"\n",keepempty=false))...))')
    end
end

function expand_universe(m)
    cols = findall(v -> all(v .== '.'), eachcol(m))
    rows = findall(v -> all(v .== '.'), eachrow(m))

    count = 0
    for row in rows 
        row += count
        m = vcat(m[1:row,:], m[row:row,:], m[row+1:end,:])
        count += 1
    end
    count = 0
    for col in cols 
        col += counts
        m = hcat(m[:, 1:col], m[:,col:col], m[:,col+1:end])
        count += 1
    end
    return m
end

function expand_universe(m,galaxies,increase)
    ngalaxies = copy(galaxies)
    cols = findall(v -> all(v .== '.'), eachcol(m))
    rows = findall(v -> all(v .== '.'), eachrow(m))

    println(rows)

    row_exp = 0
    col_exp = 0
    for i = 1:size(m)[1]
        if all(m[i,:] .== '.')
            println(i)
            row_exp += increase
        else
            for gidx in findall(g -> g.I[1] == i, galaxies)
                ngalaxies[gidx] = galaxies[gidx] + CartesianIndex(row_exp,0)
            end
        end

        if all(m[:,i] .== '.')
            col_exp += increase
        else
            for gidx in findall(g -> g.I[2] == i, galaxies)
                ngalaxies[gidx] = galaxies[gidx] + CartesianIndex(0, col_exp)
            end
        end
    end
    return ngalaxies
    

            
            

    for row in rows 
        galaxies = map(ci -> ci.I[1] > row + increase * count ? ci += CartesianIndex(increase,0) : ci, galaxies)
        count += 1
    end
    count = 0
    for col in cols
        galaxies = map(ci -> ci.I[2] > col + increase * count ? ci += CartesianIndex(0,increase) : ci, galaxies)
        count += 1
    end
    return galaxies
end

function expand_universe2(m, galaxies, increase)
    cols = findall(v -> all(v .== '.'), eachcol(m))
    rows = findall(v -> all(v .== '.'), eachrow(m))

    ngalaxies = map(g -> g + CartesianIndex(increase * count(rows .< g.I[1]), increase * count(cols .< g.I[2])))

    return ngalaxies

end


function solve11a()
    m = read_input11("Day11.txt")
    mexp = expand_universe(m)

    galaxies = findall(mexp .== '#')
    
    return sum(ci -> sum(abs.(ci.I)), (hcat(galaxies...) .- galaxies))÷2

end

function solve11a2()
    m = read_input11("Day11.txt")
    galaxies = findall(m .== '#')
    mexp = expand_universe(m,galaxies,1)

    
    return sum(ci -> sum(abs.(ci.I)), (hcat(galaxies...) .- galaxies))÷2

end

function solve11b()
    m = read_input11("Day11.txt")
    

    galaxies = findall(mexp .== '#')
    
    galaxies_e = expand_universe(m,galaxies)

    
    return sum(ci -> sum(abs.(ci.I)), (hcat(galaxies...) .- galaxies))÷2

end

