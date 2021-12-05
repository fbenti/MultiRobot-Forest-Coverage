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
LAND_DURATION       = 0.5
LAND_HEIGHT         = 0.0
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
        if SIMULATION:    
            cf.goTo(goal=cf.pose, yaw=0, duration=DISPERSE_DURATION)
        else:
            pos = help_convertPos(cf.pose)
            cf.updatePos(pos)
        timeHelper.sleep(DISPERSE_DURATION)
        cf.sense()

def help_goTo(cfs, idx, timeHelper):
    global routes, landed

    listConflictID = routes.conflictXY(idx)
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
        if i in listConflictID:
            routes.insertWait(i,idx)
            print("\nDrone {} has to wait".format(cf.id))
            continue
        
        goal = [(routes[i].x[idx], routes[i].y[idx], routes[i].z[idx])]
        cf.pose = np.array(goal).astype(float)
        print("\nDrone {} goint towards {}".format(cf.id, goal))
        if SIMULATION:
            cf.goTo(goal=cf.pose, yaw=0, duration=MOVE_DURATION)
        else:
            pos = help_convertPos(cf.pose)
            cf.updatePos(pos)

    if SIMULATION:
        timeHelper.sleep(MOVE_DURATION, trail=True)

# To stop the motors
def help_stopSwarm(cfs):
    for cf in cfs:
        cf.cmdStop()

def help_updateMap(cfs):
    for cf in cfs:
        cf.updateMap()

def stopCondition():
    global landed
    if False in landed:
        return False
    else:
        return True

def check(cfs):
    for cf in cfs:
        cf.sense()
        if cf.stop == False:
            for k in range(8):
                if cf.case[k] == 1:
                    cf.move = k
                    print("Drone id:",cf.id,"dir:",cf.dir,"move:",cf.move)
                    break

def mfc():
    global landed, routes, map
    '''Import Matlab workspace'''
    fileName = "matlab_param/test_5_5_2.mat"
    param = Param(fileName)
    map = param.map
    landed = [False]*param.numDrones
    routes = param.routes

    ''' Read yaml file'''
    swarm = Crazyswarm(map=map)
    timeHelper = swarm.timeHelper
    allcfs = swarm.allcfs.crazyflies


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

    '''' 1 - Takeoff '''
    if SIMULATION:
        swarm.allcfs.takeoff(targetHeight=TAKEOFF_HEIGHT, duration=TAKEOFF_DURATION)
        timeHelper.sleep(TAKEOFF_DURATION)
    print("\n--- Takeoff completed ---")

    ''' 2 - Go To Roots '''
    help_disperse(allcfs, param.roots, timeHelper)
    help_updateMap(allcfs)

    ''' 3 - Follow Routes '''
    idx = 0
    while not(stopCondition()):
        help_goTo(allcfs, idx, timeHelper)
        help_updateMap(allcfs)
        idx += 1
        print("\n--- Step {} completed ---".format(i))
    print("\n--- Map Completely Covered --> LANDING ---")
    
    '''4 - Land '''
    # allcfs.land(targetHeight=0.02, duration=1.0+TAKEOFF_HEIGHT)
    if SIMULATION:
        swarm.allcfs.land(targetHeight=0.0,duration=LAND_DURATION)
        timeHelper.sleep(LAND_DURATION)
    print("\n--- Coverage Completed ---")
    

def main():
    if PRINTS:
        return mfc()
    else:
        with HiddenPrints():
            return mfc()


if __name__ == "__main__":

    main()