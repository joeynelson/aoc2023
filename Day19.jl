function read_input19(file_path::AbstractString = "Day19.txt")
    in = read(file_path, String)
    sections = split(in, "\n\n")

    rules = split.(sections[1], "\n")
    parts = split.(sections[2], "\n")
    return rules, parts
end

function parse_rule(rule::AbstractString)
    name, flows, default = match(r"(\w+)\{(.+),(\w+)\}",rule)
   
    flows = split(flows, ",")
    flows = map(m -> tuple(m[1],m[2] == ">" ? !isless : isless,parse(Int,m[3]))   ,match.(Ref(r"(\w+)([\<\>])(\d+)"), flows))

    return (name, flows, default)
end