function moveR()
%MOVER Move one step towards right
% The step lenght is the dimension of the robot
    global x y z off_xy visitedMtx curr_x curr_y;
    
    x(end+1) = x(end);
    y(end+1) = y(end) + off_xy;
    z(end+1) = z(end);

    curr_y = curr_y + 1;
    visitedMtx(curr_x,curr_y) = 1;
       
end

