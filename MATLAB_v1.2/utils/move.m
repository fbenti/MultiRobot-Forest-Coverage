function move(nextDir,prevDir)
%MOVE Given the direction of movement, append to the waypoints the new grid
% location
    

    % next direction: RIGHT
    if nextDir == 'R'
        
        if prevDir == 'R' || prevDir == 'n'
            moveR();
            moveR();
        
        elseif prevDir == 'D'
            moveR();
            
        elseif prevDir == 'L'
            moveL();
            moveU();
            moveR();
            moveR();
            
        else % prevDir = 'U'
            moveU();
            moveR();
            moveR();
        end
    
    
    % next direction: DOWN
    elseif nextDir == 'D' 
        
        if prevDir == 'n'
            moveR();
            moveD();
            moveD();
            
        elseif prevDir == 'D'
            moveD();
            moveD();
        
        elseif prevDir == 'L'
            moveD();
        
        elseif prevDir =='R'
            moveR();
            moveD();
            moveD();
        
        else % prevDir = 'U'
            moveU();
            moveR();
            moveD();
            moveD();
        end
  
        
    % next direction: LEFT    
    elseif nextDir == 'L'
        
        if prevDir == 'n'
            moveR();
            moveD();
            moveL();
            moveL();
            
        elseif prevDir == 'L'
            moveL();
            moveL();

        elseif prevDir == 'R'
            moveR();
            moveD();
            moveL();
            moveL();
    
        elseif prevDir == 'D'
            moveD();
            moveL();
            moveL();
        
        else % prevDir = 'U'
            moveL();
        end
        
    
    % next direction: UP
    else % nextDir = 'U'
        
        if prevDir == 'n' 
            moveU();
            
        elseif prevDir == 'U'
            moveU();
            moveU();

        elseif prevDir == 'R'
            moveU();
%             moveU(); 
        
        elseif prevDir == 'D'
            moveD();
            moveL();
            moveU();
            moveU();
        
        else % prevDir = 'L'
            moveL();
            moveU();
            moveU();
        end
    
    end
    
end

