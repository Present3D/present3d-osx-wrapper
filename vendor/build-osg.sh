#!/bin/sh

ROOT=${PWD}

# create cmake-configuration for osg
cd ${ROOT}/osg-build
/usr/bin/cmake -G Xcode \
-D OSG_COMPILE_FRAMEWORKS:BOOL=1 \
-D OSG_COMPILE_FRAMEWORKS_INSTALL_NAME_DIR:STRING=@executable_path/../Frameworks \
-D OSG_WINDOWING_SYSTEM:STRING=Cocoa \
-D OSG_BUILD_PLATFORM_IPHONE:BOOL=0 \
-D CMAKE_OSX_ARCHITECTURES:STRING=x86_64 \
-D CMAKE_INSTALL_PREFIX="$ROOT/osg-build" \
-D OSG_PLUGINS=osgPlugins \
-D OSG_CXX_LANGUAGE_STANDARD:STRING=C++98 \
CMAKE_OSX_SYSROOT:STRING=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.9.sdk ../osg-source

#build osg
/usr/bin/xcodebuild -configuration "Release" -target "ALL_BUILD"
/usr/bin/xcodebuild -configuration "Release" -target "install"