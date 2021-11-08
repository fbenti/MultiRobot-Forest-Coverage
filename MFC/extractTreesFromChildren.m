function newChildrenRootedTrees = extractSingleTrees(children, G)
%DELETEEMPTYCELL Return a cell containng all the subtree starting from the
% children
    
    subtreeCell = cell(length(children), height(G.Nodes.Name));
    bins = conncomp(G);
    for j = 1:height(G.Nodes)
        treeIdx = bins(j);
        subtreeCell = insertTreeIdx(subtreeCell,treeIdx,G.Nodes.Name{j});
    end
    
    % ChildrenRootedTrees contains all the children trees of r (in form of
    % graph)
    childrenRootedTrees = cell(1,height(children));
    for i = 1:height(children)
        tree = {};
        for j = 1:height(G.Nodes.Name)
            if ~isempty(subtreeCell{i,j})
                tree{end+1} = subtreeCell{i,j};
            end
        end
        childrenRootedTrees{1,i} = subgraph(G,tree);
    end
    
    % order as the childrenRoot
    newChildrenRootedTrees = {};
    for i = 1:length(children)
        for j = 1:length(childrenRootedTrees)
            if findnode(childrenRootedTrees{j}, children{i}) ~= 0
                newChildrenRootedTrees{end+1} = childrenRootedTrees{j};
            end
        end
    end  
    
end

