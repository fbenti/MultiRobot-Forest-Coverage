function neigh = get_neighbours(map,row,col,N,M)
%GET_NEIGHBOURS find neighbours of an adjacent cell
    neigh = cell(1,1);
    row_delta = [-1, 0, 0, 1];
    col_delta = [0, -1, 1, 0];
    k = 1;
    for i = 1:4
        row_neigh = row + row_delta(i);
        col_neigh = col + col_delta(i);
        if row_neigh >= 1 && row_neigh <= N && col_neigh >= 1 && col_neigh <= M
            if map(row_neigh,col_neigh) == 0
               neigh{k} = [row_neigh col_neigh];
               k = k+1;
            end
        end
end           

