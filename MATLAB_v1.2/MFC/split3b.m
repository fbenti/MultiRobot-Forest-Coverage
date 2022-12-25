function split3b(childrenRootedTree,rootChildren)
%SPLIT3B Decomposition procedure subcase 3a
% The weight of at least one tree rooted in a child of r is in the interval
% [B, 2B). Then, the decomposition procedure picks such a tree. One 
% nonleftover subtree consists of this tree. The decomposition procedure 
% removes all vertices of the nonleftover subtree from the tree rooted in r 
% and calls itself recursively on the remaining tree rooted in r in order to
% find the other nonleftover subtrees.
    
    global nonLeftovers rootNonLeftovers numeredRootsCell rootIdx subTree treeRootedR;
    
    % The k-graph in childrenRootedTrees has weigth [B,2*B), which is a
    % non-leftovers
    kGraph = childrenRootedTree;
    
    % Add it to the non-leftovers.
    nonLeftovers{end+1} = kGraph;
    rootNonLeftovers{end+1} = rootChildren;
    
    % Remove all vertices of k-Graph from the rootTree
    subTree = rmnode(treeRootedR, kGraph.Nodes.Name);
    treeRootedR = subTree;

    % Call the procedure recursively on the remaining rootTree
    decomposeEachTree(numeredRootsCell{rootIdx});
    treeRootedR = subTree;
    
end

