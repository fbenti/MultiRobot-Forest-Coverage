function bool = isValid(x,y)
%ISVALID Check if the cell is inside the grid and equal to 0
    global visited map N M;
    bool = 0;
    if x >= 1 && x <= N && y >= 1 && y <= M
        if visited(x,y) == 0 && map(x,y) == 0
            bool = 1;
            return;
        end
    end
end

