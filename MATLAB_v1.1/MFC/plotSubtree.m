function plotSubtree(trees)
%PLOTSUBTREE Summary of this function goes here
    figure
    for i = 1:length(trees)
        subplot(1,4,i)
        p1 = plot(trees{i});
    %     highlight(p1, numeredRootsCell{i},'NodeColor','r');
    end
end

