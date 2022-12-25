function childrenRootedTrees = extractSingleTrees(nTrees, G)
%DELETEEMPTYCELL Returnn a cell containng all the subtree starting from the
% roots
    
%     subtreeCell = cell(length(nTrees), height(G.Nodes.Name));
%     bins = conncomp(G);
%     for j = 1:height(G.Nodes)
%         treeIdx = bins(j);
%         subtreeCell = insertTreeIdx(subtreeCell,treeIdx,G.Nodes.Name{j});
%     end
    
    % ChildrenRootedTrees contains all the children trees of r (in form of
    % graph)
    childrenRootedTrees = cell(1,height(nTrees));
    for i = 1:height(nTrees)
        tree = {};
        for j = 1:height(G.Nodes.Name)
            if ~isempty(nTrees{i,j})
                tree{end+1} = nTrees{i,j};
            end
        end
        childrenRootedTrees{1,i} = subgraph(G,tree);
    end
end

