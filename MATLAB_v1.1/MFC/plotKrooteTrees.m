function plotKrooteTrees(kRootedTrees)
%PLOTKROOTETREES Summary of this function goes here
    global numeredRootsCell;
    
    figure
    sgtitle("Final k-Rooted Trees")
    for i = 1:length(kRootedTrees)
        subplot(1,4,i)
        p1 = plot(kRootedTrees{i});
        highlight(p1, numeredRootsCell{i},'NodeColor','r');
    end
end

