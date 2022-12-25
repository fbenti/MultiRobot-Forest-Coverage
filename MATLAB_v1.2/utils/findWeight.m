function [min,max] = findWeight(routes)
%FINDWEIGHT Summary of this function goes here
    global numRobots;
    max = 0;
    min = 1000000000;
    for i = 1:numRobots
        len = length(routes{i}.x);
        if len < min
            min = len;      
        end
        if len > max
            max = len;
        end
    end
end

