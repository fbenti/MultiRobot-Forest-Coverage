#!/usr/bin/env python

from pycrazyswarm import Crazyswarm
from scipy.io import loadmat
from mfc_utils import *
import numpy as np
import math, itertools, copy


# Drone attributes
DISPERSE_DURATION   = 8
LAND_HEIGHT         = 0.05
LAND_DURATION       = 2
HOVER_DURATION      = 2
MOVE_DURATION       = 2
TAKEOFF_HEIGHT      = 1
TAKEOFF_DURATION    = 3


def help_updateMap(pos,id):
    pos = [int(pos[0]*2-1),int(pos[1]*2-1)]
    map[pos[0]][pos[1]] = id
    print("\n",map,"\n")


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

        print("\nDrone{} goint towards roots : {}".format(cf.id, pos))
        
        cf.goTo(goal=cf.pose-cf.initialPosition, yaw=0, duration=DISPERSE_DURATION)
        timeHelper.sleep(DISPERSE_DURATION + HOVER_DURATION)
        help_updateMap(cf.pose,cf.id)

        # Since each drone has it own origin as its initialPosition and the goal is wrt that
        # cf.goTo(goal=(cf.pose-cf.initialPosition), yaw=0, duration=DISPERSE_DURATION)
        # timeHelper.sleep(DISPERSE_DURATION + HOVER_DURATION)


def help_goTo(cfs,idx,param,timeHelper):
    global routes, landed
    changed = False
    listConflictID = conflictXY(routes,idx)
    for i,cf in enumerate(cfs):
        # If alrady landed, do nothing
        if landed[i] == True:
            continue
        # If index NOT within the routes, land
        elif not(idx < len(routes[i].x)):
            cf.land(targetHeight=LAND_HEIGHT, duration=LAND_DURATION)
            landed[i] = True
            continue
        # Otherwise, check for conflict
        elif i in listConflictID:
            routes = insertWait(routes,i,idx)
            print("\nDrone{} has to wait".format(cf.id))
            continue

        goal = [routes[i].x[idx], routes[i].y[idx], routes[i].z[idx]]
        cf.pose = np.array(goal).astype(float)
        print("\nDrone{} goint towards {}".format(cf.id, goal))
        print(cf.pose)
        print(cf.initialPosition)
        print(cf.pose - cf.initialPosition)
        cf.goTo(goal=cf.pose - cf.initialPosition, yaw=0, duration=MOVE_DURATION)
        help_updateMap(cf.pose, cf.id)
        changed = True
    timeHelper.sleep(MOVE_DURATION)
    return changed

def stopCondition():
    global landed
    if False in landed:
        return False
    else:
        return True

def stopSwarm(cfs):
    for cf in cfs:
        cf.cmdStop()


def main():
    global map, routes, landed
    '''Import Matlab workspace'''
    fileName = "matlab_param/test_6_6_2.mat"
    param = Param(fileName)
    map = param.map
    landed = [False]*param.numDrones

    ''' Read yaml file'''
    swarm = Crazyswarm(map = map)
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

    routes = copy.deepcopy(param.routes)

    # x1 = [1.5, ]
    # x2 = [2.5]
    # y1 = [4.5,]
    # y2 = [3.5]
    # z1 = [1,1,1,1,1,1,1]
    # z2 = [1,1,1,1,1,1,1]

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
        idx = 1
        while not(stopCondition()):
            changed = help_goTo(allcfs, idx, param, timeHelper)
            if changed:
                print("\n--- Step {} completed ---".format(idx))
                idx += 1
        print("\n--- Map Completely Covered in {} steps ---".format(idx))

        '''4 - Land '''
        # allcfs.land(targetHeight=0.02, duration=1.0+TAKEOFF_HEIGHT)
        # help_land(allcfs, timeHelper)
        timeHelper.sleep(1.0)
        stopSwarm(allcfs)
        
    except Exception as e:
        print(e)
        help_land(allcfs, timeHelper)
        timeHelper.sleep(1.0)
        stopSwarm(allcfs)


if __name__ == '__main__':
    main()