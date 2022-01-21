function [routes, R4] = extractRoute(kRootedTrees, dim)
%EXRACTROUTE Given the spanning tree of each robot, return the respective
%route that circumnavigates the tree.
%   in CLOCKWISE direction
global x y z off_xy off_z numeredRoots visitedMtx visited N M curr_x curr_y;

R4 = orderRoot();
off_xy = 1;
off_z = 1;

routes = {};

for i = 1:length(kRootedTrees)

    % Set initial condition
    init_x = R4{i}(1);
    init_y = R4{i}(2);
    % Adapt to map4
    curr_x = init_x;
    curr_y = init_y;

    % Array of consecutive position
    x = init_x;
    y = init_y;
    z = 1;

    visited = zeros(N,M);
    visitedMtx = zeros(N*2,M*2);
    visitedMtx(init_x,init_y) = 1;

    % Set current position and null 'prevDir'
    curr = numeredRoots(i);
    prevDir = 'n'; % meaning NULL
    nextDir = 'n';


   % If only 1 node
    if height(kRootedTrees{i}.Nodes) == 1
        moveR();
        moveD();
        moveL();
        route.x = x * dim;
        route.y = y * dim;
        route.z = z;
        routes{i} =  route;
        continue
    end
     % Set the neighbor's root that has to be explored as 1st
    neigh = sort(str2double(neighbors(kRootedTrees{i}, num2str(curr))));
    neigh = setPriority(neigh, curr,nextDir);

    % Find route
    numNodes = height(kRootedTrees{i}.Nodes);
    while 1
        % Next grid cell idex to be explored
        next = neigh(1);
        neigh(1) = [];

        % Find next direction of movement and define next position
        nextDir = checkDir(curr,next);
        move(nextDir, prevDir);
        updateVisited(curr);

        % Update neighbors
        new_neigh = str2double(neighbors(kRootedTrees{i}, num2str(next)))';
        neigh = findNextNeigh(new_neigh,curr,next,nextDir);

        % Update current position and next 
        curr = next;
        prevDir = nextDir;

        % check condtion:
        switch prevDir
            case 'U'
                if x(end) - off_xy == init_x && y(end) == init_y && length(x) >= numNodes*4
                    break;
                end
            case 'R'
                if x(end) == init_x && y(end) + off_xy == init_y && length(x) >= numNodes*4
                    break;
                end
            case 'D'
                if x(end) == init_x && y(end) + off_xy == init_y && length(x) >= numNodes*4
                    break;
                end
            case 'L'
                if x(end) == init_x && y(end) - off_xy == init_y && length(x) >= numNodes*4
                    break;
                end
        end       

        % Solve particular bug
        if last3pos(init_x, init_y) && length(x) >= numNodes*4 
            break;
        end
    end

    % Add each route
    route.x = x * dim;
    route.y = y * dim;
    route.z = z;
    routes{i} =  route;
    end
end

