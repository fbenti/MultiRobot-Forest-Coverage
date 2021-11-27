#!/usr/bin/env python

from pycrazyswarm import Crazyswarm
from scipy.io import loadmat
from mfc_utils import *
import numpy as np
import math, itertools, copy


# crazyflies:
#   - id: 15
#     channel: 100
#     initialPosition: [0.0, 0.0, 0.0]
#     type: default
#   - id: 18
#     channel: 100
#     initialPosition: [0.0, 1.0, 0.0]
#     type: default
#   - id: 19
#     channel: 100
#     initialPosition: [1.0, 1.0, 0.0]
#     type: default


# Drone attributes
LAND_HEIGHT         = 0.05
LAND_DURATION       = 2
TAKEOFF_HEIGHT      = 1.0
TAKEOFF_DURATION    = 3
HOVER_DURATION      = 1
DISPERSE_DURATION   = 4
MOVE_DURATION       = 3



def help_takeoff(cfs, timeHelper):
    for cf in cfs:
        cf.takeoff(targetHeight=TAKEOFF_HEIGHT, duration=TAKEOFF_DURATION)
    timeHelper.sleep(TAKEOFF_DURATION + HOVER_DURATION)

# Land didn't work when swarm.allcfs.land() was used
def help_land(cfs, timeHelper):
    for cf in cfs:
        cf.land(targetHeight=LAND_HEIGHT, duration=LAND_DURATION)
    timeHelper.sleep(LAND_DURATION)

# To stop the motors
def help_stopSwarm(cfs):
    for cf in cfs:
        cf.cmdStop()

def help_move(cfs,timeHelper,goalArr):
    i = 0
    for cf in cfs:
        cf.goTo(goal=goalArr[i], yaw=0, duration=MOVE_DURATION)
        i += 1
    timeHelper.sleep(TAKEOFF_DURATION + HOVER_DURATION)


def main():
    # Grab data from matlab workspace
    mat_variables = loadmat("MFC/test.mat")
    param = Param(mat_variables)

    # Read yaml file
    swarm = Crazyswarm()
    timeHelper = swarm.timeHelper
    allcfs = swarm.allcfs


    # # Find best asscociation between cfs.InitialPos and Roots 
    initPos = [allcfs.crazyflies[i].initialPosition[:2] for i in range(param.numDrones)]
    cfsInitPos = []
    for i in range(len(initPos)):
        cfsInitPos.append([initPos[i][0],initPos[i][1]])

    # for x in itertools.permutations(cfsInitPos,int(param.numDrones)):
    #     print(x)
    # All possible permutations 
    pairs = [list(zip(x,param.roots)) for x in itertools.permutations(cfsInitPos,param.numDrones)]
    # Find the one with lowest distance
    pair = noConflictPairs(pairs)
    # for el in pair:
        # print(el)
        # print(el[0])
    # print(param.roots)
    # Find index to reorder the routes according to the pair found
    index = [param.roots.index(el[1]) for el in pair]
    # print(index)
    newRoutes = copy.deepcopy(param.routes)
    for i in range(len(index)):
        newRoutes[i] = param.routes[index[i]]
    param.routes = copy.deepcopy(newRoutes)


    # Takeoff
    # allcfs.takeoff(targetHeight=TAKEOFF_HEIGHT, duration=TAKEOFF_DURATION)
    # timeHelper.sleep(1.5+TAKEOFF_HEIGHT)
    help_takeoff(allcfs.crazyflies,timeHelper)    
    ''' from niceHover.py '''
    # for cf in allcfs.crazyflies:
    #     pos = np.array(cf.initialPosition) + np.array([0, 0, TAKEOFF_HEIGHT])
    #     cf.goTo(pos, 0, 1.0)

    # GO TO RESPECTIVE ROOTS
    id=0
    for cf in allcfs.crazyflies:
        goal = (param.routes[id].x[0], param.routes[id].y[0], param.routes[id].z[0])
        cf.goTo(goal, yaw=0.0, duration=10)
        timeHelper.sleep(TAKEOFF_DURATION + HOVER_DURATION)

    # Execute routes
    for i in range(1,param.maxLength):
        # goal : iterable of 3 floats
        goal = [(param.routes[id].x[i], param.routes[id].y[i], param.routes[id].z[i]) for id in range(param.numDrones)]
        # allcfs.goTo(goal=goal, yaw=0, duration=MOVE_DURATION)
        help_move(allcfs.crazyflies,timeHelper,goal)

    # allcfs.land(targetHeight=0.02, duration=1.0+TAKEOFF_HEIGHT)
    # timeHelper.sleep(1.0+TAKEOFF_HEIGHT)

    help_land(allcfs.crazyflies,timeHelper)


if __name__ == '__main__': 
    main()