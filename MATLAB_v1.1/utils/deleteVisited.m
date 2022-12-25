function neigh = deleteVisited(neigh)
%DELETEVISITED Delete the cell already visited from neighbors
    
    a = [];
    for i = 1:length(neigh)
        if checkVisited(neigh(i)) == 0
            a(end+1) = neigh(i);
        end
    end
    if isempty(a)
        neigh = neigh(1);
    else
        neigh = a;
    
    
end

