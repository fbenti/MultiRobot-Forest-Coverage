function newG = deleteEdgesFromGraph(G,M)
%DELETEEDGESFROMGRAPH Delete the edges that does not appear on the MST from
% the original graph
    deleteEdges1 = {};
    deleteEdges2 = {};
    edgeIdx = [];
    found = false;
    for i = 1:length(G.Edges.EndNodes)
        found = false;
        for j = 1:length(M.Edges.EndNodes)
            if strcmp(G.Edges.EndNodes(i,1),M.Edges.EndNodes(j,1)) && strcmp(G.Edges.EndNodes(i,2),M.Edges.EndNodes(j,2))
                %|| strcmp(G.Edges.EndNodes(i,1),M.Edges.EndNodes(j,2)) && strcmp(G.Edges.EndNodes(i,2),M.Edges.EndNodes(j,1))
                found = true;
                break
            end
        end
        if found == false
%             deleteEdges1{end+1} = G.Edges.EndNodes(i,1);
%             deleteEdges2{end+1} = G.Edges.EndNodes(i,2);
            edgeIdx(end+1) = i;
        end
    end
%     newG = rmedge(G,deleteEdges1,deleteEdges2);
    newG = rmedge(G,edgeIdx);
    newG = removeEmptyNodes(newG);
end

