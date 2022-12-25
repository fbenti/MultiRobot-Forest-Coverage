function [forest, G2, M2] = obtainForest(G2,M2)
%OBTAINFOREST Find forest obtained from M by un-contracting roots in R

    global numeredRoots numeredRootsCell numRobots;
    
    % Remove special node and obtain different subtrees
    G2 = rmnode(G2,'contractedRoots');
    M2 = rmnode(M2,'contractedRoots');
    p2 = plot(G2);
    highlight(p2,M2);
    highlight(p2, numeredRoots,'NodeColor','r');
    
    % try to colour the graphs in different way
    
    % Remove edge which are in the original spanning tree but not in the subtrees
    G2 = deleteEdgesFromGraph(G2,M2);
    M2 = removeEmptyNodes(M2);
    p3 = plot(G2);
    highlight(p3, numeredRootsCell,'NodeColor','r')
    
    % Create sub-trees: use conncomp(Graph) to know which nodes belongs to which trees
    nTrees = cell(numRobots,height(G2.Nodes.Name));
    bin = conncomp(G2);
    for i = 1:height(G2.Nodes)
        treeIdx = bin(i);
        nTrees = insertTreeIdx(nTrees,treeIdx,G2.Nodes.Name{i});
    end
    forest = extractSingleTrees(nTrees,G2);
end

