function updateVisited(pos)
%UPDATEVISITED Update already visited large cells
    global visitedMtx visited numeredMap;
    
    [row,col] = find(numeredMap == pos);
    row = row * 2 -1;
    col = col * 2 -1;
    if (visitedMtx(row,col) == 1 && visitedMtx(row+1,col) == 1 && visitedMtx(row,col+1) == 1 && visitedMtx(row+1,col+1) == 1)
        visited((row+1)/2,(col+1)/2) = 1;
    end  
end

