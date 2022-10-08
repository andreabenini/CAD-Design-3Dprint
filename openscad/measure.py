#!/usr/bin/env python

# Python script to find STL dimensions
# Requrements: sudo pip install numpy-stl

import math
import stl
from stl import mesh
import numpy

import os
import sys

if len(sys.argv) < 2:
    sys.exit('Usage: %s [stl file]' % sys.argv[0])

if not os.path.exists(sys.argv[1]):
    sys.exit('ERROR: file %s was not found!' % sys.argv[1])

# this stolen from numpy-stl documentation
# https://pypi.python.org/pypi/numpy-stl

# find the max dimensions, so we can know the bounding box, getting the height,
# width, length (because these are the step size)...
def find_mins_maxs(obj):
    minx = maxx = miny = maxy = minz = maxz = None
    for p in obj.points:
        # p contains (x, y, z)
        if minx is None:
            minx = p[stl.base.Dimension.X]
            maxx = p[stl.base.Dimension.X]
            miny = p[stl.base.Dimension.Y]
            maxy = p[stl.base.Dimension.Y]
            minz = p[stl.base.Dimension.Z]
            maxz = p[stl.base.Dimension.Z]
        else:
            maxx = max(p[stl.base.Dimension.X], maxx)
            minx = min(p[stl.base.Dimension.X], minx)
            maxy = max(p[stl.base.Dimension.Y], maxy)
            miny = min(p[stl.base.Dimension.Y], miny)
            maxz = max(p[stl.base.Dimension.Z], maxz)
            minz = min(p[stl.base.Dimension.Z], minz)
    return minx, maxx, miny, maxy, minz, maxz

main_body = mesh.Mesh.from_file(sys.argv[1])

minx, maxx, miny, maxy, minz, maxz = find_mins_maxs(main_body)

# the logic is easy from there

print("File:", sys.argv[1])
print("X:", maxx - minx)
print("Y:", maxy - miny)
print("Z:", maxz - minz)

