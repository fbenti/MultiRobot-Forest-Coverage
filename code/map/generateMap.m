function [map, numered_map] = generateMap()
%CREAT_MAP Generate 2d-map
   global N M;  
    map = generateOutdoor();
    
    numered_map = zeros(N,M);
    num = 1;
    for i = 1:N
        for j = 1:M
            numered_map(i,j) = num;
            num = num + 1;
        end
    end
end

