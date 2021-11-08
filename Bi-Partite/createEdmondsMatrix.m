function [edmondsMtx, minimum] = createEdmondsMatrix(G)
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

    minimum = {};
    
    for i = 1:length(leftovers)
        min = {};
        for j = 1:length(nonLeftovers)
            minDistance.d = 1000000;
            minDistance.start = '-1';
            minDistance.end = '-1';
            for k = 1:height(leftovers{i}.Nodes.Name)
                for l = 1:height(nonLeftovers{j}.Nodes.Name)
                    [P,d] = shortestpath(G, leftovers{i}.Nodes.Name{k},nonLeftovers{j}.Nodes.Name{l}); 
                    if d < B
                        edmondsMtx(i,j) = 1;
                        if d < minDistance.d
                            minDistance.d = d;
                            minDistance.start = leftovers{i}.Nodes.Name{k};
                            minDistance.end = nonLeftovers{j}.Nodes.Name{l};
                        end
                    end
                end
            end
            min{end+1} = minDistance;
        end
        minimum{end+1} = min;
    end
                    
     
%     for i = 1:m
%         minDistance.d = 1000000;
%         minDistance.start = '-1';
%         minDistance.end = '-1';
%         for j = 1:n
%             for k = i:height(nonLeftovers{i}.Nodes.Name)
%                 [P,d] = shortestpath(G, nonLeftovers{i}.Nodes.Name{k},numeredRootsCell{j}); 
%                 if d < B
%                     edmondsMtx(i,j) = 1;
%                     if d < minDistance.d
%                         minDistance.d = d;
%                         minDistance.start = nonLeftovers{i}.Nodes.Name{k};
%                         minDistance.end = numeredRootsCell{j};
%                     end
%                 end
%             end
%         end
%         minimum{end+1} = minDistance;
%     end
end

