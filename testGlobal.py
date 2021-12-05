from scipy.io import loadmat
from mfc_utils import *
import numpy as np
import math, itertools, copy

def help_updateMap(pos,id):
    pos = [int(pos[0]*2-1),int(pos[1]*2-1)]
    map[pos[0]][pos[1]] = id
    print("\n",map,"\n")

def main():
    global map
    '''Import Matlab workspace'''
    fileName = "matlab_param/test_6_6_2.mat"
    param = Param(fileName)
    map = param.map
    
    help_updateMap([2,2],5)
    help_updateMap([2,2.5],5)
    


if __name__ == '__main__':
    main()