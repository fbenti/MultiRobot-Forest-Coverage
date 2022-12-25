function moveD()
%MOVED Move one step towards down
% The step lenght is the dimension of the robot
    global x y z off_xy visitedMtx curr_x curr_y;
    
    x(end+1) = x(end) + off_xy;
    y(end+1) = y(end);
    z(end+1) = z(end);
    
    curr_x = curr_x + 1;
    visitedMtx(curr_x,curr_y) = 1;
    
end

