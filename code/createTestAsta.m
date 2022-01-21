% Script for Simulation-Test

% matlab -nodisplay -nosplash -nodesktop -r "run('path/to/your/script.m');exit;" | tail -n +11
% matlab -batch "Simulation"
%{
---- Parameters ----
numRobots: number of drones spawned

N,M : size of the map
unblockedCells: number of free big cells
smallCells: number of free small cells
idealCoverTime: idealized cover time, if no robob need to pass through alredy
                seen small cells

w_max: Largest weight of any large cell
w_sum: Sum of the weights of all large cells
B: bound B, the algorithm return a K-rooted tree cover of graph G with 
   weight at most 4B
B_min: lower bound of B
B_max: upper bound of B


min_w: lowest tree weight
min_w: bigget tree weight

%}
%     
% clear;
% clc;
global N M B numRobots R walldensity;
global map numeredMap numeredRoots numeredRootsCell;
global leftovers nonLeftovers rootNonLeftovers rootIdx subTree treeRootedR;
N = 49;
M = N;
numRobots = 2;
dim = 0.5;
walldensity = 0.1;


[map, numeredMap] = generateMap();
% Create graph based on the map
[G,s,t,weight] = generateGraph();
% Convert into large map (each cell becomes a 4x4)
map4 = mapMFC();


R = spawnRobots();
[numeredRoots, numeredRootsCell]  = convertR();

unblockedCells = nnz(~map);
smallCells = unblockedCells*4;
idealCoverTime = ceil(smallCells/numRobots) -1;

w_max = 4;
w_sum = w_max * unblockedCells;
phi = w_max / w_sum;
eps = phi * numRobots;


% Using Binary search to find an optimal value for B, such that MFC find a
% K-rooted tree whose weight is at most a factor of 4(1+eps) larger than
% minimal
B_lower = w_max;
B_upper = w_sum;
B = (B_lower + B_upper) / 2;
diff = B_upper - B_lower;

while diff > 1 + eps
    try
        B = (B_lower + B_upper) / 2
        % Step 2
        [G1,s1,t1,weight1] = removeEdgeGreaterThanB(G,s,t,weight); 
        % Step 3
        [G2,s2,t2,weight2] = groupRoots(G1,s1,t1,weight1);
        [M2,pred2] = minspantree(G2,'Root',findnode(G2,'contractedRoots'));
        % Step 4
        [forest_M,G3,M3] = obtainForest(G2,M2);
        forest_M = orderForest(forest_M);
        % Step 5
        [leftovers, nonLeftovers, rootNonLeftovers] = deal({});
        treeEdgeDecomposition(forest_M);
        
        % Check            
        [proceed, matchR, minimumD] = maxBPM(G1);
        if proceed == true
%             disp("match")
            B_upper = B
            diff = B_upper - B_lower
            continue;                      
        else
%             disp("not match")
            B_lower = B; 
            diff = B_upper - B_lower;
            continue;
        end
    catch e
        fprintf(1,'The identifier was:\n%s',e.identifier);
        fprintf(1,'There was an error! The message was:\n%s',e.message);
        break;
    end
end
format long
B_hat = B_lower / (1+eps);
B = (1+eps)*B_hat;
[leftovers, nonLeftovers, rootNonLeftovers] = deal({});
treeEdgeDecomposition(forest_M);
[proceed, matchR, minimumD] = maxBPM(G1);
if proceed == true
    disp("Final B = B_lower: ", int2str(B))
%     kRootedTrees = constructTrees(G1,matchR, minimumD);
    kRootedTrees = newConstruct(G1,matchR, minimumD);
    [routes, R4] = extractRoute(kRootedTrees, dim);
    [minW, maxW] = findWeight(routes);
    ratio = maxW / idealCoverTime;
    line = [numRobots, N, M, smallCells, idealCoverTime, maxW, minW, ratio];
    disp(line)
else
    B = B_upper
    disp("Final B =  B_upper: ", int2str(B))
    [leftovers, nonLeftovers, rootNonLeftovers] = deal({});
    treeEdgeDecomposition(forest_M);
    [matching, matchR, minimumD] = maxBPM(G1);
%     kRootedTrees = constructTrees(G1,matchR, minimumD);
    kRootedTrees = newConstruct(G1,matchR, minimumD);
    [routes, R4] = extractRoute(kRootedTrees, dim);
    [minW, maxW] = findWeight(routes);
    ratio = maxW / idealCoverTime;
    line = [numRobots, N, M, smallCells, idealCoverTime, maxW, minW, ratio];
    disp(line)
end
% %     


% write csv!!!
% line = [numRobots, N, M, smallCells, idealCoverTime, maxW, minW, ratio];
% disp(line)


% disp(line)
fname = sprintf('wsAsta/test_%d_%d_%d.mat', N,M,numRobots);
save(fname, 'routes','numRobots','R','R4','map','map4');
fname = sprintf('wsAsta/table_%d_%d_%d.csv', N,M,numRobots);
writematrix(line, fname)
%     
    
    


