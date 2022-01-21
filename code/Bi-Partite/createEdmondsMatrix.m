function [edmondsMtx, adjMtrx, minimum] = createEdmondsMatrix(G)
%CREATEEDMONDSMATRIX Create th Edmonds Matrix of non-leftovers trees and
%roots
%   The input of the maximum flow algorithm has to be an Edmonds matrix
%   between the non-leftovers trees (rows) and the roots (columns)
%   If the shortestpath between the (i-tree and j-root) < B, then the
%   respective Edmonds value is 1, otherwise 0.

    global B numeredRootsCell nonLeftovers leftovers;
     
    m = length(nonLeftovers);
    n = length(numeredRootsCell);
    edmondsMtx = zeros(m,n);
    adjMtrx = zeros(m,n);
    
    minimum = {};
    
    % Find minimum distance betwenn non-Leftovers and leftovers
    for i = 1:length(nonLeftovers)
        min = {};
        for j = 1:length(leftovers)
            minDistance.d = 1000000;
            minDistance.start = '-1';
            minDistance.end = '-1';
            for k = 1:height(nonLeftovers{i}.Nodes.Name)
                for l = 1:height(leftovers{j}.Nodes.Name)
                    [P,d] = shortestpath(G, nonLeftovers{i}.Nodes.Name{k},leftovers{j}.Nodes.Name{l}); 
                    if d < minDistance.d
                        minDistance.d = d;
                        minDistance.start = nonLeftovers{i}.Nodes.Name{k};
                        minDistance.end = leftovers{j}.Nodes.Name{l};
                    end
                    if d <= B
                        edmondsMtx(i,j) = 1;
                    end
                end
            end
            min{end+1} = minDistance;
            adjMtrx(i,j) = minDistance.d;
        end
        minimum{end+1} = min;
    end
end

