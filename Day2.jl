
function solve2_1(filename = "Day2.txt")
    lines = readlines(filename)

    ms = collect.(eachmatch.(r"(\d+) (red|green|blue)",lines))

    redmax = map(m -> maximum([parse(Int, e[1]) for e in m if e[2] == "red"]), ms)
    greenmax = map(m -> maximum([parse(Int, e[1]) for e in m if e[2] == "green"]), ms)
    bluemax = map(m -> maximum([parse(Int, e[1]) for e in m if e[2] == "blue"]), ms)
    
    return sum(findall(t -> t[1] <= 12 && t[2] <= 13 && t[3] <= 15 , collect(zip(redmax, greenmax, bluemax))))
end

function solve2_2(filename = "Day2.txt")
    lines = readlines(filename)

    ms = collect.(eachmatch.(r"(\d+) (red|green|blue)",lines))

    redmax = map(m -> maximum([parse(Int, e[1]) for e in m if e[2] == "red"]), ms)
    greenmax = map(m -> maximum([parse(Int, e[1]) for e in m if e[2] == "green"]), ms)
    bluemax = map(m -> maximum([parse(Int, e[1]) for e in m if e[2] == "blue"]), ms)
    
    return sum(map(t -> t[1] * t[2] * t[3] , collect(zip(redmax, greenmax, bluemax))))
end