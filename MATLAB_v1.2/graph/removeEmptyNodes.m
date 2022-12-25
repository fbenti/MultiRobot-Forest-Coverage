function G = removeEmptyNodes(G)
%REMOVEEMPYNODES Remove nodes that have degree 0
%   Nodes not connected
    global numeredRoots;
    
    j = 1;
    emptyNodes = [];
    for i = 1:numnodes(G)
        if degree(G,i) == 0 && not(ismember(i,numeredRoots))
            emptyNodes(j) = i;
            j = j +1;
        end
    end
    G = rmnode(G,emptyNodes);    
end

