function bool = last3pos(init_x,init_y)
%LAST3POS Check in x y z if in the last 3 position there is the root
%   If so, delete respective element to stop the drone in the correct
%   position
    
    global x y z;
    bool = false;
    if length(x) > 6
        for i = 2 : -1 : 0
            if x(end-i) == init_x && y(end-i) == init_y 
                x(end-i : end) = [];
                y(end-i : end) = [];
                z(end-i : end) = [];
                bool = true;
                return;
            end
        end
    end
end

