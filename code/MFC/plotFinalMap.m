function plotFinalMap(G1,kRootedTrees)
%PLOTFINALMAP Summary of this function goes here
    
    global numeredRootsCell;
    
    figure
    plotColors = jet(length(numeredRootsCell));
    if length(numeredRootsCell) > 3 
        plotColors(4,:) = [0.5 0.5 0.9];
    end
    p2 = plot(removeEmptyNodes(G1));
    title("Final Map")
    for i = 1 : length(kRootedTrees)
        % Now plot just this one.
        highlight(p2,kRootedTrees{i}.Nodes.Name,'NodeColor', plotColors(i, :))%, 'LineWidth', 2);
    end
    highlight(p2, numeredRootsCell,'NodeColor','r'); 
end

