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
MOVE_DURATION       = 1
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
        # help_updateMap(cf.pose,cf.id)
        if SIMULATION:    
            cf.goTo(goal=cf.pose, yaw=0, duration=DISPERSE_DURATION)
        else:
            # pos = help_convertPos(cf.pose)
            # cf.updatePos(pos)
            cf.updatePos(cf.pose)
        timeHelper.sleep(DISPERSE_DURATION)

def help_goTo(cfs, idx, routes, timeHelper):
    # global routes
    global landed
    changed = False
    listConflictID = conflictXY(routes,idx)
    for i,cf in enumerate(cfs):
        print(i)
        # print(routes.x)
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
            print(i)
            print("\nDrone {} has to wait".format(cf.id))
            continue
        goal = [routes[i].x[idx], routes[i].y[idx], routes[i].z[idx]]
        cf.pose = np.array(goal).astype(float)
        print("\nDrone {} goint towards {}".format(cf.id, goal))
        # help_updateMap(cf.pose,cf.id)
        updateMap(cfs)
        if SIMULATION:
            cf.goTo(goal=cf.pose, yaw=0, duration=MOVE_DURATION)
        else:
            pos = help_convertPos(cf.pose)
            cf.updatePos(cf.pose)
        changed = True

    if SIMULATION:
        timeHelper.sleep(MOVE_DURATION, trail=True)
    return changed

# To stop the motors
def help_stopSwarm(cfs):
    for cf in cfs:
        cf.cmdStop()


def updateMap(cfs):
    for cf in cfs:
        cf.updateMap()

def help_updateMap(pos,id):
    # pos = [int(pos[0]*2-1),int(pos[1]*2-1)]
    map[int(pos[0])][int(pos[1])] = id
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
    fileName = "matlab_param/test_6_6_2.mat"
    param = Param(fileName)
    map = param.map
    landed = [False]*param.numDrones

    ''' Read yaml file'''
    swarm = Crazyswarm(map=map)
    timeHelper = swarm.timeHelper
    allcfs = swarm.allcfs.crazyflies
    getColors(allcfs)


    # x1 = [1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0, 7.5, 8.0]
    # x2 = [5.5, 5.0, 4.5, 4.0, 3.5, 3.5, 3.5, 3.0, 2.5]
    # x3 = [3.5, 3.5, 3.5, 3.5, 3.5, 3.5, 4.0, 4.5]
    # y1 = [3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0, 3.0]
    # y2 = [3.0, 3.0, 3.0, 3.0, 3.0, 3.5, 3.5, 3.5, 3.5]
    # y3 = [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 3.5, 3.5]
    # z1 = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    # z2 = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]
    # z3 = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0]

    # param.routes[0].x = x1
    # param.routes[0].y = y1
    # param.routes[0].z = z1
    # # param.routes[1].x = x2
    # # param.routes[1].y = y2
    # # param.routes[1].z = z2
    # param.routes[1].x = x3
    # param.routes[1].y = y3
    # param.routes[1].z = z3

    # param.roots[0] = [param.routes[0].x[0],param.routes[0].y[0], param.routes[0].z[0]]
    # param.roots[1] = [param.routes[1].x[0],param.routes[1].y[0], param.routes[1].z[0]]
    # param.roots[2] = [param.routes[2].x[0],param.routes[2].y[0], param.routes[2].z[0]]


    # only for sim 
    for i in range(param.numDrones):
        allcfs[i].initialPosition = allcfs[i].initialPosition / 0.5
        print(param.routes[i])
        param.roots[i] = (np.array(param.roots[i]) / 0.5).astype(int).tolist()
        param.roots[i][2] = 1
        param.routes[i].x = (np.array(param.routes[i].x) / 0.5).astype(int).tolist()
        param.routes[i].y = (np.array(param.routes[i].y) / 0.5).astype(int).tolist()
        # param.routes[i].z = (np.array(param.routes[i].z) / 0.5).tolist() 

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
        allcfs[i].initialPosition = copy.deepcopy(cfsInitPos[index[i]])

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
        changed = help_goTo(allcfs, idx, param.routes, timeHelper)
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
