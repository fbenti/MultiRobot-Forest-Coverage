global N M;
N = 49;
M = N;


nIterations = 10;
it = 0;
while it < nIterations
    [map, numeredMap] = generateMap();
    unblockedCells = nnz(~map);
    smallCells = unblockedCells*4;
    line = [49 49 smallCells]
    it = it + 1;
end