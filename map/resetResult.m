function resetResult()
%RESERTRESULT keep track of the result obtained (map of adjacent 0s)
    global map result visited N M;
        for i = 1:N
            for j = 1:M
                if (visited(i,j)==1) && map(i,j) == 0
                    result(i,j) = visited(i,j);
                else
                    result(i,j)=0;
                end
            end
        end
end

