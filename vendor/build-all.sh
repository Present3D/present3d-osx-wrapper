#!/bin/sh

ROOT=${PWD}

echo "building freetype"
sh ./build-freetype.sh

echo "building jpeg"
sh ./build-jpeg.sh

echo "building png"
sh ./build-png.sh

echo "building tiff"
sh ./build-tiff.sh

echo "building libvnc"
sh ./build-libvnc.sh

echo "building dcmtk"
sh ./build-dcmtk.sh


echo "building OSG"
sh ./build-osg.sh
