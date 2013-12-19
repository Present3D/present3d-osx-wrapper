#!/bin/sh

ROOT=${PWD}

# create cmake-configuration for osg
mkdir -p "${ROOT}/lua-build"
cd ${ROOT}/lua-build
/usr/bin/cmake -G Xcode \
-D CMAKE_INSTALL_PREFIX="${ROOT}/lua-build" \
 ../lua-source

#build osg
/usr/bin/xcodebuild -configuration "Release" -target "ALL_BUILD"
/usr/bin/xcodebuild -configuration "Release" -target "install"
