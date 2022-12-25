function subTree = decomposeEachTree(root)
%DECOMPOSEEACHTREE Decompose each tree recursively
% Decompose each tree recursively  into zero or more non-leftovers subtrees
% whose weights are in the interval [B,2B) and one leftover subtree, whose 
% weight is in the interval (0,B). Assume that a tree is rooted in r. The 
% decomposition procedure repeatedly removes vertices fromthe tree as it 
% generates the nonleftover subtrees. The leftover subtree consists of all 
% vertices that have not been removed after the decomposition procedure 
% terminates.

    % Import as global leftover and non-leftovers
    global B nonLeftovers rootNonLeftovers numeredRootsCell rootIdx subTree;
    
    % Define weight of the tree rooted in R
    subTreeWeight = sum(subTree.Edges.Weight);
    
    % Case 1) The weight of the tree rooted in r is less than B. Then the
    %         decomposition procedure simply returns.
    if  subTreeWeight < B
%         leftovers{end+1} = subTree;  % if all nodes has been removed then the leftover subtree consists of only the root r
        return;
    
    % Case 2) The weight of the tree rooted in r is in the interval [B,2B).
    %         Then, one nonleftover subtree consist of the tree rooted in 
    %         r. The decomposition procedure removes all vertices of this
    %         non-leftover subtree from the tree rooted in r (leaving the
    %         empty tree) and returns.
    elseif B <= subTreeWeight && subTreeWeight < 2*B
        nonLeftovers{end+1} = subTree;
        rootNonLeftovers{end+1} = root;
        % Remove all vertices
        subTree = rmnode(subTree, subTree.Nodes.Name);
        return;
    
    % Case 3) The weight of the tree rooted in r is at least 2B -> 3
    % different cases.
    else %subTreeWeight >= 2*B
        
        % Define children (neighbors) of root r
        rootChildren = neighbors(subTree,root);
        
        % Remove root from graph -> we obtain n disconnected trees (based
        % on the number of neighbours)
        subTreeChildren = rmnode(subTree, root);
        
        % Extract the different children rooted trees 
        childrenRootedTrees = extractTreesFromChildren(rootChildren, subTreeChildren);
        % ChildrenRootedTrees contains all the children trees of r (in form of
        % graph)
        
        % Differentiate into the 3 subcases:
        subcase = '3a';
        for k = 1:length(childrenRootedTrees)
            childrenRootedTreeWeight = sum(childrenRootedTrees{k}.Edges.Weight);
            %if childrenRootedTreeWeight < B
             %   subcase = '3a';
            if B <= childrenRootedTreeWeight && childrenRootedTreeWeight < 2*B
                subcase = '3b';
                j = k;
            elseif childrenRootedTreeWeight >= 2*B
                subcase = '3c';
                break;
            end
        end
        
        switch subcase
            case '3a' % The weights of all tree rooted in children are < B
               split3a(childrenRootedTrees, root);
            case '3b' % At least one tree has weight [B,2*B)
                split3b(childrenRootedTrees{j},rootChildren{j});
            case '3c' % At least one tree has weight > 2*B)
                split3c(childrenRootedTrees{k},rootChildren{k});
%             otherwise
%                 split3a(childrenRootedTrees, root);
        end
    end
%     leftovers{end+1} = subTree;    
end

