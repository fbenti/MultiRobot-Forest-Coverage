function neigh = findNextNeigh(neigh,curr,next,nextDir)
%FINDNEXTNEIGH findNextNeigh
    
    if length(neigh) == 1
        return;
    else
        for i = 1:length(neigh)
            if neigh(i) == curr
                neigh(i) = [];
                neigh = unique(neigh);
                break;
            end
        end
        
        if length(neigh) > 1
            neigh = setPriority(neigh, next,nextDir);
        end
%         if length(neigh) > 1            
%             neigh = deleteSmallerPos(neigh, curr);
%         end
    end
end

