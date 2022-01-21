% Variables
% global MAZEDIRECTIONS dx dy mazewidth mazeheight maze outdoor x;
% global robotNum cluster mazetype;


function maze = generateOutdoor()
    global N M walldensity;
    MAZEDIRECTIONS = 4;
    mazewidth = N;
    mazeheight = M;
    dx =  [0 1 0 -1 -1 1 1 -1];
    dy = [-1 0 1 0 -1 -1 1 1];
    
    %Outdoor terrain
    permute = [1 2 3 4 5 6 7 8];
    
    maze = zeros(mazewidth,mazeheight);
    outdoor = zeros(mazewidth,mazeheight);
    for x = 1:mazewidth
        for y = 1:mazeheight
            outdoor(x,y) = -2;
        end
    end
    
    x=2;
    y=2;
    outdoor(2,2) = -1;
    walls = (mazewidth-2) * (mazeheight-2) - 1;
    
    while 1
        for d = 0 : MAZEDIRECTIONS - 2
            randomnumber = mod(randi(intmax),MAZEDIRECTIONS-d)+1;
            permutetmp = permute(randomnumber);
            permute(randomnumber) = permute(MAZEDIRECTIONS-1-d);
            permute(MAZEDIRECTIONS-1-d) = permutetmp;
        end
        
        for dtmp = 1 : MAZEDIRECTIONS
            d = permute(dtmp);
            newx = x + 2*dx(d);
            newy = y + 2*dy(d);
            % maybe greater than 1
            if (newx > 1 && newx < mazewidth ...
                && newy > 1 && newy < mazewidth ...
                && outdoor(newx,newy) == -2)
                if outdoor(x+dx(d),y+dy(d)) == -2
                    outdoor(x+dx(d),y+dy(d)) = 0;
                    walls = walls -1;
                end
                outdoor(newx,newy) = x*mazeheight + y;
                walls = walls -1;
                x = newx;
                y = newy;
                break;
            end
        end
        if dtmp == MAZEDIRECTIONS
            if outdoor(x,y) == -1
                break
            end
            newx = floor(outdoor(x,y) / mazeheight);
            newy = mod(outdoor(x,y),mazeheight);
            x = newx;
            y = newy;
        end
    end
    
    while (walls > walldensity * (mazewidth-2) * (mazeheight-2))
        % ?????
        newx = mod(randi(intmax),mazewidth-2) + 1;
        newy = mod(randi(intmax),mazeheight-2) + 1;
        if outdoor(newx+1,newy+1) == -2
            outdoor(newx+1,newy+1) = 0;
            walls = walls - 1;
        end
    end
    
     for x = 1 : mazewidth
        for y = 1 : mazeheight
            if outdoor(x,y) == -2
                outdoor(x,y) = 1;
            else
                outdoor(x,y) = 0;
            end
        end
     end
     
     if walls < walldensity * (mazewidth-2) * (mazeheight-2) - 1
         disp("*** not enough obstacles ***");
     end
     
%      for x = 1 : mazewidth 
%          for y = 1 : mazeheight
%             if outdoor(x,y) == 1
%                 maze(x,y) = 1;
%             end
%          end
%      end
    maze = outdoor;
end