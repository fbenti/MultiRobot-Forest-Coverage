function [map, numered_map] = generateMap()
%CREAT_MAP Generate 2d-map
    % N = randi([10 30],1,1);
    % M = randi([10 30],1,1);
    global N M;
    N = 5;
    M = 5;
    map = randsrc(N,M,[0,1 ; 0.8,0.2]);
    while not(connectedMap(map,N,M)== 1)
        map = randsrc(N,M,[0,1 ; 0.8,0.2]);
    end
    
    numered_map = zeros(N,M);
    num = 1;
    for i = 1:N
        for j = 1:M
            numered_map(i,j) = num;
            num = num + 1;
        end
    end
end

