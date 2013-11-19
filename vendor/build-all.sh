#!/bin/sh

ROOT=${PWD}
echo "building DCMTK"
./build-dcmtk

echo "building OSG"
./build-osg
