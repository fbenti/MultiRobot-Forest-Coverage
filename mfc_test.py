#!/usr/bin/env python

from pycrazyswarm import Crazyswarm
from scipy.io import loadmat
from mfc_utils import *
import numpy as np
import math, itertools, copy




# Drone attributes
LAND_HEIGHT         = 0.05
LAND_DURATION       = 2
TAKEOFF_HEIGHT      = 1
TAKEOFF_DURATION    = 3
HOVER_DURATION      = 2
DISPERSE_DURATION   = 8
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
        
        pos = np.array(roots.pop()).astype(float)
        cf.pose = pos.astype(float)

        print("\nDrone {} goint towards roots : {}".format(cf.id, pos))
        
        cf.goTo(goal=cf.pose, yaw=0, duration=DISPERSE_DURATION)
        timeHelper.sleep(DISPERSE_DURATION + HOVER_DURATION)

        # Since each drone has it own origin as its initialPosition and the goal is wrt that
        # cf.goTo(goal=(cf.pose-cf.initialPosition), yaw=0, duration=DISPERSE_DURATION)
        # timeHelper.sleep(DISPERSE_DURATION + HOVER_DURATION)


def help_goTo(cfs, goalArr, timeHelper):
    i = 0
    for cf in cfs:
        cf.pose = np.array(goalArr[i]).astype(float)
        print("\nDrone {} goint towards {}".format(cf.id, goalArr[i]))
        cf.goTo(goal=cf.pose, yaw=0, duration=MOVE_DURATION)
        i += 1
    timeHelper.sleep(MOVE_DURATION)

def stopSwarm(cfs):
    for cf in cfs:
        cf.cmdStop()


def main():
    '''Import Matlab workspace'''
    fileName = "matlab_param/test_5_5_2.mat"
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

    try:
        '''' 1 - Takeoff '''
        #allcfs.takeoff(targetHeigth=TAKEOFF_HEIGHT, duration=TAKEOFF_DURATION)
        #timeHelper.sleep(1.5+TAKEOFF_HEIGHT)
        help_takeoff(allcfs,timeHelper)

        print("\n--- Takeoff completed ---")

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
            print("\n--- Step {} completed ---".format(i))


        print("--- Map Completely Covered --> LANDING ---")
        '''4 - Land '''
        # allcfs.land(targetHeight=0.02, duration=1.0+TAKEOFF_HEIGHT)
        help_land(allcfs, timeHelper)
        timeHelper.sleep(1.0)
        stopSwarm(allcfs)
        
    except Exception as e:
        print(e)
        help_land(allcfs, timeHelper)
        timeHelper.sleep(1.0)
        stopSwarm(allcfs)


if __name__ == '__main__':
    main()