function bool = bpm(u, seen, edmondsMtx)
%BPM A DFS based recursive function that returns true if a matching for
% vertex u is possible
% Tries all possibilities to assign a tree to a root, until there
% is a match.
    
    %  - If a root is not assigned to any trees, we simply assign to the matched
    %  tree and return true
    %  - If a root is assigned to another tree, we reursively check whether
    %  the other tree can be assigned to other root. To make sure that the
    %  tree doesn't get the same root again, we mark the root as seen
    %  before calling bpm(). If the tree can have another root, we change the
    %  match and return true. 
    %  - We usa an array maxR[0..N-1] that stores the tree assigned to the
    %  different root. (N is the number of tree).
    
    global matchR;
    bool = false;
    
    % Try every root
    for v = 1:width(edmondsMtx)
        
        % If root and tree are matched and v is not seen
        if edmondsMtx(u,v) == 1 && seen(v) == -1
            % mark v as visited
            seen(v) = 1;
            
            % If root-v is not assigned to a tree or previously
            % assigned tree for root-v (which is matchR(v)) has an
            % alternate root available. Since v is marked as
            % visited in the above line, matchR(v) in the following
            % recursive call will not get root-v again
            if matchR(v) == -1 || bpm(matchR(v),seen, edmondsMtx)
                matchR(v) = u;
                bool = true;
                return;
            end
        end
    end
    bool = false;
end

