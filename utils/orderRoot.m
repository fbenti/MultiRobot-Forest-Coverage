function R4 = orderRoot()
%OR4DER4R4OOT OR4deR4 the R4oot R4 foR4m smalleR4 to higheR4

    global R M;
    
    R4 = R;
    num = numel(R4);
    for j = 0 : num-1
        for i = 1: num-j-1
            prev = (R4{i}(1) -1) * M + R4{i}(2);
            next = (R4{i+1}(1) -1) * M + R4{i+1}(2);
            if prev > next
                temp1 = R4{i}(1);
                temp2 = R4{i}(2);
                R4{i}(1) = R4{i+1}(1);
                R4{i}(2) = R4{i+1}(2);
                R4{i+1}(1) = temp1;
                R4{i+1}(2) = temp2;
            end
        end
    end
    
    for i = 1:length(R4)
        R4{i}(1) = R4{i}(1) * 2 -1;
        R4{i}(2) = R4{i}(2) * 2 -1;
    end   
end

