function kRootedTrees = constructTrees(oldG,matchR,minimumD)
%CONSTRUCTTREES Return the final tree for each robot.
% Return  k-trees where each tree consists of the leftover subtree of the 
% root r, the single nonleftover subtree (if any) matched to the root and
% weight minimal path (if any) from the non leftover subtree to the 
% leftover subtree.

    global leftovers nonLeftovers rootNonLeftovers numeredRootsCell;
    
    kRootedTrees = {};
    
    for i = 1:length(numeredRootsCell)
        
        found = false;
        for j = 1:width(matchR)
            if matchR(j) == i
                found = true;
                break;
            end
        end
        
        if found == false
            kRootedTrees{i} = leftovers{i}; 
        else
            shortest = shortestpath(oldG, minimumD{i}{j}.start,minimumD{i}{j}.end);
            shortestGraph = subgraph(oldG, shortest);
            arr = categorical([leftovers{i}.Edges.EndNodes(:,1), leftovers{i}.Edges.EndNodes(:,2);...
                nonLeftovers{j}.Edges.EndNodes(:,1),nonLeftovers{j}.Edges.EndNodes(:,2);...
                shortestGraph.Edges.EndNodes(:,1),shortestGraph.Edges.EndNodes(:,2)],...
                'Ordinal',true);
            for k = 1:height(arr)
                if arr(k,2) < arr(k,1)
                    temp = arr(k,2);
                    arr(k,2) = arr(k,1);
                    arr(k,1) = temp;
                end
            end 
            arr = cellstr(unique(arr,'rows'));
            weight = [];
            for k = 1:length(arr)
                weight(end+1) = 4;
            end
            kRootedTrees{i} = graph(arr(:,1), arr(:,2), weight); 
        end
    end
end

