function neigh = setPriority(neigh,curr,nextDir)
%UNTITLED Define the first neighbor to explore for the root

    global M;
    % Delete already visited cell
    neigh = deleteVisited(neigh);
    
    % Reduce to just two possible neigh
    if length(neigh) > 2
        if nextDir == 'n'
            neigh(end) = [];
        elseif nextDir == 'U' || nextDir == 'R'
            neigh(end) = [];
        elseif nextDir == 'D'
            neigh(1) = [];
        elseif nextDir == 'L'
            neigh(2) = [];
        end
    end
        
    
    if length(neigh) == 2

        if nextDir == 'n'
            if neigh(1) == (curr - 1) && neigh(2) == (curr - M)
                neigh = neigh(2);
                return
            elseif neigh(1) == (curr - M) && neigh(2) == (curr + 1)
                neigh = neigh(1);
                return
            elseif neigh(1) == (curr + 1) && neigh(2) == (curr + M)
                neigh = neigh(1);
                return;
            elseif neigh(1) == (curr - 1) && neigh(2) == (curr + M)
                neigh = neigh(2);
                return;
            end
        elseif neigh(1) == (curr -1) && neigh(2) == (curr + 1) && nextDir == 'D'
            neigh = neigh(2);
            return;
        elseif neigh(1) == (curr -1) && neigh(2) == (curr + 1) && nextDir == 'U'
            neigh = neigh(1);
            return;
        elseif neigh(1) == (curr -1) && neigh(2) == (curr + M) %&& (nextDir == 'D' || nextDir == 'L')
            neigh = neigh(2);
            return;
            
        elseif neigh(1) == (curr + 1) && neigh(2) == (curr + M) %&& (nextDir == 'D' || nextDir == 'R')
            neigh = neigh(1);
            return;
            
        elseif neigh(1) == (curr - M) && neigh(2) == (curr + 1) %&& (nextDir == 'R' || nextDir == 'U')
            neigh = neigh(1);
            return;
        elseif neigh(1) == (curr - M) && neigh(2) == (curr - 1) %&& (nextDir == 'L' || nextDir == 'U')
            neigh = neigh(2);
            return;
        elseif neigh(1) == (curr - M) && neigh(2) == (curr + M) && nextDir == 'R'
            neigh = neigh(1);
            return;
        elseif neigh(1) == (curr - M) && neigh(2) == (curr + M) && nextDir == 'L'
            neigh = neigh(2);
            return;     
        end
    end
            
    
%     neigh = deleteVisited(neigh);
    if length(neigh) > 1 && neigh(1) == curr -1
        neigh = neigh(2);
    else 
        neigh = neigh(1);
    end
   
        
end

