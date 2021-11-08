function addRootToLeftovers(root)
%ADDROOTTOLEFTOVERS Add the root to the leftovers when in step 2 the entire
% tree has been splitted away.
    
    global leftovers;
    
    % Check if the root has been already inserted
    for i = 1:length(leftovers)
        if height(leftovers{i}.Nodes) == 1 && leftovers{i}.Nodes.Name{1} == root.Nodes.Name{1}
            return;
        end
    end
    leftovers{end+1} = root;
end

