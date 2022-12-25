function bool = connectedMap(map1,n,m)
%CONNECTEDGRAPH verify if the map is connected
%   Detailed explanation goes here
    global map visited result COUNT N M;
    
    map = map1;
    visited = zeros(N,M);
    result = zeros(N,M);
    COUNT = 0;
    N = n;
    M = m;
    currentMax = -1000000;
    zerosInMap = nnz(~map);
    bool = 0;
    
    for i = 1:N
        for j = 1:M
            resetVisited();
            COUNT = 0;
%           check cell to the right
            if (j+1 < M)
                BFS(map(i,j),map(i,j+1),i,j);
            end
            if (COUNT >= currentMax)
                currentMax = COUNT;
                resetResult();
            end
            if currentMax == zerosInMap
                bool = 1;
                return;
            end
            
            resetVisited();
            COUNT = 0;
%           check cell downwards
            if (i+1 < N)
                BFS(map(i,j),map(i+1,j),i,j);
            end
            if (COUNT >= currentMax)
                currentMax = COUNT;
                resetResult();
            end
            if currentMax == zerosInMap
                bool = 1;
                return;
            end
        end
    end 
end