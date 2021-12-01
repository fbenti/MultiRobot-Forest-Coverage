#!/usr/bin/env python

from pycrazyswarm import Crazyswarm
from scipy.io import loadmat
from mfc_utils import *
import numpy as np
import math, itertools, copy




# Drone attributes
LAND_HEIGHT         = 0.05
LAND_DURATION       = 2
TAKEOFF_HEIGHT      = 0.5
TAKEOFF_DURATION    = 1+TAKEOFF_HEIGHT
HOVER_DURATION      = 1
DISPERSE_DURATION   = 4
MOVE_DURATION       = 2



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

def help_disperse(cfs, roots, timeHelper):
    for cf in cfs:
        # If collision avoidance is implemented takeoff() can be called before disperse instead
        # cf.takeoff(targetHeight=TAKEOFF_HEIGHT, duration=TAKEOFF_DURATION)
        # timeHelper.sleep(TAKEOFF_DURATION + HOVER_DURATION)
        
        pos = np.array(roots.pop())
        cf.pose = pos.astype(float)

        cf.goTo(goal=cf.pose, yaw=0, duration=DISPERSE_DURATION*2)
        timeHelper.sleep(DISPERSE_DURATION + HOVER_DURATION)

        # Since each drone has it own origin as its initialPosition and the goal is wrt that
        # cf.goTo(goal=(cf.pose-cf.initialPosition), yaw=0, duration=DISPERSE_DURATION)
        # timeHelper.sleep(DISPERSE_DURATION + HOVER_DURATION)


def help_goTo(cfs, goalArr, timeHelper):
    i = 0
    for cf in cfs:
        cf.pose = np.float(goalArr[i].astype(float))
        cf.goTo(goal=cf.pose, yaw=0, duration=MOVE_DURATION)
    
    timeHelper.sleep(MOVE_DURATION)



def main():
    '''Import Matlab workspace'''
    fileName = "matlab_param/test_5_5.mat"
    param = Param(fileName)

    ''' Read yaml file'''
    swarm = Crazyswarm()
    timeHelper = swarm.timeHelper
    allcfs = swarm.allcfs.crazyflies

    ''' Reorder route'''
    # Find best asscociation between cfs.InitialPos and Roots 
    cfsInitPos = [allcfs[i].initialPosition for i in range(param.numDrones)]
    # All possible permutations 
    pairs = [list(zip(x,cfsInitPos)) for x in itertools.permutations(param.roots,param.numDrones)]
    # Find the one with lowest distance
    pair = noConflictPairs(pairs)
    # Find index to reorder the routes according to the pair found
    index = [param.roots.index(el[0]) for el in pair]
    newRoutes = copy.deepcopy(param.routes)
    for i in range(len(index)):
        newRoutes[i] = param.routes[index[i]]
    param.routes = copy.deepcopy(newRoutes)

    '''' 1 - Takeoff '''
    allcfs.takeoff(targetHeigth=TAKEOFF_HEIGHT, duration=TAKEOFF_DURATION)
    timeHelper.sleep(1.5+TAKEOFF_HEIGHT)
    
    ''' 2 - Go To Roots '''
    # for cf in allcfs.crazyflies:
    #     pos = np.array(cf.initialPosition) + np.array([0, 0, TAKEOFF_HEIGHT])
    #     cf.goTo(pos, 0, 1.0)
    help_disperse(allcfs, param.roots, timeHelper)

    ''' 3 - Follow Routes '''
    for i in range(1,param.maxLength):
        # goTo(self, goal, yaw, duration, groupMask = 0)
        # goal : iterable of 3 floats
        # allcfs.goTo(goal=goal, yaw=0, duration=MOVE_DURATION)

        goal = [(param.routes[cf].x[i], param.routes[cf].y[i], param.routes[cf].z[i]) for cf in range(param.numDrones)]
        help_goTo(allcfs, goal, timeHelper)

    '''4 - Land '''
    # allcfs.land(targetHeight=0.02, duration=1.0+TAKEOFF_HEIGHT)
    help_land(allcfs, timeHelper)
    timeHelper.sleep(1.0+TAKEOFF_HEIGHT)


if __name__ == '__main__':
    main()