function [x,y,z] = resolveConflict(x,y,z)
%CHECKOVERLAPS Check overlaps between the position of drones, if so change
% the altitude Z of the drone with with the lowest-id 
    
    a = [];
    for i = 1:length(x)
        a(end+1) = x(i);
        a(end+1) = y(i);
    end
    a  = reshape(a,2,[])';
    b = unique(a,'rows','stable');
    count = [];
    for i = 1:length(b)
        count(end+1) = nnz(ismember(a,b(i,:),'rows'));
    end 
    
    k = 1;
    for i = 1:length(x)-1
        alpha = 1;
        beta = 1;
        odd = true;
        if x(i) == b(k,1) && y(i) == b(k,2) && k < length(b)
            for j = i+1:length(x)
                if x(i) == x(j) && y(i) == y(j)
                    if odd == true
                        z(j) = z(j) +  alpha * 0.5;
                        odd = false;
                        alpha = alpha + 1;
                    else
                        z(j) = z(j) - beta * 0.5;
                        odd = true;
                        beta = beta + 1;
                    end
                end
            end
            k = k+1;
        end
    end
end

