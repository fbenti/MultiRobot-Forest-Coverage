function split3c(childrenRootedTree,rootChildren)
%SPLIT3C Decomposition procedure subcase 3a
% The weight of at least one tree rooted in a child of r is at least 2B. 
% Then, the decomposition procedure calls itself recursively on such a tree 
% rooted in a child of r and then on the remaining tree rooted in r in order 
% to find the nonleftover subtrees.
    
    global numeredRootsCell rootIdx subTree treeRootedR;
    
    % The k-graph in childrenRootedTrees has weigth > 2*B
    kGraph = childrenRootedTree;
    
    % Call the decomposition procedure on k-Graph
    subTree = kGraph;
    decomposeEachTree(rootChildren);
    
    % Remove the leftover from kGraph, then remove the remaining part from
    % the treeRootedR
    diffGraph = rmnode(kGraph, subTree.Nodes.Name);
    subTree = rmnode(treeRootedR,diffGraph.Nodes.Name);
    treeRootedR = subTree;
     
    % Call again the decomposition procedure on the remaining tree
    
    decomposeEachTree(numeredRootsCell{rootIdx});
    treeRootedR = subTree;
    
end

