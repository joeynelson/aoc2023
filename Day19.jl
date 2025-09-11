function read_input19(file_path::AbstractString = "Day19.txt")
    input =  filter(c -> c != '\r', read(file_path, String))
    sections = split(input, "\n\n")

    rules = split.(sections[1], "\n")
    parts = filter(!isempty, split.(sections[2], "\n"))
    return rules, parts
end

function parse_rule(rule::AbstractString)
    name, flows, default = match(r"(\w+)\{(.+),(\w+)\}",rule)
   
    flows = split(flows, ",")
    flows = map(m -> tuple(m[1],m[2] == ">" ? (a,b) -> a > b : (a,b) -> a < b,parse(Int,m[3]),m[4]) ,match.(Ref(r"(\w+)([\<\>])(\d+)\:(\w+)"), flows))

    return (name, flows, default)
end

function parse_part(part::AbstractString)
    x,m,a,s = parse.(Int,match(r"\{x\=(\d+),m\=(\d+),a\=(\d+),s\=(\d+)\}",part))
    return Dict("x" => x, "m" => m, "a" => a, "s" => s)
end

function apply_workflow(name::AbstractString, workflows::Dict, part::Dict)
    (flows, default) = workflows[name]
    for (name, condition, value, result) in flows
        if condition(part[name], value)
            if result == "A"
                return true
            elseif result == "R"
                return false
            else
                return apply_workflow(result, workflows, part)
            end
        end
    end
    if default == "A"
        return true
    elseif default == "R"
        return false
    else
        return apply_workflow(default, workflows, part)
    end
end

function measure_workflows(name::AbstractString, workflows::Dict, params::Dict = 
        Dict("x" => Set(1:4000), "m" => Set(1:4000), "a" => Set(1:4000), "s" => Set(1:4000)))

    params = deepcopy(params)
    good_params = 0
        
    (flows, default) = workflows[name]
    for (name, condition, value, result) in flows
        condparams = deepcopy(params)
        condparams[name] = Set(filter(x -> condition(x, value), condparams[name]))
        params[name] = Set(filter(x -> !condition(x, value), params[name]))
        if result == "A"
            good_params += prod(length.(values(condparams)))
        elseif result != "R"
            good_params += measure_workflows(result, workflows, condparams)
        end
    end
    if default == "A"
        good_params += prod(length.(values(params)))
    elseif default != "R"
        good_params += measure_workflows(default, workflows, params)
    end
    return good_params
end

function solve_19a()
    rules, parts = read_input19()

    rules = map(parse_rule, rules)
    parts = map(parse_part, parts)
    workflows = Dict(r[1] => (r[2],r[3]) for r in rules)
    return sum(apply_workflow("in", workflows, part) ? sum(values(part)) : 0 for part in parts)  
end

function solve_19b()
    rules, parts = read_input19()

    rules = map(parse_rule, rules)
    parts = map(parse_part, parts)
    workflows = Dict(r[1] => (r[2],r[3]) for r in rules)
    return measure_workflows("in",workflows)
end
