function neigh = removeCurr(neigh,curr,next)
%REMOVECURR Remove current postion in the array 
    
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
            neigh = setPriority(neigh, next);
        end
%         if length(neigh) > 1            
%             neigh = deleteSmallerPos(neigh, curr);
%         end
    end
end

