function [result, matchR, minimum] = maxBPM(G)
%MAXBPM Return Maximum BiPartite matching
    
    % Create Edmonds Matrix of non-leftovers trees and roots.
    % which represent a Bi-Partite graph: one side of the vertex set is the
    % nodes representing the non-leftover trees and the other is R.
    [edmondsMtx, minimum] = createEdmondsMatrix(G);
    
    % An array to keep track of the non-leftovers trees assigned to roots.
    % The value of matchR[i] is the tree assigned to root-i, the
    % value -1 indicates none tree is assigned
    global matchR;
    matchR = zeros(1,width(edmondsMtx));
    matchR(1,:) = -1;
    
    seen = zeros(1,width(edmondsMtx));
    
    % Count of root assigned to tree
    result = 0;
    
    for i = 1:height(edmondsMtx)
        
        % Mark all root as non seen for the next tree
        seen(1,:) = -1;
        
        % Find if the tree-i can have a root
        
        if bpm(i,seen,edmondsMtx) == true
            result = result + 1;
        end 
    end
end

