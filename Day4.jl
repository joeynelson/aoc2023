
function load_day4_data(file_path::String)
    lines = readlines(file_path)
    values = split.(last.(split.(lines,":")),"|")
    return map(t -> split.(t,keepempty=false), values) .|> x -> x .|> x-> parse.(Int64,x)
end