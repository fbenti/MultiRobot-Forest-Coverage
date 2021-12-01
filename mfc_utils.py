import numpy as np
import math, itertools
from scipy.io import loadmat

def manhattan(p1, p2):
    ''' Manhattan distance'''
    x = abs(p1[0] - p2[0])**2
    y = abs(p1[1] - p2[1])**2
    return math.sqrt(x+y)

def noConflictPairs(pairs):
    ''' Assign each drones to path, based on the initial position on the path'''
    minD = 100000000
    for i in range(len(pairs)):
        pairedDist = 0
        for j in range(len(pairs[i])):
            p1 = pairs[i][j][0]
            p2 = pairs[i][j][1]
            pairedDist += manhattan(p1,p2)
        print(pairedDist)
        if pairedDist < minD:
            minD = pairedDist
            bestIdx = i
    return pairs[i]

class Route:
    def __init__(self,idx,route):
        self.id = idx
        self.x, self.y, self.z = self.extractRoute(route)
        self.length = len(self.x)

    def extractRoute(self, route):
        x = route['x'][0][0][0][:]
        y = route['y'][0][0][0][:]
        z = route['z'][0][0][0][:]
        x_list, y_list, z_list = [],[],[]
        for j in range(len(x)):
            x_list.append(x[j])
            y_list.append(y[j])
            z_list.append(z[j])
        return x_list,y_list,z_list

class Param:
    def __init__(self, fileName):
        # Global variable
        mat_variables = loadmat(fileName)
        self.map = mat_variables['map']
        self.numDrones = mat_variables['numRobots'][0][0]
        self.routes = [Route(i,mat_variables['routes'][0][i]) for i in range(self.numDrones)]
        self.maxLength = self.findMaxLength()
        # self.roots = [i[0].tolist() for i in mat_variables['R4'][0]]
        self.roots = [[self.routes[i].x[0], self.routes[i].y[0], self.routes[i].z[0]] for i in range(self.numDrones)]

        # Technical parameters
        self.z_land = 0.2 # target for landing
        self.z_target = 1 # normal fly altitude
        self.z_offset = 0.3 # altitude offset when conflicts
        
        # Solve conflicts
        self.solveConflicts()
        
    def findMaxLength(self):
        ''' Find the path with maximum length '''
        temp = 0
        for i in range(len(self.routes)):
            max_i = max(len(self.routes[i].x),len(self.routes[i].y),len(self.routes[i].z))
            if max_i > temp:
                temp = max_i
        return temp

    def adjustLength(self):
        ''' Make paths of same length -> when occurred, bring the drones to land altitude'''
        for r in range(self.numDrones):
            while len(self.routes[r].x) < self.maxLength:
                self.routes[r].x.append(self.routes[r].x[-1]) # x: append last element
                self.routes[r].y.append(self.routes[r].y[-1]) # y: append last element
                self.routes[r].z.append(self.z_land) # z: append z land
            self.routes[r].length = self.maxLength



    ''' Help function to solve pssible conflicts '''


    def checkNextXYloc(self,k,idx):
        ''' Check conflict in only in x and y -> used when we changed altitude '''
        # k: next drone
        # idx: index next step in path
        for i in range(self.numDrones):
            if i != k:
                if (self.routes[k].x[idx] == self.routes[i].x[idx]
                    and self.routes[k].y[idx] == self.routes[i].y[idx]):
                    return True
        return False
    
    def conflictXY(self,j,l,idx):
        ''' Check conflict in X Y'''
        # j: current drone
        # l: next drone
        # idx: current index in path
        if (self.routes[j].x[idx] == self.routes[l].x[idx] 
            and self.routes[j].y[idx] == self.routes[l].y[idx]):
            return True
        else: return False
    
    def conflictXYZ(self,j,k,idx):
        ''' Check conflict in X Y Z '''
        # j: current drone
        # k: next drone
        # idx: current index in path
        if (self.routes[j].x[idx] == self.routes[k].x[idx]
            and self.routes[j].y[idx] == self.routes[k].y[idx]
            and self.routes[j].z[idx] == self.routes[k].z[idx]):
            return True
        else: return False

    def insertWait(self,id,idx):
        ''' Wait for 1 step'''
        # l: drone
        self.routes[id].x.insert(idx,self.routes[id].x[i-1])
        self.routes[id].y.insert(idx,self.routes[id].y[i-1])
        self.routes[id].z.insert(idx,self.routes[id].z[i-1])

    def copyLastZ(self,idx):
        ''' Copy value of previous Z for all drones'''
        for i in range(self.numDrones):
            if self.routes[i].z[idx] != self.z_land:
                self.routes[i].z[idx] = self.routes[i].z[idx-1]

    def setZtoTarget(self,idx,solvedConflict):
        ''' Bring back the drones to the z_target when possible'''
        for i in range(len(self.routes)):
            if i not in solvedConflict:
                if self.routes[i].z[idx] != self.z_land:
                    self.routes[i].z[idx] = self.z_target

    def countConflictXY(self,j,idx):
        ''' Count number of conflict between the current and the following drones'''
        droneID = []
        for i in range(j+1,self.numDrones):
            if self.conflictXY(j, i, idx):
                droneID.append(i)
        return droneID
        
    def solveConflicts(self):
        ''' Solve conflicts until no new steps are added'''
        self.adjustLength()
        prev_length = self.maxLength
        while True:
            for i in range(1,self.maxLength):

                # Copy the last Z for all drones
                self.copyLastZ(i)
                # Keep track of the conflict solved
                solvedConflict = []

                for j in range(self.numDrones):
                    # Z value of current drone
                    temp1 = self.routes[j].z[i]

                    # Find drone in conflict
                    droneInConflict = self.countConflictXY(j,i)
                    if droneInConflict:
                        solvedConflict.insert(0,j)
                    for el in droneInConflict:
                        if el in solvedConflict:
                            droneInConflict.remove(el)
                        else:
                            solvedConflict.append(el)
            
                    # Solve conflicts
                    for count in range(len(droneInConflict)):
                        if temp1 > self.z_target:
                            self.routes[droneInConflict[count]].z[i] = round(temp1 - (count+1)*self.z_offset,1)
                        elif temp1 < self.z_target:
                            self.routes[droneInConflict[count]].z[i] = round(temp1 + (count+1)*self.z_offset,1)
                        # If more thant 3 drones want to access the same cell, from the 4-th and on they have to wait
                        elif count > 1:
                            self.insertWait(droneInConflict[count],i)
                        elif count % 2 == 0: # temp1 == z_target
                            self.routes[droneInConflict[count]].z[i] = round(temp1 + self.z_offset,1)
                        else:
                            self.routes[droneInConflict[count]].z[i] = round(temp1 - self.z_offset,1)
            
                self.setZtoTarget(i,solvedConflict)

            # Check length
            self.adjustLength()
            self.maxLength = self.findMaxLength()
            if prev_length == self.maxLength:
                break