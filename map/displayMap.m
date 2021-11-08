function displayMap(map)
%DISPLAYMAP Display grid map
    [N,M] = size(map);
    %add an empty row and column for pcolor
    column = zeros(N,1);
    map = [map column];
    row = zeros(1,M+1);
    map = [map;row];
    
    % convert 1 to -1 and 0 to 1
    map(map==1)=-1;
    map(map==0)=1;
    
    %display
    img = pcolor(map);
    colormap(gray(2));
%     set(img(, 'EdgeColor','r');
    axis ij;
    axis square;
end

