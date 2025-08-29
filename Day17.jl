using Graphs
using SimpleWeightedGraphs

function read_input17(filename::String = "Day17.txt")
   return parse.(Int, hcat(collect.(readlines(filename))...))'
end


function make_graph(m)
    vertices = [(ci,dir,step) for ci in findall(_ -> true, m), dir in 1:4, step in 1:3][:]
    vertlookup = Dict(el => i for (i,el) in enumerate(vertices))

    u = Vector{Int}()
    v = Vector{Int}()
    weights = Vector{Int}()


    for (ci,dir,step) in vertices
        # Move forward
        if step < 3
            next_ci = ci + get_step(dir)
            if checkbounds(Bool,m, next_ci)
                push!(u, vertlookup[(ci,dir,step)])
                push!(v, vertlookup[(next_ci,dir,step+1)])
                push!(weights, m[next_ci])
            end
        end
        # Turn left
        next_dir = dir == 1 ? 4 : dir - 1
        next_ci = ci + get_step(next_dir)
        if checkbounds(Bool,m, next_ci)
            push!(u, vertlookup[(ci,dir,step)])
            push!(v, vertlookup[(next_ci,next_dir,1)])
            push!(weights, m[next_ci])
        end

        # Turn right
        next_dir = dir == 4 ? 1 : dir + 1
        next_ci = ci + get_step(next_dir)
        if checkbounds(Bool,m, next_ci)
            push!(u, vertlookup[(ci,dir,step)])
            push!(v, vertlookup[(next_ci,next_dir,1)])
            push!(weights, m[next_ci])
        end
    end

    g = SimpleWeightedDiGraph(u,v,weights)
    return g, vertlookup

end

function make_graph_b2(m)
    vertices = [(ci,dir,step) for ci in findall(_ -> true, m), dir in 1:4, step in 1:10][:]
    vertlookup = Dict(el => i for (i,el) in enumerate(vertices))

    u = Vector{Int}()
    v = Vector{Int}()
    weights = Vector{Int}()

    for (ci,dir,step) in vertices
        # Move forward
        if step < 10
            next_ci = ci + get_step(dir)
            if checkbounds(Bool,m, next_ci)
                push!(u, vertlookup[(ci,dir,step)])
                push!(v, vertlookup[(next_ci,dir,step+1)])
                push!(weights, m[next_ci])
            end
        end
        # Turn left
        if step >= 4
            next_dir = dir == 1 ? 4 : dir - 1
            next_ci = ci + get_step(next_dir)
            if checkbounds(Bool,m, next_ci)
                push!(u, vertlookup[(ci,dir,step)])
                push!(v, vertlookup[(next_ci,next_dir,1)])
                push!(weights, m[next_ci])
            end
        end
        # Turn right
        if step >= 4 
            next_dir = dir == 4 ? 1 : dir + 1
            next_ci = ci + get_step(next_dir)
            if checkbounds(Bool,m, next_ci)
                push!(u, vertlookup[(ci,dir,step)])
                push!(v, vertlookup[(next_ci,next_dir,1)])
                push!(weights, m[next_ci])
            end
        end
    end

    g = SimpleWeightedDiGraph(u,v,weights)
    return g, vertlookup

end


function make_graph_b(m)
    vertices = [(ci,dir,step) for ci in findall(_ -> true, m), dir in 1:4, step in 1:6][:]
    vertlookup = Dict(el => i for (i,el) in enumerate(vertices))

    u = Vector{Int}()
    v = Vector{Int}()
    weights = Vector{Int}()


    for (ci,dir,step) in vertices
        # Move forward
        if step < 6
            next_ci = ci + get_step(dir)
            if checkbounds(Bool,m, next_ci)
                push!(u, vertlookup[(ci,dir,step)])
                push!(v, vertlookup[(next_ci,dir,step+1)])
                push!(weights, m[next_ci])
            end
        end
        # Turn left and move 4
        next_dir = dir == 1 ? 4 : dir - 1
        next_ci = ci
        w = 0
        for i in 1:4
            next_ci += get_step(next_dir)
            if checkbounds(Bool,m, next_ci)
                w += m[next_ci]
            end
        end 
        if checkbounds(Bool,m, next_ci)
            push!(u, vertlookup[(ci,dir,step)])
            push!(v, vertlookup[(next_ci,next_dir,1)])

            push!(weights, w)
        end

        # Turn right and move 4
        next_dir = dir == 4 ? 1 : dir + 1
        next_ci = ci
        for i in 1:4
            next_ci += get_step(next_dir)
            if checkbounds(Bool,m, next_ci)
                w += m[next_ci]
            end
        end
        if checkbounds(Bool,m, next_ci)
            push!(u, vertlookup[(ci,dir,step)])
            push!(v, vertlookup[(next_ci,next_dir,1)])
            push!(weights, w)
        end
    end

    g = SimpleWeightedDiGraph(u,v,weights)
    return g, vertlookup

end



function solve17a() 
    m = read_input17()
    g, vertlookup = make_graph(m)
    start = [vertlookup[(CartesianIndex(1,1),d,s)] for d in 1:4, s in 1:3][:]
    goal = [vertlookup[(CartesianIndex(size(m)...),d,s)] for d in 1:4, s in 1:3][:]
    p = dijkstra_shortest_paths(g, start)
    return minimum(getindex.(Ref(p.dists),goal))
end


function solve17b() 
    m = read_input17()
    g, vertlookup = make_graph_b2(m)
    start = [vertlookup[(CartesianIndex(1,1),d,5)] for d in [1,4]][:]
    goal = [vertlookup[(CartesianIndex(size(m)...),d,s)] for d in 1:4, s in 4:10][:]
    p = dijkstra_shortest_paths(g, start)
    return minimum(getindex.(Ref(p.dists),goal))
end


get_step(dir) = dir == 1 ? CartesianIndex(-1,0) : dir == 2 ? CartesianIndex(0,1) : dir == 3 ? CartesianIndex(1,0) : dir == 4 ? CartesianIndex(0,-1) : error("Invalid direction")