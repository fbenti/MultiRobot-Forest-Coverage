function biPartiteGraph = createBiPartiteGraph(G)
%createBiPartiteGraph Create a Bi-Partite graph
% A bi-partite graph is constructed as follows: 
% - One side of the vertex set is R and the other side consists of nodes representing the trees .
% - An edge connects a root r and a tree  i if the distance between Sj i and r is at most B. 
% - A maximum matching is then computed in this bi-partite graph.


    global B rootNonLeftovers numeredRootsCell;
    s = [];
    t = [];
    weigth = [];
    
    for i = 1:length(numeredRootsCell)
        for j = 1:length(rootNonLeftovers)
            if not(numeredRootsCell{i} == rootNonLeftovers{j})
                [P,d] = shortestpath(G, numeredRootsCell{i},rootNonLeftovers{j});
                if d < B
                    s(end+1) = str2num(numeredRootsCell{i});
                    t(end+1) = str2num(rootNonLeftovers{j});
                    weigth(end+1) = d;
                end
            end
        end
    end
    
    biPartiteGraph = graph(s,t,weigth);
    label = {};
    for i = 1:height(biPartiteGraph.Nodes)
        label{end+1} = int2str(i);
    end
    biPartiteGraph.Nodes.Name = label';
    biPartiteGraph = removeEmptyNodes(biPartiteGraph);
    plot(biPartiteGraph);   
    
end

