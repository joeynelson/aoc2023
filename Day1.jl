
function solve1_1(filename = "Day1.txt")
    lines = readlines(filename)

    
    return sum(s -> parse(Int,String([s[findfirst(isdigit,s)], s[findlast(isdigit,s)]])), lines)


end

function solve1_2(filename = "Day1.txt")
    lines = readlines(filename)

    digitstrings = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

    

    firstdigits = map(m->findfirst(digitstrings .== m.match) % 10,  first.(collect.(eachmatch.(Ref(Regex(join(digitstrings,"|"))), in1, overlap=true))))
    lastdigits = map(m->findfirst(digitstrings .== m.match) % 10,  last.(collect.(eachmatch.(Ref(Regex(join(digitstrings,"|"))), in1, overlap=true))))

    return sum([fd * 10 + ld for (fd,ld) in zip(firstdigits, lastdigits)])
    
end
