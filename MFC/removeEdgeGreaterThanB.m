function [G,s,t,weight] = removeEdgeGreaterThanB(G,s,t,weight)
%REMOVEEDGEGREATERTHANB Remove all edges greater than B which is the bound
%imposed
    global B;
%   Step 1 of Rooted-Tree-Cover Algorithm
    for i = 1:length(weight)
        if weight(i) > B
            G = rmedge(G,s(i),t(i));
%             weight = weight([1:i,i+2:end]);
            weight(i) = 0;
            s(i) = 0;
            t(i) = 0;
        end
    end
    weight = weight(weight ~= 0);
    s = s(s~=0);
    t = t(t~=0);
end

