% Parameters
Z = 1;
dt = 0.1;
rate = rosrate(1 / dt);

% Initialize log variables
state_history = [];
cmd_history = [];
t_history = [];

swarm = Crazyswarm("crazyflies.yaml");
time = ros.internal.Time;  % Faster than calling rostime("now")

% Takeoff
swarm.takeoff(Z, 1.0+Z) % altitude, duration
pause(1.5 + Z)

% Go to respective route - find an optimisaziont for this part (distance)
i = 1;
for cf = swarm.crazyflies
    pos = [R4{i}(1), R4{i}(2), Z];
    cf{1}.goTo(cf{1}.initialPosition + pos, 0, 2)
    i = i +1;
end
pause(2)

% Exeute path step-by-step
% Fly in circle
reset(rate)
t_id = 1;
[x,y,z] = deal([]);
tic
while t_id < 33
    ros_time = time.CurrentTime;
    t_history(t_id) = ros_time.Sec +ros_time.Nsec / 1e9;
    
    state_history(:,:,t_id) = swarm.state();
    
    % Define next position for each drones
    for i = 1:length(routes)
        if t_id > length{routes{i}.x
            x(end+1) = x(end);
            y(end+1) = y(end);
            z(end+1) = z(end);
        else
            x(end+1) = routes{i}.x(t_id);
            y(end+1) = routes{i}.y(t_id);
            z(end+1) = routes{i}.z(t_id);
        end
    end
    
%     % Check non-overlapping pos
%     [x,y,z] = resolveConflict(x,y,z);
    
    % Create a posVec
    posVec = zeros(length(swarm.crazyflies),3);
    for i = 1:length(x)
        posVec(i,1:3) = [x(i) y(i) z(i)];   
    end
    
    for i = 1:length(swarm.crazyflies)
        cf = swarm.crazyflies{i};
        cf.cmdPosition(cf.initialPosition + posVec, 0)
        cmd_history(:, i, t_id) = [cf.initialPosition + pos, vel]';
    end    
end
toc

% Switch to high-level mode and go back to initial position
for cf = swarm.crazyflies
    cf{1}.notifySetpointsStop(100)
    cf{1}.goTo(cf{1}.initialPosition + [0, 0, Z], 0, 2)
end
pause(2)

% Land
swarm.land(0.02, 2)
pause(2)

plotting(t_history, state_history, cmd_history)
