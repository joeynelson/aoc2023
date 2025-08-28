function read_input14(filename::String = "Day14.txt")
    in14 = collect.(readlines(filename))
    return permutedims(hcat(in14...))

end

function tilt_north(m)

    m = deepcopy(m)


    while true
        prev_m = deepcopy(m)
        for i = 2:length(m)
            for j = 1:length(m[i])
                if m[i][j] == 'O' && m[i-1][j] == '.'
                    m[i-1][j] = 'O'
                    m[i][j] = '.'
                end
            end
        end
        (prev_m != m) || return m
    end
end


function tilt(m, dir)

    m = deepcopy(m)
    for i = 1:dir
        m = rotr90(m)
    end
    height,width = size(m)

    while true
        prev_m = deepcopy(m)
        for i = 2:height
            for j = 1:width
                if m[i,j] == 'O' && m[i-1,j] == '.'
                    m[i-1,j] = 'O'
                    m[i,j] = '.'
                end
            end
        end
        (prev_m != m) || break
    end

    for i = 1:dir
        m = rotl90(m)
    end

    return m
end



function measure_load(m::Matrix{Char})
    return sum(t -> count(t[2] .== 'O') * t[1], enumerate(reverse(eachrow(m))))
end

function solve14a()
    m = tilt(read_input14(),0)

    return measure_load(m)
end

function solve14b()
    m = read_input14()
    states = Dict{Matrix{Char}, Int64}()


    for i = 1:1000000000
        prev_m = deepcopy(m)            
        for dir in 0:3 
            m = tilt(m, dir)
        end
        if haskey(states,m)
            println("repeat $i, $(states[m]) : $(i - states[m])")
            if (1000000000 - states[m]) % (i - states[m]) == 0 
                break
            end
            states[m] = i

        else
            states[m] = i
        end
    end
    return measure_load(m)
end

