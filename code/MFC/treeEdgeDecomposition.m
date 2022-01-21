function treeEdgeDecomposition(forest_M)
%TREEEDGEDECOMPOSITION

global leftovers numeredRootsCell rootIdx subTree treeRootedR;
% For each root(tree rooted in r)
for i = 1:length(forest_M)
    % Assign to subTree the tree rooted in r
    rootIdx = i;
    subTree = forest_M{rootIdx};
    treeRootedR = subTree;
    leftover = decomposeEachTree(numeredRootsCell{rootIdx});
    % if is empty then add to the leftover only the root r
    if height(leftover.Nodes) == 0
        % if empty, add the root r
        leftovers{end+1} = subgraph(forest_M{rootIdx}, numeredRootsCell{rootIdx});
    else
        leftovers{end+1} = leftover;
    end
end

