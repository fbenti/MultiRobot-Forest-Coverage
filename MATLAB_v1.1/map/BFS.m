function BFS(x,y,i,j)
%BFS Finds all cells connected with map(i,j)
    global visited COUNT;
%     if 2 adjacaent cell are not equal,return
    if not(x == 0 && y == 0)
        return
    end
    
    visited(i,j) = 1;
    COUNT = COUNT + 1;   
    x_move = [0,0,1,-1];
    y_move = [1,-1,0,0];
    for k = 1:4
        if isValid(i+x_move(k), j+y_move(k))
          BFS(x,y, i + x_move(k), j + y_move(k))
        end
    end
end

