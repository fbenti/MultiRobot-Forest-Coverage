function [G,s,t,weight] = generateGraph()
%CREATE_GRAPH Given the 2d-matrix of the map, create the corrspondent graph
    %   s : starting nodes of edges
    %   t : ending nodes
    %   weights: weight of each edge
    global map numeredMap;
    s = [];
    t = [];
    weight = [];
    labels = {''};
    [N,M] = size(map);
    for row = 1:N
        for col = 1:M
            labels{numeredMap(row,col)} = int2str(numeredMap(row,col));
            if map(row,col) == 0
                neigh = get_neighbours(map,row,col,N,M);
                if not(isempty(neigh)) && not(isempty(neigh{1}))
                    for i = 1:length(neigh)
                        if checkNonRepeteatedEdges(s,t,numeredMap,row,col,neigh{i}(1),neigh{i}(2)) 
                            s(end+1) = numeredMap(row,col);
                            t(end+1) = numeredMap(neigh{i}(1),neigh{i}(2));
                            weight(end+1) = 4;
                        end
                    end
                end
            end
        end
    end
    G = graph(s,t,weight);
%     if last element map(N,M) is a blocked cell, delete the last label
    
    flag = 0;
    for j = 0:N-1
        for i = 0:M-1
            if map(N-j,M-i) == 1
    %             labels = labels(1:end-i);
                labels(end) = [];
            else
                flag = 1;
                break;
            end
        end
        if flag == 1
            break;
        end
    end
    G.Nodes.Name = labels';
    
    flag = 0;
    for j = 0:N-1
        for i = 0:M-1
            if map(N-j,M-i) == 1
                G = addnode(G,int2str(numeredMap(N-j,M-i)));
            else
                flag = 1;
                break;
            end
        end
        if flag == 1
            break;
        end
    end
end

