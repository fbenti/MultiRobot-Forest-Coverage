function bool = isInCell(cell, b)
%IS_IN_CELL check if a tuple is in cell
bool = false;
for k = 1:numel(cell)
  if isequal(cell{k}, b)
    bool = true;
    return;
  end
end