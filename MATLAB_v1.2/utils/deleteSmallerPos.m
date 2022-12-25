function neigh = deleteSmallerPos(neigh,curr)
%DELETESMALLERPOS Given a set of neighbours and the current position,
%delete the neighbors with a smaller index
    a = [];
    for i = 1 : length(neigh)
        if neigh(i) > curr
            a(end+1) = neigh(i);
        end
    end

    if not(isempty(a))
        neigh = a;
    else
        neigh = neigh(1);
    end
end

