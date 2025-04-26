
function readmap3(filename::String = "Day3.txt")
    lines = readlines(filename)
    
    map3 = Char.(Int8.(hcat(collect.(lines)...))')

    bigger_map = Char.(ones(Int8, size(map3).+2) * Int8('.'))
    bigger_map[2:end-1,2:end-1] .= map3
    return bigger_map

end

function solve3_1(filename::String = "Day3.txt")
    map3 = readmap3(filename)
    nums = [[(parse(Int,m1.match),CartesianIndices((row-1:row+1,m1.offset-1:m1.offset+length(m1.match)))) for m1 in eachmatch(r"(\d+)", String(mapin))] for (row,mapin) in enumerate(eachrow(map3))]
    
    
    sum(d -> any(e -> e != '.' && !isdigit(e), map3[d[2]]) ? d[1] : 0, vcat(nums...))

end

function solve3_2(filename::String = "Day3.txt")
    map3 = readmap3(filename)
    nums = [[(parse(Int,m1.match),CartesianIndices((row-1:row+1,m1.offset-1:m1.offset+length(m1.match)))) for m1 in eachmatch(r"(\d+)", String(mapin))] for (row,mapin) in enumerate(eachrow(map3))]
    
    nums = vcat(nums...)
    
    
    posgears = [filter(n -> ci in n[2] ,nums)  for ci in findall(map3 .== '*')]

    gears = filter(pg -> length(pg)== 2, posgears)

    return sum(g-> g[1][1] * g[2][1], gears)


end