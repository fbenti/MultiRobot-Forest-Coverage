function kRootedTrees = newConstruct(oldG,matchR,minimumD)
%CONSTRUCTTREES Return the final tree for each robot.
% Return  k-trees where each tree consists of the leftover subtree of the 
% root r, the single nonleftover subtree (if any) matched to the root and
% weight minimal path (if any) from the non leftover subtree to the 
% leftover subtree.

    global leftovers nonLeftovers numeredRootsCell;
    
    kRootedTrees = {};
    kRootedTreesMatch = {};
    % matchR : combine nonLeftover i with leftover(matchR(i,j))
    %       - row: nonLeftover
    %       - col: leftover

    
    for i = 1:height(matchR)
        match = matchR(i,:);
        trackLeftover = [];
        matchedTrees = {};
        % Combine non-leftovers j and leftovers match(j) based on the matchR
        for j = 1:width(matchR)
            trackLeftover(end+1) = match(j);
            shortest = shortestpath(oldG, minimumD{j}{match(j)}.start,minimumD{j}{match(j)}.end);
            shortestGraph = subgraph(oldG, shortest);
            arr = categorical([leftovers{match(j)}.Edges.EndNodes(:,1), leftovers{match(j)}.Edges.EndNodes(:,2);...
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
            matchedTrees{end+1} = graph(arr(:,1), arr(:,2), weight); 
        end
        
        % Add the leftover not considered before
        for k = 1:length(leftovers)
            if not(ismember(k,trackLeftover))
                matchedTrees{end+1} = leftovers{k};             
            end
        end
        kRootedTreesMatch = [kRootedTreesMatch; matchedTrees];
    end
    
    % Save the max length of the trees in order to find the
    % weigth-minimal k-rooted tree
    minLength = 1000000;
    idx = 1;
    for i = 1:height(kRootedTreesMatch)
        maxLengthMatch = 0;
        for j = 1:width(kRootedTreesMatch)
            len = height(kRootedTreesMatch{i,j}.Nodes);
            if len > maxLengthMatch
                maxLengthMatch = len;
            end
        end
        if maxLengthMatch < minLength
            minLength = maxLengthMatch;
            idx = i;
        end
    end
    
    for j = 1:width(kRootedTreesMatch)
        kRootedTrees{end+1} = kRootedTreesMatch{idx,j};
    end
    
    
    matchUsed = matchR(idx,:);
    if length(matchUsed) == 1 && matchUsed == 2
        temp = kRootedTrees{2};
        kRootedTrees{2} = kRootedTrees{1};
        kRootedTrees{1} = temp;
        return;
    else
        copyKTrees = kRootedTrees;
        matchedSubgraph = [];
        for i = 1:length(kRootedTrees)
            matchLeft = [];
            for j = 1:length(leftovers)
                idx = findnode(kRootedTrees{i}, leftovers{j}.Nodes.Name);
                if not(ismember(0,idx))
                    matchLeft(end+1) = j;
                else
                    matchLeft(end+1) = 0;
                end
            end
            matchedSubgraph = [matchedSubgraph; matchLeft];
        end    

        % Reorder trees
        order = zeros(1,length(kRootedTrees));
        while 1
            idx = 1;
            for i = 1:height(matchedSubgraph)
                line = matchedSubgraph(i,:);
                for j = 1:width(matchedSubgraph)
                    if line(j) ~= 0 && line(j) ~= order(i) ... 
                        && (sum(line~=0) >= length(kRootedTrees) - 2)
                        order(idx) = line(j);
%                         idx = idx + 1;
                        break;
                    end
                end
                idx = idx + 1;
            end
            if ( length(unique(order)) == length(kRootedTrees) ...
                && not(ismember(0,order)) )
                % Reorder trees based on the order of the leftovers
                for k = 1:length(kRootedTrees)
                    kRootedTrees{order(k)} = copyKTrees{k};
                end
                break;
            end
        end
    end
    return;

