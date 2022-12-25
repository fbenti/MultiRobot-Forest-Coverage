function split3a(childrenRootedTrees,root)
%SPLIT3A Decomposition procedure subcase 3a
% The weights of all tree rooted in children are < B. Then, the decomposition
% procedure picks a number of trees rooted in children of r so that the 
% weight of the tree consisting of r and these trees is in the interval [B, 2B).
% One nonleftover subtree consists of r and these trees. The decomposition
% procedure removes all vertices of this nonleftover subtree, except for r 
% from the tree rooted in r, and calls itself recursively on the remaining 
% tree rooted in r in order to find the other nonleftover subtrees.

    global B nonLeftovers rootNonLeftovers subTree;

    % Initialize new graph equal to the tree rooted in r
    sumOfTreeRootedInChildren = subTree;
    
    % Order subtrees in ascending order, based on the wieght
    num = numel(childrenRootedTrees);
    
    for j = 0 : num-1
        for i = 1: num-j-1
            if sum(childrenRootedTrees{i}.Edges.Weight) > sum(childrenRootedTrees{i+1}.Edges.Weight)
                temp = childrenRootedTrees{i};
                childrenRootedTrees{i} = childrenRootedTrees{i+1};
                childrenRootedTrees{i+1} = temp;
            end
        end
    end
    
    for i = 1:length(childrenRootedTrees)
        % In each cicle remove one of the childrenTree and check the
        % weight 
        sumOfTreeRootedInChildren = rmnode(sumOfTreeRootedInChildren, childrenRootedTrees{i}.Nodes.Name);
        
        if B <= sum(sumOfTreeRootedInChildren.Edges.Weight) && sum(sumOfTreeRootedInChildren.Edges.Weight) < 2*B
            % sumOfTreeRootedChildren is a non-leftovers
            nonLeftovers{end+1} = sumOfTreeRootedInChildren;
            rootNonLeftovers{end+1} = root;
            
            % Now remove the non-leftover from rootTree except for the root;
            sumOfTreeRootedInChildren = rmnode(sumOfTreeRootedInChildren, root);
            subTree = rmnode(subTree, sumOfTreeRootedInChildren.Nodes.Name);

            % Call the procedure recursively on the remaining subTree
            decomposeEachTree(root);
            break;
        end
    end
end

