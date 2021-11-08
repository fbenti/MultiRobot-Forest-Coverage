function neigh = setPriority(neigh,curr)
%UNTITLED Define the first neighbor to explore for the root

    global M;
    % The priority, since CLOCKWISE direction, is to turn left when in we
    % are in a cross
    
    if length(neigh) == 2
        if neigh(1) == curr -1 && neigh(2) == curr + 1
            neigh = neigh(1);
            return;
        elseif neigh(1) == (curr - M) && neigh(2) == (curr + M)
            neigh = neigh(2);
            return;
        end
    end
            
    
    neigh = deleteVisited(neigh);
    if length(neigh) > 1 && neigh(1) == curr -1
        neigh = neigh(2);
    else 
        neigh = neigh(1);
    end
   
        
end

