function G = removeBlockedNodes(G,map,numered_map)
%REMOVEBLOCKEDNODE Remove the unaccessible nodes from the graph
    [N,M] = size(map);
    blocked = {''};
    k = 1;
    for i = 1:N
        for j = 1:M
            if map(i,j) == 1
                blocked{k} = int2str(numered_map(i,j));
                k = k + 1;
            end
        end
    end
    G = rmnode(G,blocked);
end