function [proceed, matchR, minimum] = maxBPM(G)
%MAXBPM Return Maximum BiPartite matching
    
    % Create Edmonds Matrix of non-leftovers trees and roots.
    % which represent a Bi-Partite graph: one side of the vertex set is the
    % nodes representing the non-leftover trees and the other is R.
    [edmondsMtx, adjMtx, minimum] = createEdmondsMatrix(G);
    
    matchR = [];
    proceed = false;
    if height(edmondsMtx) > width(edmondsMtx)
        return;
    end
    
    for i = 1:length(edmondsMtx)
        arrInd = [];
        if edmondsMtx(i) == 1
            arrInd(end+1) = i;
            for j = 2:height(edmondsMtx)
                found = false;
                for k = 1:length(edmondsMtx)
                    if edmondsMtx(j,k) == 1 && not(ismember(k,arrInd))
                        arrInd(end+1) = k;
                        found = true;
                        break;
                    end
                end
                if found == false
                    arrInd(end+1) = -1;
                    break;
                end
            end
        end
        if not(ismember(-1,arrInd))
            matchR = [matchR;arrInd];
        end
    end
    if not(ismember(-1,matchR))
        proceed = true;
    end
    
% %     for i = 1:height(match)
% %         kRootedTrees = constructTrees(G,match(i),
%         
%                         
%     % An array to keep track of the non-leftovers trees assigned to roots.
%     % The value of matchR[i] is the tree assigned to root-i, the
%     % value -1 indicates nothing is assigned
%     global matchR;
%     matchR = zeros(1,width(edmondsMtx));
%     matchR(1,:) = -1;
%     
%     seen = zeros(1,width(edmondsMtx));
%     % Count of root assigned to tree
%     result = 0;
% 
%         for i = 1:height(edmondsMtx)
%             % Mark all root as non seen for the next tree
%             seen(1,:) = -1;
%             % Find if the tree-i can have a root
%             if bpm(i,seen,edmondsMtx) == true
%                 matchR
%                 result = result + 1;
%             end
%         end

end

