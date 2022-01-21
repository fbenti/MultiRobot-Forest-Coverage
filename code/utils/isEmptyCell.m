function bool = isEmptyCell(cell)
%CELL_IS_EMPTY check if all the element are null
bool = 1;
for i = 1:length(cell)
    if ~isempty(cell{i})
        bool = 0;
        return
    end
end

