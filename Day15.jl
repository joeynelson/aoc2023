function read_input15(filename::String = "Day15.txt")
    return strip.(split(read(filename,String),','))
end

function hashalgo(input::AbstractString, current = 0)
    if length(input) == 0
        return current
    end

    current += + Int(input[1])
    current *= 17
    current = rem(current, 256)
    return hashalgo(input[2:end], current)
end


function parse_input(input::AbstractString)
    return match(r"(\w+)(?|(\=)(\d+)|(\-))",input)
end

function solve15a()
    input = read_input15()
    return sum(hashalgo.(input))
end

function solve15b()
    input = read_input15()
   
    boxes = [Vector{Tuple{AbstractString,Int}}() for _ in 1:256]
    
    for inp in input
        label, op, value = parse_input(inp)
        box_idx = hashalgo(label) + 1
        
    
        if op == "="
            lidx = findfirst(t -> t[1] == label, boxes[box_idx])
            if isnothing(lidx)
                push!(boxes[box_idx], (label, parse(Int,value)))
            else
                boxes[box_idx][lidx] = (label, parse(Int,value))
            end
        end
        if op == "-"
            filter!(t -> t[1] != label, boxes[box_idx])
        end
            
    end
    
    return sum(t -> sum(l -> t[1] * l[1] * l[2][2] ,enumerate(t[2]),init=0)  ,enumerate(boxes))


end