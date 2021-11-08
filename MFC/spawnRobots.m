function [roots,numRobots] = spawnRobots()
%SPAWNROBOTS Randomly spwan robots in the map
    global map;
    [N,M] = size(map);
%     numRobots = randi(5)
    numRobots = 3;
%   Each cell has to be different form the others
    roots = cell(1,numRobots);
%     x = randi(M);
%     y = randi(N);
%     arrayPos{1} = [x y];
    it = 0;
    while it < numRobots
        x = randi(M);
        y = randi(N);
        if isInCell(roots,[x y]) || map(x,y) == 1
            continue
        else
            roots{it+1} = [x,y];
            it = it +1;
        end
    end
end

