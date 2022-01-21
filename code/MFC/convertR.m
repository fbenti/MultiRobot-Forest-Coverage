function [roots, cell]  = convertR()
%CONVERTR Convert (x,y) position of the roots into element of the numered
% map
    global R numeredMap;
    roots = [];
    cell = {};
    for i = 1:length(R)
        roots(i) = numeredMap(R{i}(1),R{i}(2));
        cell{end+1} = int2str(numeredMap(R{i}(1),R{i}(2)));
    end
    
    num = numel(roots);
    for j = 0 : num-1
        for i = 1: num-j-1
            if roots(i)>roots(i+1)
                temp = roots(i);
                tempCell = cell{i};
                roots(i) = roots(i+1);
                roots(i+1) = temp;
                cell{i} = cell{i+1};
                cell{i+1} = tempCell;
            end
        end
    end
end

