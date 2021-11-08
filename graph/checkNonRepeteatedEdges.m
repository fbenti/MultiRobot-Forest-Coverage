function bool = checkNonRepeteatedEdges(s,t,numered_map,row,col,row_neigh,col_neigh)
% checkNonRepeteatedEdges Check vector s and t to do not create double edge
    bool = 1;
    for i = 1:length(t)
        if t(i) == numered_map(row,col) && s(i) == numered_map(row_neigh,col_neigh) || t(i) == numered_map(row_neigh,col_neigh) && s(i) == numered_map(row,col)
            bool = 0;
            break
        end
    end
end

