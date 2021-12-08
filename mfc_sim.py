"""Simulation of the spiral mapping algorithm. Useful to validate the performance."""


from math import fabs
from pycrazyswarm import Crazyswarm
import numpy as np
import random
import sys, os
from scipy.io import loadmat
from mfc_utils import *
import numpy as np
import math, itertools, copy


DISPERSE_DURATION   = 1
LAND_DURATION       = 1
LAND_HEIGHT         = 0.2
MOVE_DURATION       = 0.5
TAKEOFF_HEIGHT      = 1
TAKEOFF_DURATION    = 1

SIMULATION          = True
PRINTS              = True
initMap             = None

class HiddenPrints:
    def __enter__(self):
        self._original_stdout = sys.stdout
        sys.stdout = open(os.devnull, 'w')

    def __exit__(self, exc_type, exc_val, exc_tb):
        sys.stdout.close()
        sys.stdout = self._original_stdout

def getColors(cfs):
    # r,g,b = 0,0,0
    for cf in cfs:
        r,g,b = random.random(), random.random(), random.random()
        cf.setLEDColor(r,g,b)

def help_convertPos(pos):
    pos = np.array((pos[0]*2-1, pos[1]*2-1, pos[2])).astype(float)
    return pos

def help_disperse(cfs, roots, timeHelper):
    for cf in cfs:     
        pos = np.array(roots.pop()).astype(float)
        cf.pose = pos.astype(float)
        print("\nDrone {} going towards roots : {}".format(cf.id, pos))
        help_updateMap(cf.pose,cf.id)
        if SIMULATION:    
            cf.goTo(goal=cf.pose, yaw=0, duration=DISPERSE_DURATION)
        else:
            pos = help_convertPos(cf.pose)
            cf.updatePos(pos)
        timeHelper.sleep(DISPERSE_DURATION)
        cf.sense()

def help_goTo(cfs, idx, param, timeHelper):
    global routes, landed
    changed = False
    listConflictID = conflictXY(routes,idx)
    for i,cf in enumerate(cfs):
        # If alrady landed, do nothing
        if landed[i] == True:
            continue
        # If index NOT within the routes, land
        elif not(idx < len(routes[i].x)):
            # cf.land(targetHeight=LAND_HEIGHT, duration=LAND_DURATION)
            landed[i] = True
            continue
        # Otherwise, check for conflict
        elif i in listConflictID:
            routes = insertWait(routes,i,idx)
            print("\nDrone {} has to wait".format(cf.id))
            continue
        goal = [routes[i].x[idx], routes[i].y[idx], routes[i].z[idx]]
        cf.pose = np.array(goal).astype(float)
        print("\nDrone {} goint towards {}".format(cf.id, goal))
        help_updateMap(cf.pose,cf.id)
        if SIMULATION:
            cf.goTo(goal=cf.pose, yaw=0, duration=MOVE_DURATION)
        else:
            pos = help_convertPos(cf.pose)
            cf.updatePos(pos)
        changed = True

    if SIMULATION:
        timeHelper.sleep(MOVE_DURATION, trail=True)
    return changed

# To stop the motors
def help_stopSwarm(cfs):
    for cf in cfs:
        cf.cmdStop()

# def help_updateMap(cfs):
#     for cf in cfs:
#         cf.updateMap()

def help_updateMap(pos,id):
    pos = [int(pos[0]*2-1),int(pos[1]*2-1)]
    map[pos[0]][pos[1]] = id
    # print("\n",map,"\n")

def stopCondition():
    global landed
    if False in landed:
        return False
    else:
        return True

def mfc():
    global landed, routes, map
    '''Import Matlab workspace'''
    fileName = "matlab_param/test_12_12_3.mat"
    param = Param(fileName)
    map = param.map
    landed = [False]*param.numDrones

    ''' Read yaml file'''
    swarm = Crazyswarm(map=map)
    timeHelper = swarm.timeHelper
    allcfs = swarm.allcfs.crazyflies
    getColors(allcfs)


    ''' Reorder route of the crazyflies based on the initial position from yaml'''
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

    '''' 1 - Takeoff '''
    if SIMULATION:
        swarm.allcfs.takeoff(targetHeight=TAKEOFF_HEIGHT, duration=TAKEOFF_DURATION)
        timeHelper.sleep(TAKEOFF_DURATION*3)
    print("\n--- Takeoff completed ---")

    ''' 2 - Go To Roots '''
    help_disperse(allcfs, param.roots, timeHelper)
    # help_updateMap(allcfs)
    # print(map)

    print("\n--- Roots Reached ---")

    ''' 3 - Follow Routes '''
    idx = 1
    while not(stopCondition()):
        changed = help_goTo(allcfs, idx, param, timeHelper)
        # help_updateMap(allcfs)
        if changed:
            idx += 1
            print("\n--- Step {} completed ---".format(idx))    
    print("\n--- Map Completely Covered in {} steps ---".format(idx))
    
    
    '''4 - Land '''
    # allcfs.land(targetHeight=0.02, duration=1.0+TAKEOFF_HEIGHT)
    if SIMULATION:
        swarm.allcfs.land(targetHeight=0.0,duration=LAND_DURATION)
        timeHelper.sleep(LAND_DURATION)




    

def main():
    if PRINTS:
        return mfc()
    else:
        with HiddenPrints():
            return mfc()


if __name__ == "__main__":

    main()


x1 = [1.5, ]
x2 = [2.5]
y1 = [4.5,]
y2 = [3.5]
z1 = [1,1,1,1,1,1,1]
z2 = [1,1,1,1,1,1,1]
