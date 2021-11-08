function [G1,s,t,weight] = addSpecialNode(G,s,t,weight)
%ADDSPECIALNODE Add a special node to graph G that is connected to all the roots
    % with 0 weight.
    global R numeredMap;
    roots = [];
    for i = 1:length(R)
        roots(i) = numeredMap(R{i}(1),R{i}(2));   
    end
    specialNode = numeredMap(end)+1;
%     label = 'specialNode';
    label = 'contractedRoots';
    for i = 1:length(roots)
        s(end+1) = specialNode;
        t(end+1) = roots(i);
        weight(end+1) = 0;
    end
    
    % create new graph adding a label 'specialNode'
    G1 = graph(s,t,weight);
    labels = [G.Nodes.Name; label];
    %     G1 = removeEmptyNodes(G);
    G1.Nodes.Name = [G.Nodes.Name; label];
end

