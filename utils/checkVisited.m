function bool = checkVisited(pos)
%CHECKVISITED Keep track of already visited big cell


    global numeredMap visitedMtx visited;
    
    bool = false;
    
    [row,col] = find(numeredMap == pos);
    row = row * 2 -1;
    col = col * 2 -1;
    if (visitedMtx(row,col) == 1 && visitedMtx(row+1,col) == 1 && visitedMtx(row,col) == 1 && visitedMtx(row+1,col+1) == 1)
        visited((row+1)/2,(col+1)/2) = 1;
        bool = true;
        
    end
end

