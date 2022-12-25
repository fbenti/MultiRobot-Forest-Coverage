function [G,s,t,weight] = groupRoots(G1,s1,t1,weight1)
%GROUPROOTS Step 2 of Rooted-Tree-Cover Algorithm
    % Roots in R are contracted to a single node
        
    global numeredRoots;
    
    % Add a specialNode which connect all the root with edge weight 0
    [G,s,t,weight] = addSpecialNode(G1,s1,t1,weight1);
    [M,pred] = minspantree(G,'Root',findnode(G,'contractedRoots')); 
    
%     p = plot(G);
%     highlight(p,M);
%     highlight(p, numeredRoots,'NodeColor','r');
%     highlight(p, 'contractedRoots', 'NodeColor','g');

end
