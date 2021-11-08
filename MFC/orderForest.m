function newForest = orderForest(forest_M)
%ORDERFOREST Order the tress in Forest in increasing order (as the root in R)
    global numeredRootsCell;
    
    newForest = {};
    
    for i = 1:length(numeredRootsCell)
        for j = 1:length(forest_M)
            if findnode(forest_M{j}, numeredRootsCell{i}) ~= 0
                newForest{end+1} = forest_M{j};
            end
        end
    end           
end
