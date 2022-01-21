function nTrees = insertTreeIdx(nTrees,treeIdx,nodeName)
%INSERTTREEIDX Insert each node into the respective subtree
    for i = 1:width(nTrees)
        if isempty(nTrees{treeIdx,i})
            nTrees{treeIdx,i} = nodeName;
            return;
        end
    end
end

