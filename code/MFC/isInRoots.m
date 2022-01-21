function bool = isInRoots(roots,x)
%ISINROOTS Check if a cell is one of the roots
%  
    bool = false;
    for i = 1:length(roots)
        if x == roots(i)
            bool = true;
            return;
        end
    end
end

