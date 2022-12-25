function map4 = mapMFC()
%mapMFC From a simple indoor map, find its respective map for algorithm
    global map;
    [N,M] = size(map);
    map4 = zeros(2*N,2*M);
    for i = 1:N
        for j = 1:M
            if map(i,j) == 1
                map4(i*2-1,j*2-1) = 1;
                map4(i*2-1,j*2) = 1;
                map4(i*2,j*2-1) = 1;
                map4(i*2,j*2) = 1;
                j = j + 2;
            end
        end                
    end
end

