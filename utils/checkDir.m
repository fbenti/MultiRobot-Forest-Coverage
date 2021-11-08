function dir = checkDir(curr, next)
%CHECKDIR Given current and next position, return the direction of movement
    global M;
    
    if curr + 1 == next
        dir = 'R';
        
    elseif curr - 1 == next
        dir = 'L';
    
    elseif curr + M == next
        dir = 'D';
    
    else
        dir = 'U';
    
    end
    
    return
    
end

