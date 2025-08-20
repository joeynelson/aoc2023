
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





