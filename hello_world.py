"""Takeoff-hover-land for one CF. Useful to validate hardware config."""

from pycrazyswarm import Crazyswarm
import numpy as np

TAKEOFF_DURATION = 3
TAKEOFF_HEIGHT = 1
LAND_DURATION       = 3
HOVER_DURATION = 3.0
GOTO_DURATION = 3.0
LAND_HEIGHT         = 0.05

# Scaling for FlowDeck
scale = np.array([0.75, 0.75, 0.5])

def scale2R(pos):
    return pos*scale

def takeoff(cfs, timeHelper):
    for cf in cfs:
        cf.takeoff(targetHeight=TAKEOFF_HEIGHT, duration=TAKEOFF_DURATION)
    timeHelper.sleep(TAKEOFF_DURATION)

def land(cfs, timeHelper):
    for cf in cfs:
        cf.land(targetHeight=LAND_HEIGHT, duration=LAND_DURATION)
    timeHelper.sleep(LAND_DURATION)

def stopSwarm(cfs):
    for cf in cfs:
        cf.cmdStop()

def main():
    swarm = Crazyswarm()
    timeHelper = swarm.timeHelper
    cfs = swarm.allcfs.crazyflies

    #cf.takeoff(targetHeight=1.0, duration=TAKEOFF_DURATION)
    #timeHelper.sleep(TAKEOFF_DURATION + HOVER_DURATION)
    #cf.goTo((0.0,1.0,1,0), yaw=0.0, duration=GOTO_DURATION)
    #timeHelper.sleep(TAKEOFF_DURATION + HOVER_DURATION)
    #cf.land(targetHeight=0.04, duration=2.5)
    #timeHelper.sleep(TAKEOFF_DURATION)

    # takeoff(cfs,timeHelper)


    land(cfs,timeHelper)
    # stopSwarm(cfs)


if __name__ == "__main__":
    main()
